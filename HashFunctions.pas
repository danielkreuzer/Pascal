PROGRAM HashFkt;

USES
	{$IFDEF FPC}
		Windows,
	{$ELSE}
		WinTypes, WinProcs,
	{$ENDIF}
		Strings, WinCrt,
		WinGraph, Timer;

CONST
	NUM_BINS = 211; (* Size of HashTable *)
	EF = CHR(0);         (*end of file character*)
	maxWordLen = 30;     (*max. number of characters per word*)
	chars = ['a' .. 'z', 'ä', 'ö', 'ü', 'ß',
					 'A' .. 'Z', 'Ä', 'Ö', 'Ü'];

TYPE
	HashPtr = ^HashNode;
	HashNode = RECORD
		word: STRING;
		next: HashPtr;
	END;
	HashList = HashPtr;

	HashTableArray = ARRAY[0..NUM_BINS-1] OF HashList;
	IntArray = ARRAY[0..NUM_BINS-1] OF INTEGER;
	Word = STRING[maxWordLen];

VAR
	txt: TEXT;           (*text file*)
	curLine: STRING;     (*current line from file txt*)
	curCh: CHAR;         (*current character*)
	curLineNr: INTEGER;  (*current line number*)
	curColNr: INTEGER;   (*current column number*)
	IntHashTable: IntArray;
 
FUNCTION NewHashNode(x: STRING): HashPtr;
	VAR
		n: HashPtr;
	BEGIN
		New(n);
		n^.word := x;
		n^.next := NIL;
		NewHashNode := n;
	END;

PROCEDURE InitHashTable(VAR table: HashTableArray);
	VAR
		i: INTEGER;
	BEGIN
		FOR i := 0 TO NUM_BINS-1 DO
			BEGIN
				table[i] := NIL;		
			END;
	END;

PROCEDURE GetNextChar; (*updates curChar, ...*)
	BEGIN
		IF curColNr < Length(curLine) THEN BEGIN
				curColNr := curColNr + 1;
				curCh := curLine[curColNr]
			END (*THEN*)
		ELSE BEGIN (*curColNr >= Length(curLine)*)
			IF NOT Eof(txt) THEN BEGIN
					ReadLn(txt, curLine);
					curLineNr:= curLineNr + 1;
					curColNr := 0;
					curCh := ' '; (*separate lines by ' '*)
				END (*THEN*)
			ELSE (*Eof(txt)*)
				curCh := EF;
		END; (*ELSE*)
	END; (*GetNextChar*)

PROCEDURE GetNextWord(VAR w: Word; VAR lnr: INTEGER);
	BEGIN
		WHILE (curCh <> EF) AND NOT (curCh IN chars) DO BEGIN
			GetNextChar;
		END; (*WHILE*)
		lnr := curLineNr;
		IF curCh <> EF THEN BEGIN
				w := LowerCase(curCh);
				GetNextChar;
				WHILE (curCh <> EF) AND (curCh IN chars) DO BEGIN
					w := Concat(w , LowerCase(curCh));
					GetNextChar;
				END; (*WHILE*)
			END (*THEN*)
		ELSE (*curCh = EF*)
			w := '';
	END; (*GetNextWord*)

PROCEDURE Draw(hist: IntArray; dc: HDC; r: TRect);
	VAR
		i, j: INTEGER;
		stepX: REAL;
		w, h: INTEGER;
		maxVal: INTEGER;
		x, y: REAL;
		hFactor: REAL;
	BEGIN
		w := r.right - r. left;
		h := r.bottom - r.top;

		maxVal := hist[Low(hist)];

		FOR i := Low(hist) TO High(hist) DO
			IF maxVal < hist[i] THEN
				maxVal := hist[i];

		stepX := w / (High(hist) - Low(hist) + 1);

		hFactor := (h / stepX) / maxVal ;
		x := r.left;
		FOR i := Low(hist) TO High(hist) DO
		BEGIN
			y := r.bottom;
			FOR j := 1 TO Round(hFactor * Hist[i]) DO
			BEGIN
				Ellipse(dc, Round(x), Round(y - stepX), Round(x + stepX), Round(y));
				y := y - stepX;
			END;
			x := x + stepX;
		END;
	END;

PROCEDURE DrawHistogram(dc: HDC; wnd: HWnd; r: TRect);  		
	BEGIN
		Draw(IntHashTable, dc, r);
	END;

PROCEDURE AddToHashTable(VAR HashTable: HashTableArray; key: LONGINT; w: HashPtr);
	VAR
		np: HashPtr;
	BEGIN
		IF HashTable[key] = NIL THEN
		BEGIN
			HashTable[key] := w;
		END
		ELSE
		BEGIN
			np := HashTable[key];
			WHILE (np^.next <> NIL) AND (np^.word <> w^.word) DO
				np := np^.next;
			IF np^.word <> w^.word THEN
			BEGIN
				np^.next := w;
			END;
		END;
	END;

PROCEDURE TransformToHash(VAR hashTable: HashTableArray);
	VAR
		txtName: STRING;
		w: Word;        (*current word*)
		lnr: INTEGER;   (*line number of current word*)
		n: LONGINT;     (*number of words*)
		select: STRING;
		hashCode: INTEGER;
		i: INTEGER;
	BEGIN
		Write('analyse Hashfkt ');

		IF ParamCount = 0 THEN BEGIN
			WriteLn;
			Write('name of text file > ');
			ReadLn(txtName);
		END (*THEN*)
		ELSE BEGIN
			txtName := ParamStr(1);
			WriteLn(txtName);
		END; (*ELSE*)
		WriteLn;

		(*--- read text from text file ---*)
		Assign(txt, txtName);
		Reset(txt);
		curLine := '';
		curLineNr := 0;
		curColNr := 1; (*curColNr > Length(curLine) forces reading of first line*)
		GetNextChar;   (*curCh now holds first character*)

		WriteLn('Witch Hashfkt should be shown?: ([1] good / [2] bad / [3] good)');
		ReadLn(select);
		IF select = '1' THEN
		BEGIN
			GetNextWord(w, lnr);
			n := 0;
			WHILE Length(w) > 0 DO BEGIN
				hashCode := 0;
				FOR i := 1 TO Length(w) DO
				BEGIN
				hashCode := (31 * hashCode + Ord(w[i])) MOD NUM_BINS;
				END;
				AddToHashTable(hashTable, hashCode, NewHashNode(w));
				n := n + 1;
				GetNextWord(w, lnr);
			END; (*WHILE*)
		END
		ELSE IF select = '2' THEN
		BEGIN
			GetNextWord(w, lnr);
			n := 0;
			WHILE Length(w) > 0 DO BEGIN
				hashCode := 0;
				hashCode := ((Ord(w[1]) * 7 + Ord(w[2]) + Length(w)) * 17) MOD NUM_BINS;
				AddToHashTable(hashTable, hashCode, NewHashNode(w));
				n := n + 1;
				GetNextWord(w, lnr);
			END; (*WHILE*)
		END
		ELSE IF select = '3' THEN
		BEGIN
			WHILE Length(w) > 0 DO BEGIN
				hashCode := 0;
				FOR i := 1 TO Length(w) DO
				BEGIN
					hashCode := (2 * hashCode + Ord(w[i]) + Length(w)) MOD NUM_BINS;
				END;
				AddToHashTable(hashTable, hashCode, NewHashNode(w));
				n := n + 1;
				GetNextWord(w, lnr);
			END;
		END
		ELSE
			WriteLn('Not allowed!');
			
		WriteLn('Hashing complete!');
		WriteLn('number of words in textfile: ', n);
		Close(txt);
	END;

PROCEDURE TransformToIntHash(hash: HashTableArray);
	VAR
		i: INTEGER;
		np: HashPtr;
	BEGIN
		FOR i := 0 TO NUM_BINS-1 DO
		BEGIN
			np := hash[i];
			WHILE np <> NIL DO
			BEGIN
			IntHashTable[i] := IntHashTable[i] + 1;
			np := np^.next;
			END;
		END;
	END;
VAR
	HashTable: HashTableArray;
		
BEGIN
	StartTimer;
	InitHashTable(HashTable);
	TransformToHash(HashTable);
	TransformToIntHash(HashTable);
	WriteLn('Transformation complete!');
	StopTimer;
	WriteLn('elapsed time:    ', ElapsedTime);
	WriteLn('Press any key to show graph...');
	ReadLn();
	redrawProc := DrawHistogram;
	WGMain;
END.