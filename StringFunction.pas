PROGRAM StringFunctions;

(* a *)
FUNCTION Reversed(s: STRING): STRING;
	VAR
		reverse: STRING;
		i : INTEGER;
	
	BEGIN
		reverse := '';
		
		FOR i := Length(s) DOWNTO 1 DO
		BEGIN
			reverse := Concat(reverse, s[i]);
		END;
		
		Reversed := reverse;
	END;

(* b *)
PROCEDURE StripBlanks(VAR s: STRING);
	VAR
		noBlanks: STRING;
		i: INTEGER;
	
	BEGIN
		noBlanks := '';
		
		FOR i := 1 TO Length(s) DO
		BEGIN
			IF s[i] <> ' ' THEN
				noBlanks := Concat(noBlanks, s[i]);
		END;
		
		s := noBlanks;
	END;

(* c *)
PROCEDURE ReplaceAll(old, new: STRING; VAR s: STRING);
	VAR
		i: INTEGER;
		snew: STRING;
		
	BEGIN
		snew := '';
		
		FOR i := 1 TO Length(s) DO
		BEGIN
			
			IF	(Pos(old, copy(s, i, Length(s))) + (i-1)) = i THEN
			BEGIN
				snew := Concat(snew, new);
				i := i + (Length(old) - 1);
			END
			ELSE
				snew := Concat(snew ,s[i]);
				
		END;
		s := snew;
	END;

VAR
	s1, s2, new, old, s3: STRING;

BEGIN

	(* Hardcoded Test*)
	
	(* Test Function Reversed *)
	WriteLn('Turn ''Hello'' with Function Reversed');
	s1 := 'Hello';
	WriteLn('Output:   | ', Reversed(s1), ' |');
	WriteLn('Expected: | olleH |');
	WriteLn();
	
	(* Test Procedure StripBlanks *)
	WriteLn('Delete blanks of ''Love what you do and do what you love''');
	s2 := 'Love what you do and do what you love';
	StripBlanks(s2);
	WriteLn('Output:   | ', s2, ' |');
	WriteLn('Expected: | Lovewhatyoudoanddowhatyoulove |');
	WriteLn();
	
	(* Test Procedure Replace All *)
	WriteLn('Switch Willkommen to Welcome in the sentence:''Willkommen to Hagenberg and Willkommen to our Shop''');
	WriteLn('old: Willkommen, new: Welcome, s: Willkommen to Hagenberg and Willkommen to our Shop');
	old := 'Willkommen';
	new := 'Welcome';
	s3 := 'Willkommen to Hagenberg and Willkommen to our Shop';
	ReplaceAll(old, new, s3);
	WriteLn('Output:   | ', s3, ' |');
	WriteLn('Expected: | Welcome to Hagenberg and Welcome to our Shop |');
	WriteLn();

END.