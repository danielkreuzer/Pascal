PROGRAM CandlesOnTree;

FUNCTION CandlesR(h: INTEGER): INTEGER;
	VAR
		candles: INTEGER;
		
	BEGIN
		candles := 0;
		IF h <> 0 THEN
		BEGIN
			candles := 3 * CandlesR(h-1) + 1;
		END;
		
		CandlesR := candles;
	END;

FUNCTION CandlesI(h: INTEGER): INTEGER;
	VAR
		candles: INTEGER;
	
	BEGIN
		candles := 0;
		
		WHILE h <> 0 DO
		BEGIN
			candles := 3 * candles + 1;
			h := h - 1;
		END;
		
		CandlesI := candles;
	END;


VAR
	h: INTEGER;

BEGIN
	
	(* --- *) (* Test *) (* --- *)
	
	(* --- *) WriteLn('Test recursively'); (* --- *)
	
	WriteLn('Tree with h = 1');
	h := 1;
	WriteLn('Candles: ', CandlesR(h), ', Expected: 1');
	WriteLn('Tree with h = 3');
	h := 3;
	WriteLn('Candles: ', CandlesR(h), ', Expected: 13');
	WriteLn('Tree with h = 6');
	h := 6;
	WriteLn('Candles: ', CandlesR(h), ', Expected: 364');
	WriteLn('Tree with h = 0');
	h := 0;
	WriteLn('Candles: ', CandlesR(h), ', Expected: 0');

	WriteLn;
	(* --- *) WriteLn('Test iterative'); (* --- *)
	
	WriteLn('Tree with h = 1');
	h := 1;
	WriteLn('Candles: ', CandlesI(h), ', Expected: 1');
	WriteLn('Tree with h = 3');
	h := 3;
	WriteLn('Candles: ', CandlesI(h), ', Expected: 13');
	WriteLn('Tree with h = 6');
	h := 6;
	WriteLn('Candles: ', CandlesI(h), ', Expected: 364');
	WriteLn('Tree with h = 0');
	h := 0;
	WriteLn('Candles: ', CandlesI(h), ', Expected: 0');

END.