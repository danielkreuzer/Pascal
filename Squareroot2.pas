PROGRAM squareRoot;

FUNCTION squrt(x, e: REAL): REAL;
	VAR
		prev_y, y: REAL;
		count: INTEGER;
	
	BEGIN	
		y := 1;
		count := 0;
		
		(* Calculate *)
			REPEAT
				prev_y := y;
				y := 0.5 * (prev_y + x / prev_y);
				count := count + 1;
			UNTIL (e > abs(y - prev_y)) OR (count = 50);
			
		(* Output *)
		IF x < 0 THEN
		BEGIN
			WriteLn('Error, x < 0!');
			squrt := 1;
		END
		ELSE IF count = 50 THEN
		BEGIN
			WriteLn('Error, no convergence after 50 iterations!');
			squrt := 1;
		END
		ELSE
			squrt := y;
	END;

PROCEDURE test(x, e: REAL);
	BEGIN		
		WriteLn('x: ', x:0:8,', real error: ', e:0:8);
		IF squrt(x, e) <> 1 THEN
			WriteLn('Result: ', squrt(x, e):0:8);
	END;

BEGIN
	
	(* Hardcodet Test *)
	test(2132582526885558558658658965, 0.0001);
	WriteLn('Expected: Error, no convergence after 50 iterations!');
	WriteLn;
	
	test(-89, 0.001);
	WriteLn('Expected: Error, x < 0!');
	WriteLn;
	
	test(9, 0.001);
	WriteLn('Expected: ~3');
	WriteLn;

END.