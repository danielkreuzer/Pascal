UNIT Bsp1;

INTERFACE

CONST
	MaxSize = 100;

TYPE
	wordSet = ARRAY [1..MaxSize] OF STRING;
	
	SOSPtr = ^SOS;
	SOS = OBJECT
		PROTECTED
			elements: wordSet;
			n: INTEGER;
		PUBLIC
			CONSTRUCTOR Init;
			DESTRUCTOR Done; VIRTUAL;
			FUNCTION Empty: BOOLEAN; VIRTUAL;
			FUNCTION Cardinality: INTEGER; VIRTUAL;
			PROCEDURE Add(w: STRING); VIRTUAL;
			PROCEDURE Remove(w: STRING); VIRTUAL;
			FUNCTION Contains(w: STRING): BOOLEAN; VIRTUAL;
			FUNCTION Union(set2: SOS): SOS; VIRTUAL;
			FUNCTION Intersection(set2: SOS): SOS; VIRTUAL;
			FUNCTION Difference(set2: SOS): SOS; VIRTUAL;
			FUNCTION Subset(set2: SOS): BOOLEAN; VIRTUAL;
			FUNCTION GetSet: wordSet; VIRTUAL;
			PROCEDURE Print; VIRTUAL;
	END;


IMPLEMENTATION
	
	FUNCTION SOS.getSet: wordSet;
	BEGIN
		getSet := elements;
	END;
	
	CONSTRUCTOR SOS.Init;
	VAR
		i: INTEGER;
	BEGIN
		(* Init n *)
		n := 0;
		(* Init wordSet *)
		FOR i := 1 TO MaxSize DO
		BEGIN
			elements[i] := '';
		END;
	END;
	
	DESTRUCTOR SOS.Done;
	BEGIN
		(* nothing to do *)
	END;
	
	FUNCTION SOS.Empty: BOOLEAN;
	BEGIN
		Empty := (n = 0);
	END;
	
	FUNCTION SOS.Contains(w: STRING): BOOLEAN;
	VAR
		i: INTEGER;
	BEGIN
		Contains := FALSE;
		FOR i := 1 TO maxSize DO
		BEGIN
			IF w = elements[i] THEN
				Contains := TRUE;
		END;
	END;	
	
	FUNCTION SOS.Cardinality: INTEGER;
	BEGIN
		Cardinality := n;
	END;
	
	PROCEDURE SOS.Add(w: STRING);
	BEGIN
		IF (n+1) > maxSize THEN
			WriteLn('	Element ', w, ' not added, wordSet full!')
		ELSE
		BEGIN
			IF Contains(w) THEN
				WriteLn('	Set contains ', w,' already')
			ELSE
			BEGIN
				Inc(n);
				elements[n] := w;
			END;
		END;
	END;
	
	PROCEDURE SOS.Remove(w: STRING);
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
				Dec(n);
				FOR i := pos TO maxSize DO
				BEGIN
					IF (i+1) > maxSize THEN
						elements[i] := ''
					ELSE
						elements[i] := elements[i + 1];
				END;
			END
			ELSE
				WriteLn('	Element ', w,' not removed');
		END;
	END;
	
	FUNCTION SOS.Union(set2: SOS): SOS;
	VAR
		wordSetNew: SOS;
		i: INTEGER;
		setArr: wordSet;
	BEGIN
		wordSetNew.Init;
		setArr := set2.GetSet;
		
		FOR i := 1 TO SELF.n DO
		BEGIN
			wordSetNew.Add(SELF.elements[i]);
		END;
		
		FOR i := 1 TO set2.n DO
		BEGIN
			wordSetNew.Add(setArr[i]);
		END;
		
		Union := wordSetNew;
	END;
	
	FUNCTION SOS.Intersection(set2: SOS): SOS;
	VAR
		wordSetNew: SOS;
		i,j: INTEGER;
		setArr: wordSet;
	BEGIN
		wordSetNew.Init;
		setArr := set2.GetSet;
		
		FOR i := 1 TO Self.n DO
		BEGIN
			FOR j := 1 TO set2.n DO
			BEGIN
				IF Self.elements[i] = setArr[j] THEN
					wordSetNew.Add(setArr[j]);
			END;
		END;
		
		Intersection := wordSetNew;
	END;
	
	FUNCTION SOS.Difference(set2: SOS): SOS;
	VAR
		wordSetNew: SOS;
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
	
	FUNCTION SOS.Subset(set2: SOS): BOOLEAN;
	VAR
		contain: BOOLEAN;
		i: INTEGER;
	BEGIN
		contain := TRUE;
		FOR i := 1 TO set2.n DO
		BEGIN
			IF NOT Self.Contains(set2.elements[i]) THEN
				contain := FALSE;
		END;
		Subset := contain;
	END;
	
	PROCEDURE SOS.Print;
	VAR
		i: INTEGER;
	BEGIN
		FOR i := 1 TO n DO
		BEGIN
			WriteLn('	-', elements[i]);
		END;
	END;

BEGIN
END.