UNIT Bsp1;

INTERFACE
	TYPE
		arr = ARRAY[1..1] OF INTEGER;
		
		VectorPtr = ^Vector;
		Vector = OBJECT
			PRIVATE
				elements: ^arr;
				maxCap: INTEGER;
				counter: INTEGER;
			PUBLIC
				CONSTRUCTOR Init;
				DESTRUCTOR Done; Virtual;
				PROCEDURE Add(value: INTEGER); VIRTUAL;
				PROCEDURE GetElementAt(pos: INTEGER; VAR ok: BOOLEAN; VAR value: INTEGER); VIRTUAL;
				PROCEDURE RemoveElementAt(pos: INTEGER; VAR ok: BOOLEAN; VAR value: INTEGER); VIRTUAL;
				FUNCTION Size: INTEGER; VIRTUAL;
				FUNCTION Capacity: INTEGER; VIRTUAL;
				PROCEDURE Print; VIRTUAL;
				PRIVATE FUNCTION Empty: BOOLEAN;
				PRIVATE PROCEDURE InitElements;
				PRIVATE PROCEDURE DisposeElements;
				PRIVATE PROCEDURE MoveUp(pos: INTEGER);
			END;
	
IMPLEMENTATION
	
	FUNCTION Vector.Empty: BOOLEAN;
	BEGIN
		Empty := counter = 0;
	END;
	
	PROCEDURE Vector.InitElements;
	VAR
		i: INTEGER;
	BEGIN
		GetMem(elements, maxCap * SIZEOF(INTEGER));
		FOR i := 1 TO maxCap DO
		BEGIN
			(*$R-*)
			elements^[i] := 0;
			(*$R+*)
		END;
	END;
	
	PROCEDURE Vector.DisposeElements;
	BEGIN
		FreeMem(elements, maxCap * SIZEOF(INTEGER));
	END;
	
	PROCEDURE Vector.MoveUp(pos: INTEGER);
	VAR
		i: INTEGER;
	BEGIN
		FOR i := pos TO maxCap DO
		BEGIN
			IF (i + 1) > maxCap THEN
				(*$R-*)
				elements^[i] := 0
				(*$R+*)
			ELSE
				(*$R-*)
				elements^[i] := elements^[i+1];
				(*$R+*)
		END;
	END;

	CONSTRUCTOR Vector.Init;
	BEGIN
		(* Init counter, maxCap and dyn. Array *)
		maxCap := 10;
		counter := 0;
		InitElements;
	END;
	
	DESTRUCTOR Vector.Done;
	BEGIN
		(* Dispose dyn. Array *)
		DisposeElements;
	END;

	PROCEDURE Vector.Add(value: INTEGER);
	VAR	
		tempArr: ^arr;
		i: INTEGER;
	BEGIN
		Inc(counter);
		IF counter > maxCap THEN
		BEGIN
			(* Init tempArr and copy elements *)
			GetMem(tempArr, maxCap * SIZEOF(INTEGER));
			FOR i := 1 TO maxCap DO
			BEGIN
				(*$R-*)
				tempArr^[i] := elements^[i];
				(*$R+*)
			END;
			
			(* Dispose elements and create new *)
			(* bigger elements array with tempArr *)
			Self.DisposeElements;
			maxCap := maxCap * 2;
			Self.InitElements;
			FOR i := 1 TO (maxCap DIV 2) DO
			BEGIN
				(*$R-*)
				elements^[i] := tempArr^[i];
				(*$R+*)
			END;
			
			(* Add new element *)
			(*$R-*)
			elements^[counter] := value;
			(*$R+*)
			
			(* Dispose tempArr *)
			FreeMem(tempArr, (maxCap DIV 2) * SIZEOF(INTEGER));
		END
		ELSE
			(*$R-*)
			elements^[counter] := value;
			(*$R+*)
	END;
	
	PROCEDURE Vector.GetElementAt(pos: INTEGER; VAR ok: BOOLEAN; VAR value: INTEGER);
	BEGIN
		IF empty OR (pos > counter) THEN
			ok := FALSE
		ELSE
		BEGIN
			(*$R-*)
			value := elements^[pos];
			(*$R+*)
			ok := TRUE;
		END;
	END;
	
	PROCEDURE Vector.RemoveElementAt(pos: INTEGER; VAR ok: BOOLEAN; VAR value: INTEGER);
	VAR
		i: INTEGER;
		tempArr: ^Arr;
	BEGIN
		IF empty OR (pos > counter) THEN
			ok := FALSE
		ELSE
		BEGIN
			Dec(counter);
			IF counter < (maxCap DIV 2) THEN
			BEGIN
				(* Remove Element *)
				(*$R-*)
				value := elements^[pos];
				(*$R+*)
				ok := TRUE;
				MoveUp(pos);

				(* Init tempArr and copy elements *)
				GetMem(tempArr, (maxCap DIV 2) * SIZEOF(INTEGER));
				FOR i := 1 TO (maxCap DIV 2) DO
				BEGIN
					(*$R-*)
					tempArr^[i] := elements^[i];
					(*$R+*)
				END;

				(* Dispose elements and create new *)
				(* bigger elements array with tempArr *)
				Self.DisposeElements;
				maxCap := maxCap DIV 2;
				Self.InitElements;
				FOR i := 1 TO maxCap DO
				BEGIN
					(*$R-*)
					elements^[i] := tempArr^[i];
					(*$R+*)
				END;

				(* Dispose tempArr *)
				FreeMem(tempArr, maxCap * SIZEOF(INTEGER));
			END
			ELSE
			BEGIN
				(*$R-*)
				value := elements^[pos];
				(*$R+*)
				ok := TRUE;
				MoveUp(pos);
			END;
		END;
	END;
	
	FUNCTION Vector.Size: INTEGER;
	BEGIN
		Size := counter;
	END;
	
	FUNCTION Vector.Capacity: INTEGER;
	BEGIN
		Capacity := maxCap;
	END;

	PROCEDURE Vector.Print;
	VAR
		i: INTEGER;
	BEGIN
		FOR i := 1 TO counter DO
		BEGIN
			(*$R-*)
			WriteLn('	', elements^[i]);
			(*$R+*)
		END;
	END;

BEGIN
END.