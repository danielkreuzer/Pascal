(* WLA:                                    HDO, 2016-12-06
   ---
   Wish list analyzer for the Christind.
==========================================================*)
PROGRAM WLA;

TYPE
	WishNodePtr = ^WishNode;
	WishNode = RECORD
		next: WishNodePtr;
		name: STRING;
		item: STRING;
	END; (*RECORD*)
	WishListPtr = WishNodePtr;
	
	NameNodePtr = ^NameNode;
		NameNode = RECORD
			next: NameNodePtr;
			name: STRING;
		END; (*RECORD*)
	NameListPtr = NameNodePtr;
	
	WishesNodePtr = ^WishesNode;
	WishesNode = RECORD
		prev: WishesNodePtr;
		next: WishesNodePtr;
		item: STRING;
		n: INTEGER;
		wishers: NameListPtr;
	END;
	WishesListPtr = WishesNodePtr;

FUNCTION NewWishNode(name, item: STRING): WishNodePtr;
	VAR
		n: WishNodePtr;
	BEGIN
		New(n);
		n^.next := NIL;
		n^.name := name;
		n^.item := item;
		NewWishNode := n;
	END;
	
FUNCTION NewWishesNode(item: STRING; val: INTEGER; wishers: NameListPtr): WishesNodePtr;
	VAR
		n: WishesNodePtr;
	BEGIN
		New(n);
		n^.prev := NIL;
		n^.next := NIL;
		n^.item := item;
		n^.n := val;
		n^.wishers := wishers;
		NewWishesNode := n;
	END;

PROCEDURE InitWishesList(VAR wl: WishesListPtr);
	BEGIN
		IF wl <> NIL THEN
		BEGIN
			WriteLn('Cannot init cyclic WL!');
			HALT;
		END;
		wl := NewWishesNode(' ', 0, NIL);
		wl^.prev := wl;
		wl^.next := wl;
	END;
	
FUNCTION NewNameNode(name: STRING): NameNodePtr;
	VAR
		n: NameNodePtr;
	BEGIN
		New(n);
		n^.name := name;
		n^.next := NIL;
		NewNameNode := n;
	END;

PROCEDURE AppendWishesNode(VAR wl: WishesListPtr; item: STRING; val: INTEGER; wishers: NameListPtr);
	VAR
		n: WishesNodePtr;
	BEGIN
		n := NewWishesNode(item, val, wishers);
		n^.prev := wl^.prev;
		n^.next := wl;
		wl^.prev := n;
		n^.prev^.next := n;
	END;

PROCEDURE AppendNameNode(VAR nl: NameListPtr; name: STRING);
	VAR
		nnl: NameNodePtr;
		new: NameNodePtr;
	BEGIN
		new := NewNameNode(name);
		IF nl = NIL THEN
			nl := new
		ELSE
		BEGIN
			nnl := nl;
			WHILE nnl^.next <> NIL DO
			BEGIN
				nnl := nnl^.next;
			END;
			nnl^.next := new;
		END;
	END;

PROCEDURE AppendWL(VAR WL: WishListPtr; name, item: STRING);
	VAR
		n, last: WishNodePtr;
	BEGIN
		n := NewWishNode(name, item);
		IF WL = NIL THEN
			WL := n
		ELSE BEGIN
			last := WL;
			WHILE last^.next <> NIL DO BEGIN
				last := last^.next;
		END;
			last^.next := n;
		END;
	END;

PROCEDURE editLine(VAR word: STRING; VAR name: BOOLEAN; s: STRING);
	BEGIN
		name := FALSE;
		IF s[Length(s)] = ':' THEN
		BEGIN
			word := Copy(s, 1, Length(s)-1);
			name := TRUE;
		END
		ELSE
			word := s;
	END;

PROCEDURE Store(VAR WL: WishListPtr; VAR name: STRING; s: STRING);
	VAR 
		word: STRING;
		isName: BOOLEAN;
	BEGIN
		editLine(word, isName, s);
		IF isName THEN
		BEGIN
			name := word;
		END
		ELSE
			AppendWL(WL, name, word);
	END;

PROCEDURE AmazonOrder(wl: WishListPtr; VAR amazon: WishesListPtr);
	VAR
		nwl: WishNodePtr;
		namazon: WishesListPtr;
	
	BEGIN
		nwl := wl;
		WHILE nwl <> NIL DO
		BEGIN
			namazon := amazon;
			
			WHILE (namazon^.next <> amazon) AND (namazon^.item <> nwl^.item) DO
			BEGIN
				namazon := namazon^.next;
			END;
			
			IF namazon^.next = amazon THEN
			BEGIN
				AppendWishesNode(amazon, nwl^.item, 1, NIL);
				AppendNameNode(amazon^.prev^.wishers, nwl^.name);
			END
			ELSE
			BEGIN
				AppendNameNode(namazon^.wishers, nwl^.name);
				namazon^.n := namazon^.n + 1;
			END;
			nwl := nwl^.next;
		END;
	END;
	
PROCEDURE WriteWL(WL: WishListPtr);
	VAR
		n: WishNodePtr;
	
	BEGIN
		n := WL;
		WriteLn;
		WriteLn('| Show Saved WishList |');
		WHILE n <> NIL DO
		BEGIN
			WriteLn(' ->', n^.name, ' ', n^.item);
			n := n^.next;
		END;
		WriteLn('-|');
		WriteLn;
	END;

PROCEDURE WriteAmazon(amazon: WishesListPtr);
	VAR
		n: WishesNodePtr;
		nw: NameNodePtr;
	BEGIN
		n := amazon^.next;
		WriteLn;
		WriteLn('| Show Saved DeliveryList |');
		WHILE n <> amazon DO
		BEGIN
			WriteLn('-> ', n^.item, ' amount: ', n^.n);
			Write('Whishers: ');
			nw := n^.wishers;
			WHILE nw <> NIL DO
			BEGIN
				Write(nw^.name, ' ');
				nw := nw^.next;
			END;
			WriteLn;
			n := n^.next;
		END;
		WriteLn('-|');
		WriteLn;
	END;
	
VAR
	wishesFile: TEXT;
	s: STRING;
	name: STRING;
	WL: WishListPtr;
	amazon: WishesListPtr;

BEGIN (*WLA*)
	InitWishesList(amazon);
	

	Assign(wishesFile, 'Wishes.txt');
	Reset(wishesFile);
	REPEAT
		ReadLn(wishesFile, s);
		WriteLn(s);

		(* store whish s in WishList *)
		Store(WL, name, s);

	UNTIL Eof(wishesFile);
	Close(wishesFile);

	(* show stored list *)
	WriteWL(WL);
	WriteLn;
	
	(* create Amazon-Order list *)
	AmazonOrder(WL, amazon);
	
	(* show Amazon-Order List *)
	WriteAmazon(amazon);

	ReadLn;
	
END. (*WLA*)