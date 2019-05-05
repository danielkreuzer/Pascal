PROGRAM RationalCalculator;

TYPE
	Rational = RECORD
		num, denom: INTEGER;
	END;

PROCEDURE ggT(VAR a: Rational);
	VAR
		p, q, r: INTEGER;
		
	BEGIN
		IF a.num > a.denom THEN
		BEGIN
			p := a.num;
			q := a.denom;
		END
		ELSE IF a.num < a.denom THEN
		BEGIN
			p := a.denom;
			q := a.num;
		END
		ELSE
		BEGIN
			p := a.num;
			q := a.denom;
		END;
			
		r := 1;
		
		WHILE r <> 0 DO
		BEGIN
			r := p MOD q;
			IF r <> 0 THEN
			BEGIN
				p := q;
				q := r;
			END;
		END;
		
		a.num := a.num DIV q;
		a.denom := a.denom DIV q;

		IF a.denom < 0 THEN
		BEGIN
			a.num := a.num * -1;
			a.denom := abs(a.denom);
		END;
		
	END;

PROCEDURE	Sum(a, b: Rational; VAR c: Rational);
	BEGIN
		c.num := (a.num * b.denom) + (b.num * a.denom);
		c.denom := (a.denom * b.denom);
		ggT(c);
	END;

PROCEDURE	Diff(a, b: Rational; VAR c: Rational);
	BEGIN
		c.num := (a.num * b.denom) - (b.num * a.denom);
		c.denom := (a.denom * b.denom);
		ggT(c);
	END;

PROCEDURE Prod(a, b: Rational; VAR c: Rational);
	BEGIN
		c.num := (a.num * b.num);
		c.denom := (a.denom * b.denom);
		ggT(c);
	END;

PROCEDURE Quot(a, b: Rational; VAR c: Rational);
	BEGIN
		c.num := (a.num * b.denom);
		c.denom := (a.denom * b.num);
		ggT(c);
	END;

PROCEDURE Eingabe(VAR a, b: Rational);
	BEGIN
		WriteLn('Zaehler 1: ');
		ReadLn(a.num);
		WriteLn('Nenner 1: ');
		ReadLn(a.denom);
		WriteLn('Zaehler 2: ');
		ReadLn(b.num);
		WriteLn('Nenner 2: ');
		ReadLn(b.denom);
		
		IF (a.denom <= 0) OR (b.denom <= 0) THEN
		BEGIN
			WriteLn('Nenner kleiner 0!');
			HALT
		END;
		
		ggT(a);
		ggT(b);
		WriteLn();
	END;

PROCEDURE Ausgabe(c: Rational);
	BEGIN
		WriteLn('Ergebnis: ');
		WriteLn(c.num);
		WriteLn('------');
		WriteLn(c.denom);
	END;

VAR
	a, b, c: Rational;
	auswahl: INTEGER;

BEGIN

	WriteLn('RationalCalculator');
	WriteLn();
	WriteLn('Sum 1, Diff 2, Prod 3, Quot 4');
	WriteLn('Auswahl: ');
	ReadLn(auswahl);
	
	IF (auswahl = 1) THEN
	BEGIN
		Eingabe(a, b);
		Sum(a, b, c);
		Ausgabe(c);
	END
	ELSE IF (auswahl = 2) THEN
	BEGIN
		Eingabe(a, b);
		Diff(a, b, c);
		Ausgabe(c);
	END
	ELSE IF (auswahl = 3) THEN
	BEGIN
		Eingabe(a, b);
		Prod(a, b, c);
		Ausgabe(c);
	END
	ELSE IF (auswahl = 4) THEN
	BEGIN
		Eingabe(a, b);
		Quot(a, b, c);
		Ausgabe(c);
	END
	ELSE
		WriteLn('Falsche Eingabe!');
END.