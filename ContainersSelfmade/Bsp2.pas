UNIT Bsp2;

INTERFACE

USES
	Bsp1;
	
TYPE
	counterArr = ARRAY [1..MaxSize] OF INTEGER;

	BOSPtr = ^BOS;
	BOS = OBJECT(SOS)
		PRIVATE
			counters: counterArr;
		PUBLIC
			CONSTRUCTOR Init;
			DESTRUCTOR Done; VIRTUAL;
			FUNCTION Cardinality: INTEGER; VIRTUAL;
			PROCEDURE Add(w: STRING); VIRTUAL;
			PROCEDURE Remove(w: STRING); VIRTUAL;
			FUNCTION Union(set2: BOS): BOS; VIRTUAL; OVERLOAD;
			FUNCTION Intersection(set2: BOS): BOS; VIRTUAL; OVERLOAD;
			FUNCTION Difference(set2: BOS): BOS; VIRTUAL; OVERLOAD;
			FUNCTION Subset(set2: BOS): BOOLEAN; VIRTUAL; OVERLOAD;
			FUNCTION GetCnt: counterArr; VIRTUAL;
			PROCEDURE Print; Virtual;
	END;

IMPLEMENTATION
	
	FUNCTION BOS.GetCnt: counterArr;
	BEGIN
		GetCnt := counters;
	END;
	
	CONSTRUCTOR BOS.Init;
	VAR
		i: INTEGER;
	BEGIN
		INHERITED Init;
		FOR i := 1 TO MaxSize DO
		BEGIN
			counters[i] := 0;
		END;
	END;
		
	DESTRUCTOR BOS.Done;
	BEGIN
		INHERITED Done;
		(* nothing to do *)
	END;
		
	FUNCTION BOS.Cardinality: INTEGER;
	VAR
		i, sum: INTEGER;
	BEGIN
		IF Empty THEN
			Cardinality := 0
		ELSE
		BEGIN
			sum := 0;
			FOR i := 1 TO MaxSize DO
			BEGIN
				sum := sum + counters[i];
			END;
			Cardinality := sum;
		END;
	END;
	
	PROCEDURE BOS.Add(w: STRING);
	VAR
		i: INTEGER;
	BEGIN
		INHERITED Add(w);
		FOR i := 1 TO MaxSize DO
		BEGIN
			IF w = Self.elements[i] THEN
			BEGIN
				Self.counters[i] := Self.counters[i] + 1;
			END;
		END;
	END;
	
	PROCEDURE BOS.Remove(w: STRING);
	VAR
		i, pos: INTEGER;
	BEGIN
		IF Empty THEN
			WriteLn('	WordSet is empty!!')
		ELSE
		BEGIN
			pos := 0;
			FOR i := 1 TO maxSize DO
			BEGIN
				IF elements[i] = w THEN pos := i;
			END;
			IF pos <> 0 THEN
			BEGIN
				IF counters[pos] = 1 THEN
				BEGIN
					Dec(n);
					FOR i := pos TO maxSize DO
					BEGIN
						IF (i+1) > maxSize THEN
							counters[i] := 0
						ELSE
							counters[i] := counters[i + 1];
					END;
					FOR i := pos TO maxSize DO
					BEGIN
						IF (i+1) > maxSize THEN
							elements[i] := ''
						ELSE
							elements[i] := elements[i + 1];
					END;
				END
				ELSE
				BEGIN
					counters[pos] := counters[pos] - 1;
				END;
			END
			ELSE
				WriteLn('	Element ', w,' not removed');
		END;
	END;
	
	FUNCTION BOS.Union(set2: BOS): BOS;
	VAR
		bosSetNew: BOS;
		sosTemp: SOS;
		i,j: INTEGER;
	BEGIN
		sosTemp.Init;
		bosSetNew.Init;
		sosTemp := INHERITED Union(set2);
		bosSetNew.elements := sosTemp.GetSet;
		bosSetNew.n := sosTemp.Cardinality;
		
		FOR i := 1 TO bosSetNew.n DO
		BEGIN
			FOR j := 1 TO SELF.n DO
			BEGIN
				IF SELF.elements[j] = bosSetNew.elements[i] THEN
					bosSetNew.counters[i] := bosSetNew.counters[i] + SELF.counters[j];
			END;
			FOR j := 1 TO set2.n DO
			BEGIN
				IF set2.elements[j] = bosSetNew.elements[i] THEN
					bosSetNew.counters[i] := bosSetNew.counters[i] + set2.counters[j];
			END;
		END;
		Union := bosSetNew;
	END;
	
	FUNCTION BOS.Intersection(set2: BOS): BOS;
	VAR
		bosSetNew: BOS;
		sosTemp: SOS;
		i,j: INTEGER;
	BEGIN
		sosTemp.Init;
		bosSetNew.Init;
		sosTemp := INHERITED Intersection(set2);
		bosSetNew.elements := sosTemp.GetSet;
		bosSetNew.n := sosTemp.Cardinality;
		
		FOR i := 1 TO bosSetNew.n DO
		BEGIN
			FOR j := 1 TO SELF.n DO
			BEGIN
				IF SELF.elements[j] = bosSetNew.elements[i] THEN
					bosSetNew.counters[i] := bosSetNew.counters[i] + SELF.counters[j];
			END;
			FOR j := 1 TO set2.n DO
			BEGIN
				IF set2.elements[j] = bosSetNew.elements[i] THEN
					bosSetNew.counters[i] := bosSetNew.counters[i] + set2.counters[j];
			END;
		END;
		Intersection := bosSetNew;
	END;
	
	FUNCTION BOS.Difference(set2: BOS): BOS;
	VAR
		wordSetNew: BOS;
		i: INTEGER;
	BEGIN
		wordSetNew.Init;
		
		wordSetNew := SELF;
		FOR i := 1 TO set2.n DO
		BEGIN
			IF wordSetNew.Contains(set2.elements[i]) THEN
				wordSetNew.Remove(set2.elements[i]);
		END;
		
		Difference := wordSetNew;
	END;
	
	FUNCTION BOS.Subset(set2: BOS): BOOLEAN;
	VAR
		checks, verify: BOOLEAN;
		i, j: INTEGER;
	BEGIN
		checks := INHERITED Subset(set2);
		IF checks THEN
		BEGIN
			verify := TRUE;
			FOR i := 1 TO set2.n DO
			BEGIN
				FOR j := 1 TO Self.n DO
				BEGIN
					IF Self.elements[j] = Set2.elements[i] THEN
					BEGIN
						IF Self.counters[j] <> Set2.counters[i] THEN
							verify := FALSE;
					END;
				END;
			END;
			Subset := verify;
		END
		ELSE
			Subset := FALSE;
	END;
	
	PROCEDURE BOS.Print;
	VAR
		i, j: INTEGER;
	BEGIN
		FOR i := 1 TO n DO
		BEGIN
			FOR j := 1 TO counters[i] DO
				WriteLn('	-', elements[i]);
		END;
	END;
	
BEGIN
END.