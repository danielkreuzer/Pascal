PROGRAM TreeFire;

FUNCTION WaysR(h: INTEGER): INTEGER;
	VAR
		ways: INTEGER;
	BEGIN
		ways := 0;
		
		IF h <> 0 THEN
		BEGIN
			ways := WaysR(h-1) + (4 * (h-1));
			WaysR := ways;
		END
		ELSE
			WaysR := ways + 3
	END;

FUNCTION WaysI(h: INTEGER): INTEGER;
	BEGIN
		WaysI := ((((2*h)+1)-3)*h)+3;
	END;

VAR
	h: INTEGER;

BEGIN
	
	(* --- *) (* Test *) (* --- *)
	
	(* --- *) WriteLn('Test recursively'); (* --- *)
	
	WriteLn('Tree with h = 1 -> letters 3');
	h := 1;
	WriteLn('Ways to burn Tree down: ', WaysR(h), ', Expected: 3');
	WriteLn('Tree with h = 2 -> letters 5');
	h := 2;
	WriteLn('Ways to burn Tree down: ', WaysR(h), ', Expected: 7');
	WriteLn('Tree with h = 3 -> letters 7');
	h := 3;
	WriteLn('Ways to burn Tree down: ', WaysR(h), ', Expected: 15');
	WriteLn('Tree with h = 6 -> letters 11');
	h := 6;
	WriteLn('Ways to burn Tree down: ', WaysR(h), ', Expected: 63');
	
	WriteLn;
	(* --- *) WriteLn('Test iterativ'); (* --- *)
	
	WriteLn('Tree with h = 1 -> letters 3');
	h := 1;
	WriteLn('Ways to burn Tree down: ', WaysI(h), ', Expected: 3');
	WriteLn('Tree with h = 2 -> letters 5');
	h := 2;
	WriteLn('Ways to burn Tree down: ', WaysI(h), ', Expected: 7');
	WriteLn('Tree with h = 3 -> letters 7');
	h := 3;
	WriteLn('Ways to burn Tree down: ', WaysI(h), ', Expected: 15');
	WriteLn('Tree with h = 6 -> letters 11');
	h := 6;
	WriteLn('Ways to burn Tree down: ', WaysI(h), ', Expected: 63');
	
	
END.