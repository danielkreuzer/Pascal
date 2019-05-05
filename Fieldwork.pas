PROGRAM Fieldwork;

PROCEDURE Merge(a1, a2: ARRAY OF INTEGER; VAR a3: ARRAY OF INTEGER; VAR n3: INTEGER);
	VAR
		i, i_1, Highar, Lowar: INTEGER;
		alreadyExist1, alreadyExist2: ARRAY[0..32767] OF BOOLEAN;
		
	BEGIN
		FOR i := Low(alreadyExist1) TO High(alreadyExist1) DO
		BEGIN
			alreadyExist1[i] := TRUE;
			alreadyExist2[i] := TRUE;
		END;
		
		IF High(a1) > High(a2) THEN
		BEGIN
			Highar := High(a1);
			Lowar := High(a2);
		END
		ELSE
		BEGIN
			Highar := High(a2);
			Lowar := High(a1)
		END;
		
		FOR i := Low(a1) TO High(a1) DO
			alreadyExist1[a1[i]] := FALSE;
			
		FOR i := Low(a2) TO High(a2) DO
			alreadyExist2[a2[i]] := FALSE;
			
		i_1 := 0;
		FOR i := 0 TO Lowar DO
		BEGIN
			IF (i_1 > High(a3)) OR (n3 = -1) THEN
				n3 := -1
			ELSE
			BEGIN
				IF alreadyExist2[a1[i]] THEN
				BEGIN
					a3[i_1] := a1[i];
					i_1 := i_1 +1;
				END;
				
				IF alreadyExist1[a2[i]] THEN
				BEGIN
					a3[i_1] := a2[i];
					i_1 := i_1 + 1;
				END;
			END;
		END;
		
		FOR i := (Lowar + 1) TO Highar DO
		BEGIN
			IF (i_1 > High(a3)) OR (n3 = -1) THEN
				n3 := -1
			ELSE
			BEGIN
				IF (High(a1) > High(a2)) AND alreadyExist2[a1[i]] THEN
				BEGIN
					a3[i_1] := a1[i];
					i_1 := i_1 + 1;
				END;
				
				IF (High(a2) > High(a1)) AND alreadyExist1[a2[i]]  THEN
				BEGIN
					a3[i_1] := a2[i];
					i_1 := i_1 + 1;
				END;
			END;
		END;
		
		IF n3 <> -1 THEN
			n3 := i_1

	END;

(*Test-Prozeduren*)

PROCEDURE WriteArr(arr: ARRAY OF INTEGER; n3: INTEGER);
	VAR
		i: INTEGER;
	BEGIN
		IF n3 < 0 THEN
			Write('| Array uebergelaufen! |');
		FOR i := Low(arr) TO (n3-1) DO
		Write(arr[i], ' | ');
	END;

VAR
	n: INTEGER;
	a1: ARRAY[1..6] OF INTEGER;
	a2: ARRAY[1..4] OF INTEGER;
	a3: ARRAY[1..6] OF INTEGER;

BEGIN
	n := 0;
	
	a1[1] := 2;
	a1[2] := 4;
	a1[3] := 4;
	a1[4] := 10;
	a1[5] := 15;
  a1[6] := 15;
	(*a1[7] := 15;
	a1[8] := 15;*)
	
	
	a2[1] := 3;
	a2[2] := 4;
	a2[3] := 5;
	a2[4] := 10;

	Merge(a1, a2, a3, n);
	
	WriteLn('Array a1:');
	WriteArr(a1, High(a1));
	WriteLn();
	
	WriteLn('Array a2:');
	WriteArr(a2, High(a2));
	WriteLn();
	
	WriteLn('Array a3:');
	WriteArr(a3, n);
	WriteLn();
	
	WriteLn('Ausgabe n: ', n, ' Erwartet: -1');
	
END.