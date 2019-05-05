PROGRAM StoryGen;

CONST
	hashSize = 200;
	chars = ['a' .. 'z', 'ä', 'ö', 'ü', 'ß',
					 'A' .. 'Z', 'Ä', 'Ö', 'Ü'];
					 
TYPE
	HashPtr = ^HashNode;
	HashNode = RECORD
		old: STRING;
		new: STRING;
		next: HashPtr;
	END;
	HashList = HashPtr;
	
	HashTableArray = ARRAY[0..hashSize] OF HashList;

FUNCTION NewHashNode(xold: STRING; xnew: STRING): HashPtr;
	VAR
		n: HashPtr;
	BEGIN
		New(n);
		n^.old := xold;
		n^.new := xnew;
		n^.next := NIL;
		NewHashNode := n;
	END; //NewHashNode
	
PROCEDURE InitHashTable(VAR HashTable: HashTableArray);
	VAR
		i: INTEGER;
	BEGIN
		FOR i := 0 TO hashSize DO
			HashTable[i] := NIL;
	END; // InitHashTable

PROCEDURE DisposeHash(VAR HashTable: HashTableArray);
	VAR
		i: INTEGER;
		np: HashPtr;
	BEGIN
		FOR i := 0 TO hashSize DO
		BEGIN
			WHILE HashTable[i] <> NIL DO
			BEGIN
				np := HashTable[i]^.next;
				Dispose(HashTable[i]);
				HashTable[i] := np;
			END;
		END;
	END; // DisposeHash

FUNCTION HashCode(w: STRING): INTEGER;
	VAR
		i, key: INTEGER;
	BEGIN
		key := 0;
		FOR i := 1 TO Length(w) DO
			key := (31 * key + Ord(w[i])) MOD hashSize;
		HashCode := key;
	END; //HashCode

PROCEDURE AddToHashTable(node: HashPtr; VAR HashTable: HashTableArray);
	VAR
		key: INTEGER;
	BEGIN
		key := HashCode(node^.old);
		IF HashTable[key] = NIL THEN
			HashTable[key] := node
		ELSE
		BEGIN
			node^.next := HashTable[key];
			HashTable[key] := node;
		END;
	END; //AddToHashTable

PROCEDURE HashSave(replsLine: STRING; VAR HashTable: HashTableArray);
	VAR
		old, new: STRING;
		position: INTEGER;
	BEGIN
		position := Pos(' ', replsLine);
		IF position = 0 THEN
		BEGIN
			WriteLn('Wrong syntax in replace File!');
			Halt;
		END;
		old := Copy(replsLine, 1, position - 1);
		new := Copy(replsLine, position + 1, Length(replsLine));
		AddToHashTable(NewHashNode(old, new), HashTable);
	END; //HashSave

FUNCTION StoryConverter(oldLine: STRING; HashTable: HashTableArray): STRING;
	VAR
		newLine, word: STRING;
		i: INTEGER;
		np: HashPtr;	
	BEGIN
		word := '';
		newLine := '';
		//create Word
		FOR i := 1 TO Length(oldLine) DO
		BEGIN
			IF oldLine[i] IN chars THEN
				word := word + oldLine[i]
			ELSE
			BEGIN
				IF word <> '' THEN
				BEGIN
					//check if word should be switched
					IF HashTable[hashCode(word)] <> NIL THEN
					BEGIN
						np := HashTable[hashCode(word)];
						WHILE (np^.old <> word) AND (np^.next <> NIL) DO
							np := np^.next;
						IF (np^.next = NIL) AND (np^.old <> word) THEN
							newLine := newLine + word + oldLine[i]
						ELSE
							newLine := newLine + np^.new + oldLine[i];
						word := '';
					END
					ELSE
						newLine := newLine + word + oldLine[i];
						word := '';
				END
				ELSE
					newLine := newLine + oldLine[i];
			END; //IF chars
		END; //FOR
		
		IF word <> '' THEN
		BEGIN
			IF HashTable[hashCode(word)] <> NIL THEN
			BEGIN
				np := HashTable[hashCode(word)];
				WHILE (np^.old <> word) AND (np^.next <> NIL) DO
					np := np^.next;
				IF (np^.next <> NIL) AND (np^.old = word) THEN
					newLine := newLine + np^.new;
			END
			ELSE
				newLine := newLine + word;
		END;
		
		StoryConverter := newLine;
	END; //StoryConverter
	
PROCEDURE ReplaceGen;
	VAR
		repls, oldStory, newStory: TEXT;
		replsLine, oldStLine: STRING;
		HashTable: HashTableArray;
		
	BEGIN
		// check Parameters
		IF ParamCount <> 3 THEN
		BEGIN
			WriteLn('Wrong number of parameters!');
			Halt;
		END;
		
		//check files and open them
		{$I-}
		Assign(repls, ParamStr(1));
		Reset(repls);
		IF IOResult <> 0 THEN
		BEGIN
			WriteLn('Error opening file ', ParamStr(1));
			HALT;
		END;
		Assign(oldStory, ParamStr(2));
		Reset(oldStory);
		IF IOResult <> 0 THEN
		BEGIN
			WriteLn('Error opening file ', ParamStr(2));
			HALT;
		END;
		Assign(newStory, ParamStr(3));
		Rewrite(newStory);
		IF IOResult <> 0 THEN
		BEGIN
			WriteLn('Error rewriting file ', ParamStr(3));
			HALT;
		END;
		{$I+}
		
		//Replace process -------------------------------
		WriteLn('Start Replace process ... ');
		
		//--Read Replace Textfile and save in HashTable--
		InitHashTable(HashTable);
		WHILE NOT EOF(repls) DO
		BEGIN
			ReadLn(repls, replsLine);
			HashSave(replsLine, HashTable);
		END;
		
		//Read Line by Line oldStory and convert it ---
		//into newStory Line with StoryConverter-------
		WHILE NOT EOF(oldStory) DO
		BEGIN
			ReadLn(oldStory, oldStLine);
			WriteLn(newStory, StoryConverter(oldStLine, HashTable));
		END;
		
		//Dispose Hash-Table
		DisposeHash(HashTable);
		
		//Close Textfiles
		Close(repls);
		Close(oldStory);
		Close(newStory);
		WriteLn('Prozess completed!');
	END; //ReplaceGen

BEGIN
//Start replace generator
ReplaceGen;
END.