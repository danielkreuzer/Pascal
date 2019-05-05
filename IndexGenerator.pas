PROGRAM IndexGenerator;

USES
	WinCrt, Timer;
	
CONST
	MaxSize = 200;
	EF = CHR(0);         (*end of file character*)
	maxWordLen = 30;     (*max. number of characters per word*)
	chars = ['a' .. 'z', 'ä', 'ö', 'ü', 'ß',
					 'A' .. 'Z', 'Ä', 'Ö', 'Ü'];

TYPE
	Word = STRING[maxWordLen];
	
	LineNrPtr = ^LineNrNode;
	LineNrNode = RECORD
		number: INTEGER;
		next: LineNrPtr;
	END;
	
	HashPtr = ^HashNode;
	HashNode = RECORD
		word: STRING;
		lineNr:	LineNrPtr;
		next: HashPtr;
	END;
	HashList = HashPtr;
	
	SortNode = RECORD
		word: STRING;
		lineNr:	LineNrPtr;
	END;

	
	HashTableArray = ARRAY[0..MaxSize] OF HashList;
	SortTableArray = ARRAY[1..1] OF SortNode;
	
	
VAR
	txt: TEXT;           (*text file*)
	curLine: STRING;     (*current line from file txt*)
	curCh: CHAR;         (*current character*)
	curLineNr: INTEGER;  (*current line number*)
	curColNr: INTEGER;   (*current column number*)
	HashTable: HashTableArray;
	SortTable: ^SortTableArray;

(*-------------------------------------------------------------------*)
PROCEDURE InitHashTable;
	VAR
		i: INTEGER;
	BEGIN
		FOR i := 0 TO MaxSize DO
		BEGIN
			HashTable[i] := NIL;
		END;
	END;

PROCEDURE InitSortTable(numElements: LONGINT);
	BEGIN
		GetMem(SortTable, numElements * SIZEOF(SortNode));
	END;

FUNCTION NewLineNrNode(x: INTEGER): LineNrPtr;
	VAR
		n: LineNrPtr;
	BEGIN
		New(n);
		n^.number := x;
		n^.next := NIL;
		NewLineNrNode := n;
	END;

FUNCTION NewHashNode(x: STRING): HashPtr;
	VAR
		n: HashPtr;
	BEGIN
		New(n);
		n^.word := x;
		n^.lineNr := NIL;
		n^.next := NIL;
		NewHashNode := n;
	END;

PROCEDURE AddToHashTable(key: INTEGER; w: HashPtr; lnr: LineNrPtr);
	VAR
		np: HashPtr;
		lp: LineNrPtr;
	BEGIN
		IF HashTable[key] = NIL THEN
		BEGIN
			w^.lineNr := lnr;
			HashTable[key] := w;
		END
		ELSE
		BEGIN
			np := HashTable[key];
			WHILE (np^.next <> NIL) AND (np^.word <> w^.word) DO
				np := np^.next;
			IF np^.word <> w^.word THEN
			BEGIN
				w^.lineNr := lnr;
				np^.next := w;
			END
			ELSE (*np^.word = w^.word*)
			BEGIN
				lp := np^.lineNr;
				WHILE lp^.next <> NIL DO
					lp := lp^.next;
				lp^.next := lnr;
			END;
		END;
	END;
(*-------------------------------------------------------------------*)
FUNCTION LowerCase(ch: CHAR): STRING;
  BEGIN
    CASE ch OF
      'A'..'Z': LowerCase := CHR(ORD(ch) + (ORD('a') - ORD('A')));
      'Ä', 'ä': LowerCase := 'ae';
      'Ö', 'ö': LowerCase := 'oe';
      'Ü', 'ü': LowerCase := 'ue';
      'ß':      LowerCase := 'ss';
      ELSE (*all the others*)
                LowerCase := ch;
      END; (*CASE*)
  END; (*LowerCase*)

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
(*-------------------------------------------------------------------*)
PROCEDURE BuiltHashTable;
	VAR
		txtName: STRING;
    w: Word;        (*current word*)
    lnr: INTEGER;   (*line number of current word*)
    n: LONGINT;     (*number of words*)
    key: INTEGER;		(*HashKey*)
    i: INTEGER;
    
	BEGIN
		  Write('IndexGen: index generation for text file ');
		
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

		  GetNextWord(w, lnr);
		  n := 0;
		  WHILE Length(w) > 0 DO BEGIN
		  	key := 0;
		  	FOR i := 1 TO Length(w) DO
		  		key := (31 * key + Ord(w[i])) MOD (MaxSize-1);
				AddToHashTable(key, NewHashNode(w), NewLineNrNode(lnr));
		    n := n + 1;
		    GetNextWord(w, lnr);
		  END; (*WHILE*)
		
		  WriteLn('HashSavingProzess completed!');
		  WriteLn('number of words: ', n);
		  Close(txt);
	END;

PROCEDURE SaveInSortTable;
	VAR
		i: INTEGER;
		j: LONGINT;
		np: HashPtr;
	BEGIN
		j := 1;
		FOR i := 0 TO MaxSize DO
		BEGIN
			np := HashTable[i];
			WHILE np <> NIL DO
			BEGIN
				(*$R-*)
				SortTable^[j].word := np^.word;
				SortTable^[j].lineNr := np^.lineNr;
				(*$R+*)
				j := j + 1;
				np := np^.next;
			END;
		END;
	END;

PROCEDURE SortSortTable(l, u: LONGINT);
	VAR
		p: STRING;
		i, j: LONGINT;
		tmp: SortNode;
	BEGIN
		IF l < u THEN
		BEGIN
			(* at least two elements *)
			(*$R-*)
			p := SortTable^[l + (u - l) DIV 2].word; (* use first element as pivot *)
			(*$R+*)
			i := l;
			j := u;
			REPEAT
				(*$R-*)
				WHILE SortTable^[i].word < p DO Inc(i);
				WHILE p < SortTable^[j].word DO Dec(j);
				(*$R+*)
				IF i <= j THEN
				BEGIN
					IF i <> j THEN
					BEGIN
						(*$R-*)
						tmp := SortTable^[j];
						SortTable^[j] := SortTable^[i];
						SortTable^[i] := tmp;
						(*$R+*)
						END;
					Inc(i);
					Dec(j);
				END;
			UNTIL i > j;
			SortSortTable(l, j);
			SortSortTable(i, u);
		END;
	END;
	
PROCEDURE GenerateN(VAR n: LONGINT); //ForTesting
	VAR
		i: INTEGER;
		np: HashPtr;
	BEGIN
		FOR i := 0 TO MaxSize DO
		BEGIN
			np := HashTable[i];
			WHILE np <> NIL DO
			BEGIN
				n := n + 1;
				np := np^.next;
			END;
		END;
	END;

PROCEDURE ShowSortTable(n: LONGINT);
	VAR
		i: LONGINT;
		np: LineNrPtr;
	BEGIN
		FOR i := 1 TO n DO
		BEGIN
			(*$R-*)
			WriteLn(SortTable^[i].word, ': ');
			np := SortTable^[i].lineNr;
			(*$R+*)
			WHILE np <> NIL DO
			BEGIN
				Write(np^.number, ', ');
				np := np^.next;
			END;
			WriteLn;
		END;
	END;
(*-------------------------------------------------------------------*)
VAR
	n: LONGINT;
	x: STRING;
BEGIN
	StartTimer;
	InitHashTable;
	n := 0;
	BuiltHashTable;
	GenerateN(n);
	InitSortTable(n);
	SaveInSortTable;
	SortSortTable(1, n); 
	WriteLn;
	WriteLn('Read, Hashtable and Sort Process completed!...');
	StopTimer;
	x := ElapsedTime;
	WriteLn('elapsed time:    ', ElapsedTime);
	StartTimer;
	WriteLn;
	WriteLn('Index:');
	ShowSortTable(n);
	WriteLn;
	StopTimer;
	WriteLn('Time before writing Index: ', x, ' Time writing Index: ', ElapsedTime);
	
END.
