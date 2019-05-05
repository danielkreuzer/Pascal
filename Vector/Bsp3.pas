UNIT Bsp3;

INTERFACE
	CONST
		MaxSize = 200;
	
	TYPE
		NodePtr = ^Node;
		Node = RECORD
			key: STRING;
			value: STRING;
			next: NodePtr;
		END;
		HashTable = ARRAY[0..MaxSize] OF NodePtr;
		
		MapPtr = ^Map;
		Map = OBJECT
			PRIVATE
				container: HashTable;
				contains: INTEGER;
			PUBLIC
				CONSTRUCTOR Init;
				DESTRUCTOR Done; VIRTUAL;
				PROCEDURE Put(key, value: STRING); VIRTUAL;
				PROCEDURE GetValue(key: STRING; VAR value: STRING); VIRTUAL;
				PROCEDURE Remove(key: STRING); VIRTUAL;
				FUNCTION Size: INTEGER; VIRTUAL;
				PROCEDURE Print; VIRTUAL;
				PRIVATE FUNCTION HashCode(key: STRING): INTEGER;
				PRIVATE PROCEDURE InitHash;
				PRIVATE PROCEDURE DisposeHash;
				PRIVATE FUNCTION NewHashNode(key, value: STRING): NodePtr;
		END;
		
IMPLEMENTATION

	CONSTRUCTOR Map.Init;
	BEGIN
		contains := 0;
		Self.InitHash;
	END;
	
	DESTRUCTOR Map.Done;
	BEGIN
		Self.DisposeHash;
	END;
	
	PROCEDURE Map.Put(key, value: STRING);
	VAR
		intKey: INTEGER;
		np, tempNp: NodePtr;
	BEGIN
		intKey := Self.HashCode(key);
		np := NewHashNode(key, value);
		IF Self.container[intKey] = NIL THEN
		BEGIN
			Self.container[intKey] := np;
			Inc(contains);
		END
		ELSE
		BEGIN
			tempNp := Self.container[intKey];
			WHILE (tempNp <> NIL) AND (tempNp^.key <> key) DO
			BEGIN
				tempNp := tempNp^.next;
			END;
			
			IF tempNp = NIL THEN
			BEGIN
				Inc(contains);
				np^.next := Self.container[intKey];
				Self.container[intKey] := np;
			END
			ELSE
			BEGIN
				tempNp^.value := value;
			END;
		END;
	END;
	
	PROCEDURE Map.GetValue(key: STRING; VAR value: STRING);
	VAR
		intKey: INTEGER;
		np: NodePtr;
	BEGIN
		intKey := Self.HashCode(key);
		np := Self.container[intKey];
		
		WHILE (np <> NIL) AND (np^.key <> key) DO
			np := np^.next;
		
		IF np <> NIL THEN
			value := np^.value
		ELSE
			WriteLn('	Key: ', key, ' does not match any entry!');
	END;
	
	PROCEDURE Map.Remove(key: STRING);
	VAR
		intKey: INTEGER;
		np, prev_np: NodePtr;
	BEGIN
		intKey := Self.HashCode(key);
		np := Self.container[intKey];
		
		IF (np <> NIL) AND (np^.key = key) THEN
		BEGIN
			Self.container[intKey] := np^.next;
			Dispose(np);
			Dec(contains);
		END
		ELSE
		BEGIN
			IF np <> NIL THEN
			BEGIN
				prev_np := np;
				np := np^.next;
			END;
			
			WHILE (np <> NIL) AND (np^.key <> key) DO
			BEGIN
				np := np^.next;
				prev_np := prev_np^.next;
			END;

			IF np <> NIL THEN
			BEGIN
				prev_np := np^.next;
				Dispose(np);
				Dec(contains);
			END
			ELSE
				WriteLn('	Key: ', key, ' does not match any entry!');
		END;
	END;
	
	FUNCTION Map.Size: INTEGER;
	BEGIN
		Size := contains;
	END;
	
	PROCEDURE Map.Print;
	VAR
		i: INTEGER;
		np: NodePtr;
	BEGIN
		FOR i := 0 TO MaxSize DO
		BEGIN
			IF Self.container[i] <> NIL THEN
			BEGIN
				WriteLn('	HashCode>>', i);
				np := Self.container[i];
				WHILE np <> NIL DO
				BEGIN
					WriteLn('		', np^.key, '	', np^.value);
					np := np^.next;
				END;
			END;
		END;
	END;

	FUNCTION Map.HashCode(key: STRING): INTEGER;
	VAR
		i, intKey: INTEGER;
	BEGIN
		intKey := 0; 
		FOR i := 1 TO Length(key) DO
			intKey := (31 * intkey + Ord(key[i])) MOD MaxSize;
		HashCode := intKey;
	END;
	
	PROCEDURE Map.InitHash;
	VAR
		i: INTEGER;
	BEGIN
		FOR i := 0 TO MaxSize DO
		BEGIN
			Self.container[i] := NIL;
		END;
	END;
	
	PROCEDURE Map.DisposeHash;
	VAR
		i: INTEGER;
		np: NodePtr;
	BEGIN
		FOR i := 0 TO MaxSize DO
		BEGIN
			WHILE Self.container[i] <> NIL DO
			BEGIN
				np := Self.container[i]^.next;
				Dispose(Self.container[i]);
				Self.container[i] := np;
			END;
		END;
	END;
	
	FUNCTION Map.NewHashNode(key, value: STRING): NodePtr;
	VAR
		n: NodePtr;
	BEGIN
		New(n);
		n^.key := key;
		n^.value := value;
		n^.next := NIL;
		NewHashNode := n;
	END;
	
BEGIN
END.