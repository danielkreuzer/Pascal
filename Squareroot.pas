PROGRAM Quadratwurzel;

VAR
	x, y, e, prev_y: REAL;
	count: INTEGER;
	
BEGIN
	Write('Geben sie eine positive reelle Zahl x und eine postiive reele Fehlerschranke e ein:');
	WriteLn;
	Read(x);
	Read(e);
	y := 1;
	count := 0;
	
	REPEAT
	
		prev_y := y;
		y := 0.5*(prev_y + x / prev_y);
		count := count + 1;
		
	UNTIL (e > abs(y - prev_y)) OR (count = 50);
	
	Writeln;
	
	IF x < 0 THEN
		Write('FEHLER, x < 0!')
		
	ELSE IF count = 50 THEN
		Write('FEHLER, keine Konvergenz nach 50 Iterationen!')
		
	ELSE
	
	Write('Ergebnis: ', y:0:8);
	WriteLn;
	
END.