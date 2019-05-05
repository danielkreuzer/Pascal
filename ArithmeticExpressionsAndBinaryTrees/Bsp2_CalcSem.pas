UNIT Bsp2_CalcSem;

INTERFACE
	TYPE
		NodePtr = ^Node;
		Node = RECORD
			left, right: NodePtr;
			txt: STRING;
		END;
		TreePtr = NodePtr;
	
	VAR 
		success : BOOLEAN;

	PROCEDURE S(VAR binTree: TreePtr);
	PROCEDURE InitSyn(VAR t: TreePtr);
	PROCEDURE InOrder(VAR t: TreePtr);
	PROCEDURE PreOrder(VAR t: TreePtr);
	PROCEDURE PostOrder(VAR t: TreePtr);
	FUNCTION ValueOf(VAR t: TreePtr): INTEGER;
  PROCEDURE DisposeTree(VAR t: TreePtr);
  
IMPLEMENTATION
	USES Bsp1_CalcLex;

  FUNCTION NewNode(val: STRING): NodePtr;
  VAR
    n: NodePtr;
  BEGIN
    New(n);
    n^.txt := val;
    n^.left := NIL;
    n^.right := NIL;
    NewNode := n;
  END;

  PROCEDURE DisposeTree(VAR t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      DisposeTree(t^.left);
      DisposeTree(t^.right);
      Dispose(t);
      t := NIL;
    END;
  END;

	PROCEDURE InOrder(VAR t: TreePtr);
	BEGIN
		IF t <> NIL THEN
		BEGIN
			InOrder(t^.left);
			Write(t^.txt);
			InOrder(t^.right);
		END;
	END;
	
	PROCEDURE PreOrder(VAR t: TreePtr);
	BEGIN
		IF t <> NIL THEN
		BEGIN
			Write(t^.txt);
			PreOrder(t^.left);
			PreOrder(t^.right);
		END;
	END;
	
	PROCEDURE PostOrder(VAR t: TreePtr);
	BEGIN
		IF t <> NIL THEN
		BEGIN
			PostOrder(t^.left);
			PostOrder(t^.right);
			Write(t^.txt);
		END;
	END;
	
	FUNCTION ValueOf(VAR t: TreePtr): INTEGER;
	VAR
		valLeft, ValRight: INTEGER;
		i, val, movement: INTEGER;
	BEGIN
		IF t <> NIL THEN
		BEGIN
			valLeft := ValueOf(t^.left);
			valRight := ValueOf(t^.right);
			CASE t^.txt[2] OF
				'+': BEGIN ValueOf := valLeft + valRight; END;
				'-': BEGIN ValueOf := valLeft - valRight; END;
				'*': BEGIN ValueOf := valLeft * valRight; END;
				'/': BEGIN ValueOf := valLeft DIV valRight; END;
				ELSE
					BEGIN
						val := 0;
						movement := 1;
						FOR i := Length(t^.txt) DOWNTO 2 DO
						BEGIN
							val := val + ((Ord(t^.txt[i]) - Ord('0')) * movement);
							movement := movement * 10;
						END;
						IF Ord(t^.txt[1]) = 45 THEN
							val := val * -1;
						
						ValueOf := val;
					END;
			END;
		END
		ELSE
			ValueOf := 0;
	END;


	PROCEDURE Expr(VAR e : TreePtr); FORWARD;
	PROCEDURE Term(VAR t : TreePtr); FORWARD;
	PROCEDURE Fact(VAR f : TreePtr); FORWARD;

	PROCEDURE S(VAR binTree: TreePtr);
	BEGIN
		NewSy; (* read first symbol *)
		Expr(binTree);
		IF NOT success THEN Exit;
		IF sy <> eofSy THEN
		BEGIN
			success := FALSE;
			Exit;
		END;
	END;

	PROCEDURE Expr(VAR e : TreePtr);
	VAR 
			n: NodePtr;
			t: TreePtr;
	BEGIN
		Term(e);
		IF NOT success THEN Exit;
		WHILE (sy = plusSy) OR (sy = minusSy) DO
		BEGIN
			CASE sy OF
				plusSy: BEGIN 
									NewSy; (* skip + *)
									t := NIL;
									Term(t);
									IF NOT success THEN Exit;
									(* SEM *)
									n := NewNode(' + ');
									n^.left := e;
									n^.right := t;
									e := n;
									(* ENDSEM *)
								END;
				minusSy: BEGIN
									NewSy; (* skip - *)
									t := NIL;
									Term(t);
									IF NOT success THEN Exit;
									(* SEM *)
									n := NewNode(' - ');
									n^.left := e;
									n^.right := t;
									e := n;
									(* ENDSEM *)
								 END;
			END; (* CASE *)
		END; (* WHILE *)
	END;

	PROCEDURE Term(VAR t : TreePtr);
	VAR 
		n: NodePtr;
		f: TreePtr;
	BEGIN
		Fact(t);
		IF NOT success THEN Exit;
		WHILE (sy = mulSy) OR (sy = divSy) DO
		BEGIN
			CASE sy OF
				mulSy: BEGIN 
									NewSy;
									f := NIL;
									Fact(f);
									IF NOT success THEN Exit;
									(* SEM *)
									n := NewNode(' * ');
									n^.left := t;
									n^.right := f;
									t := n;
									(* ENDSEM *)
							 END;
				divSy: BEGIN
									NewSy;
									f := NIL;
									Fact(f);
									IF NOT success THEN Exit;
									(* SEM *)
									n := NewNode(' / ');
									n^.left := t;
									n^.right := f;
									t := n;
									(* ENDSEM *)
							 END;
			END; (* CASE *)
		END;
	END;

	(* 
	 * Fact = ['+' | '-'] number | '(' Expr ')' .
	 *)
	PROCEDURE Fact(VAR f : TreePtr);
	VAR 
		sign, value : STRING;
	BEGIN
		(* SEM *) sign := ' '; (* ENDSEM *)
		CASE sy OF
			plusSy, minusSy, numSy : BEGIN 
								IF sy = plusSy THEN
								BEGIN
									NewSy;
									IF (sy = plusSy) OR (sy = minusSy) THEN
									BEGIN
										success := FALSE;
										Exit;
									END;
								END 
								ELSE IF sy = minusSy THEN
								BEGIN
									NewSy;
									IF (sy = plusSy) OR (sy = minusSy) THEN
									BEGIN
										success := FALSE;
										Exit;
									END;
									(* SEM *) sign := '-'; (* ENDSEM *)
								END;
								(* SEM *)
								IF sy <> numSy THEN
								BEGIN
									success := FALSE;
									Exit; 
								END;
								value := sign + numberVal;
								f := NewNode(value);
								(* ENDSEM *)
								NewSy; (* skip num *)
							END;
			leftParSy : BEGIN
									NewSy; (* skip ( *)
									Expr(f);
									IF NOT success THEN Exit;
									IF sy <> rightParSy THEN
									BEGIN
										success := FALSE;
										Exit;
									END;
									NewSy; (* skip ) *)
								END;
			ELSE
			BEGIN 
				success := FALSE;
				Exit; 
			END;
		END; (* CASE *) 
	END;


	PROCEDURE InitSyn(VAR t: TreePtr);
	BEGIN
		success := TRUE;
		t := NIL;
	END;

BEGIN
END.