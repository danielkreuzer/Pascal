PROGRAM WS_ADT_TEST;

USES
	WS_ADT;
VAR
	s1, s2, s_union, s_intersection, s_difference: wordSet;
	pProgram: ARRAY[1..4] OF STRING;
	i,j: INTEGER;
BEGIN
	WriteLn(' Test WS_ADT ');
	WriteLn('Initialise parameters ...');
	
	Init(s1);
	Init(s2);
	Init(s_union);
	Init(s_intersection);
	Init(s_difference);
	pProgram[1] := 'fpoe.txt';
	pProgram[2] := 'gruene.txt';
	pProgram[3] := 'oevp.txt';
	pProgram[4] := 'spoe.txt';
	
	WriteLn(' - Test IsEmpty s1: ', IsEmpty(s1), ' Expected TRUE');
	WriteLn(' - Test IsEmpty s2: ', IsEmpty(s2), ' Expected TRUE');
	WriteLn(' - Insert Testfile ');
	InsertFile(s1, 'oevp.txt');
	InsertFile(s2, 'spoe.txt');
	WriteLn(' - Test IsEmpty s1: ', IsEmpty(s1), ' Expected FALSE');
	WriteLn(' - Test IsEmpty s2: ', IsEmpty(s2), ' Expected FALSE');
	WriteLn(' - Test RemoveFile');
	RemoveFile(s1, 'oevp.txt');
	WriteLn(' - Test IsEmpty s1: ', IsEmpty(s1), ' Expected TRUE');
	WriteLn(' - Test Delete');
	Delete(s2);
	WriteLn(' - Test IsEmpty s2: ', IsEmpty(s2), ' Expected TRUE');
	WriteLn;
	Delete(s1);
	Delete(s2);
	WriteLn(' - - START COMPARISON of party manifesto - - ');
	FOR j := 1 TO 4 DO
	BEGIN
		InsertFile(s1, pProgram[j]);
		FOR i := 1 TO 4 DO
		BEGIN
			InsertFile(s2, pProgram[i]);
			WriteLn(' Cardinality of ', pProgram[j], ': ', Cardinality(s1));
			WriteLn(' Cardinality of ', pProgram[i], ': ', Cardinality(s2));
			WriteLn;
			s_union := Union(s1,s2);
			WriteLn(' Cardinality of Union: ', Cardinality(s_union));
			s_intersection := Intersection(s1,s2);
			WriteLn(' Cardinality of Intersection: ',Cardinality(s_intersection));
			s_difference := Difference(s1,s2);
			WriteLn(' Cardinality of Difference: ',Cardinality(s_difference));
			WriteLn;
			Delete(s_union);
			Delete(s_intersection);
			Delete(s_difference);
			Delete(s2);
		END;
		Delete(s1);
	END;
END.