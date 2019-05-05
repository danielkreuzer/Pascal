PROGRAM SearchIt;
(*$B+*)

FUNCTION IsElement(a: ARRAY OF INTEGER; x: INTEGER): BOOLEAN; 
	VAR 
		i, i_1: INTEGER; 
	BEGIN 
		i := 0;
		i_1 := 0;
		
		WHILE (i_1 <= High(a)) DO
		BEGIN
			IF (a[i_1] <> x) THEN
				i := i + 1;
				
			i_1 := i_1 + 1;
		END;
		
		IsElement := (i <= High(a)); 
		
	END;

VAR
	a: ARRAY[1..3] OF INTEGER;
	
BEGIN
	
	WriteLn('Feed Array a with 1, 2, 3');
	a[1] := 1;
	a[2] := 2;
	a[3] := 3;
	WriteLn();
	
	WriteLn('Is Element 1 in Array a?: ', IsElement(a, 1), ' ,expected: TRUE');
	WriteLn('Is Element 2 in Array a?: ', IsElement(a, 2), ' ,expected: TRUE');
	WriteLn('Is Element 4 in Array a?: ', IsElement(a, 4), ' ,expected: FALSE');

END.