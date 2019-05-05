UNIT Bsp1_CalcSem;

INTERFACE
	VAR 
		success : BOOLEAN;

	PROCEDURE S; (* read S *)
	PROCEDURE InitSyn;

IMPLEMENTATION
	USES Bsp1_CalcLex;

	PROCEDURE Expr(VAR e : STRING); FORWARD;
	PROCEDURE Term(VAR t : STRING); FORWARD;
	PROCEDURE Fact(VAR f : STRING); FORWARD;

	PROCEDURE S;
	VAR e : STRING;
	BEGIN
		NewSy; (* read first symbol *)
		Expr(e);
		IF NOT success THEN Exit;
		IF sy <> eofSy THEN
		BEGIN
			success := FALSE;
			Exit;
		END;
		(* SEM *)
		Write(e);
		(* ENDSEM *)
	END;

	PROCEDURE Expr(VAR e : STRING);
	VAR 
			t : STRING;
	BEGIN
		Term(e);
		IF NOT success THEN Exit;
		WHILE (sy = plusSy) OR (sy = minusSy) DO
		BEGIN
			CASE sy OF
				plusSy: BEGIN 
									NewSy; (* skip + *)
									Term(t);
									IF NOT success THEN Exit;
									(* SEM *)
									e := ' +' + e + t;
									(* ENDSEM *)
								END;
				minusSy: BEGIN
									NewSy; (* skip - *)
									Term(t);
									IF NOT success THEN Exit;
									(* SEM *)
									e := ' -' + e + t;
									(* ENDSEM *)
								 END;
			END; (* CASE *)
		END; (* WHILE *)
	END;

	PROCEDURE Term(VAR t : STRING);
	VAR f : STRING;
	BEGIN
		Fact(t);
		IF NOT success THEN Exit;
		WHILE (sy = mulSy) OR (sy = divSy) DO
		BEGIN
			CASE sy OF
				mulSy: BEGIN 
								NewSy;
								Fact(f);
								IF NOT success THEN Exit;
								(* SEM *)
								t := ' *' + t + f;
								(* ENDSEM *)
							 END;
				divSy: BEGIN
								NewSy;
								Fact(f);
								IF NOT success THEN Exit;
								(* SEM *)
								t := ' /' + t + f;
								(* ENDSEM *)
							 END;
			END; (* CASE *)
		END;
	END;

	(* 
	 * Fact = ['+' | '-'] number | '(' Expr ')' .
	 *)
	PROCEDURE Fact(VAR f : STRING);
	VAR sign : STRING;
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
									(* SEM *) sign := ' -'; (* ENDSEM *)
								END;
								IF sy <> numSy THEN
								BEGIN
									success := FALSE;
									Exit;
								END;
								(* SEM *)
								f := sign + numberVal;
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


	PROCEDURE InitSyn;
	BEGIN
		success := TRUE;
	END;

BEGIN
END.