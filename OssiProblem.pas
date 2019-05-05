PROGRAM Ossi;

TYPE 
	Person   = (anton, berta, clemens, doris); 
	Visitors = ARRAY[Person] OF BOOLEAN;
    
VAR 
	v: Visitors; (*v[p] = TRUE ? person p will attend Ossis party*) 
	a, b, c, d: BOOLEAN;

FUNCTION Valid(v: Visitors): BOOLEAN; 
	BEGIN
	(*check all conditions and return TRUE if v holds a valid combination*)
	Valid := 	(v[anton] OR v[berta] OR v[clemens] OR v[doris])
    				AND (NOT(v[anton] AND v[doris]))
    				AND ((v[berta] AND v[clemens]) OR (NOT v[clemens] AND NOT v[berta]) OR (v[clemens] AND NOT v[berta]))
    				AND (NOT (v[anton] AND v[clemens] AND v[berta]))
    				AND NOT (NOT v[anton] AND v[clemens] AND v[doris]); 
	END; (*Valid*)

BEGIN (*Ossi*) 
	
	WriteLn('Moegliche Besuchergruppe/n:');
	
	FOR a := FALSE TO TRUE DO BEGIN 
		v[anton] := a;
		
		FOR b := FALSE TO TRUE DO BEGIN
			v[berta] := b;
			
			FOR c := FALSE TO TRUE DO BEGIN 
				v[clemens] := c;
				
				FOR d := FALSE TO TRUE DO BEGIN 
					v[doris] := d;
					
					IF Valid(v) THEN BEGIN 
					(*print results*)
						IF v[anton] THEN
							Write('Anton ');
						IF v[berta] THEN
							Write('Berta ');
						IF v[clemens]THEN
							Write('Clemens ');
						IF v[doris] THEN
							Write('Doris ');
						WriteLn();
					END; (*IF*) 
					
				END; (*FOR*) 
			END; (*FOR*) 
		END; (*FOR*) 
	END; (*FOR*) 
END. (*Ossi*)