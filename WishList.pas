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

	OrderNodePtr = ^OrderNode;
	OrderNode = RECORD
		next: OrderNodePtr;
		item: STRING;
		n: INTEGER;
	END; (*RECORD*)
	OrderListPtr = OrderNodePtr;
	
	ItemNodePtr = ^ItemNode;
	ItemNode = RECORD
		next: ItemNodePtr;
		item: STRING;
	END;
	ItemListPtr = ItemNodePtr;

	DelivNodePtr = ^DelivNode;
	DelivNode = RECORD
		next: DelivNodePtr;
		name: STRING;
		items: ItemListPtr;
	END; (*RECORD*)
	DelivListPtr = DelivNodePtr;

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

PROCEDURE editLine(VAR name, item: STRING; s: STRING);
	BEGIN
		name := Copy(s, 1, Pos(': ', s)-1);
		item := Copy(s, Pos(': ', s)+2, Length(s));
	END;

PROCEDURE Store(VAR WL: WishListPtr; s: STRING);
	VAR 
		name, item: STRING;
	BEGIN
		editLine(name, item, s);
		AppendWL(WL, name, item);
	END;

FUNCTION NewOrderNode(item: STRING; num: INTEGER): OrderNodePtr;
	VAR
		n: OrderNodePtr;
	BEGIN
		New(n);
		n^.next := NIL;
		n^.item := item;
		n^.n := num;
		NewOrderNode := n;
	END;

PROCEDURE AppendOL(VAR OL: OrderListPtr; item: STRING; num: INTEGER);
	VAR
		n, last: OrderNodePtr;
	BEGIN
		n := NewOrderNode(item, num);
		IF OL = NIL THEN
			OL := n
		ELSE BEGIN
			last := OL;
			WHILE last^.next <> NIL DO BEGIN
				last := last^.next;
		END;
			last^.next := n;
		END;
	END;

FUNCTION OrderListOf(WL: WishListPtr): OrderListPtr;
	VAR
		nWL, cWL: WishNodePtr;
		nOL: OrderNodePtr;
		OL: OrderListPtr;
		count: INTEGER;
		contain: BOOLEAN;
	
	BEGIN
		IF WL^.name = '' THEN
		BEGIN
			WriteLn('No List Order possible, WishList empty!');
			HALT;
		END;
		nWL := WL;
		OL := NIL;
		WHILE nWL <> NIL DO
		BEGIN
			(* check if item is member of Order List *)
			nOL := OL;
			contain := TRUE;
			WHILE nOL <> NIL DO
			BEGIN
				IF nOL^.item = nWL^.item THEN
					contain := FALSE;
				nOL := nOL^.next;
			END;
			IF contain THEN
			BEGIN
				cWL := WL;
				count := 0;
				WHILE cWL <> NIL DO
				BEGIN
					IF cWL^.item = nWL^.item THEN
						count := count + 1;
					cWL := cWL^.next;
				END;
					AppendOL(OL, nWL^.item, count);
			END;
			nWL := nWL^.next;
		END;
		OrderListOf := OL;
	END;

FUNCTION NewItemNode(item: STRING): ItemNodePtr;
	VAR
		n: ItemNodePtr;
	BEGIN
		New(n);
		n^.next := NIL;
		n^.item := item;
		NewItemNode := n;
	END;

PROCEDURE AppendIL(VAR IL: ItemListPtr; item: STRING);
	VAR
		n, last: ItemNodePtr;
	BEGIN
		n := NewItemNode(item);
		IF IL = NIL THEN
			IL := n
		ELSE BEGIN
			last := IL;
			WHILE last^.next <> NIL DO BEGIN
				last := last^.next;
		END;
			last^.next := n;
		END;
	END;

FUNCTION NewDelivNode(name: STRING; items: ItemListPtr): DelivNodePtr;
	VAR
		n: DelivNodePtr;
	BEGIN
		New(n);
		n^.next := NIL;
		n^.name := name;
		n^.items := items;
		NewDelivNode := n;
	END;


PROCEDURE AppendDL(VAR DL: DelivListPtr; name: STRING; items: ItemListPtr);
	VAR
		n, last: DelivNodePtr;
	BEGIN
		n := NewDelivNode(name, items);
		IF DL = NIL THEN
			DL := n
		ELSE BEGIN
			last := DL;
			WHILE last^.next <> NIL DO BEGIN
				last := last^.next;
			END;
			last^.next := n;
		END;
	END;


FUNCTION DeliveryListOf(WL: WishListPtr): DelivListPtr;
	VAR
		DL: DelivListPtr;
		nDL: DelivNodePtr;
		nWL, cWL: WishNodePtr;
		contain: BOOLEAN;
		
	BEGIN
		IF WL^.name = '' THEN
		BEGIN
			WriteLn('No Delivery List possible, WishList empty!');
			HALT;
		END;
		
		DL := NIL;
		nWL := WL;
		
		WHILE nWL <> NIL DO
		BEGIN
			(* check if item is member of Delivery List *)
			nDL := DL;
			contain := TRUE;

			WHILE nDL <> NIL DO
			BEGIN
				IF nWL^.name = nDL^.name THEN
					contain := FALSE;
				nDL := nDL^.next;
			END;
			
			(* IF item is no member of Delivey List *)
			IF contain THEN
			BEGIN
				(* create New Entry *)
				AppendDL(DL, nWL^.name, NIL);
				
				
				nDL := DL;
				WHILE nDL^.name <> nWL^.name DO
				BEGIN
					nDL := nDL^.next;
				END;
				
				(* create ItemList *)
				cWL := WL;
				WHILE cWL <> NIL DO
				BEGIN
					IF nWL^.name = cWL^.name THEN
						AppendIL(nDL^.items, cWL^.item);
					cWL := cWL^.next;
				END;
			END;
			nWL := nWL^.next;
		END;
		DeliveryListOf := DL;
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

PROCEDURE WriteOL(OL: OrderListPtr);
	VAR
		n: OrderNodePtr;
	
	BEGIN
		n := OL;
		WriteLn;
		WriteLn('| Show Saved OrderedList |');
		WHILE n <> NIL DO
		BEGIN
			WriteLn('Item -> ', n^.item, ', amount: ', n^.n);
			n := n^.next;
		END;
		WriteLn('-|');
		WriteLn;
	END;

PROCEDURE WriteDL(DL: DelivNodePtr);
	VAR
		n: DelivNodePtr;
	
	BEGIN
		n := DL;
		WriteLn;
		WriteLn('| Show Saved DeliveryList |');
		WHILE n <> NIL DO
		BEGIN
			WriteLn('-> ', n^.name);
			Write('Items: ');
			WHILE n^.items <> NIL DO
			BEGIN
				Write( n^.items^.item, ' ');
				n^.items := n^.items^.next;
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
	WL: WishListPtr;
	OL: OrderListPtr;
	DL: DelivListPtr;

BEGIN (*WLA*)

	Assign(wishesFile, 'Wishes.txt');
	Reset(wishesFile);
	REPEAT
		ReadLn(wishesFile, s);
		WriteLn(s);

		(* store whish s in WishList *)
		Store(WL, s);

	UNTIL Eof(wishesFile);
	Close(wishesFile);

	(* show stored list *)
	WriteWL(WL);

	(*to do: call ComputeOrderList    and write orders*)
	OL := OrderListOf(WL);
	WriteOL(OL);
	(*to do: call ComputeDeliveryList and write deliveries*)
	DL := DeliveryListOf(WL);
	WriteDL(DL);
	(*ReadLn; wait for CR*)
	ReadLn;
	
END. (*WLA*)