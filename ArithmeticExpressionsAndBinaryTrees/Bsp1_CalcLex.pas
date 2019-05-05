UNIT Bsp1_CalcLex; (* lexical analyser for calculator *)

INTERFACE
	TYPE Symbol = (plusSy, minusSy, mulSy, divSy, numSy, 
 	              leftParSy, rightParSy, noSy, eofSy);
	VAR
	  sy : Symbol;
	  numberVal : STRING; (* attribute for number symbol *)
  
	PROCEDURE NewSy; (* reads next symbol curSy *)
	PROCEDURE InitLex(input : STRING);

IMPLEMENTATION
	CONST eofChr = CHR(0);
	      tabChr = CHR(9);
	VAR
	  line : STRING;
	  colNr : INTEGER;
	  ch : CHAR;

	PROCEDURE NewCh; FORWARD;

	PROCEDURE NewSy; (* reads next symbol curSy *)
	BEGIN
		WHILE (ch = ' ') OR (ch = tabChr) DO NewCh; (* skip whitespace *)
		CASE ch OF
			'+': BEGIN sy := plusSy; NewCh; END;
			'-': BEGIN sy := minusSy; NewCh; END;
			'*': BEGIN sy := mulSy; NewCh; END;
			'/': BEGIN sy := divSy; NewCh; END;
			'(': BEGIN sy := leftParSy; NewCh; END;
			')': BEGIN sy := rightParSy; NewCh; END;
			eofChr: sy := eofSy;
			'0'..'9': BEGIN
									numberVal := '';
									WHILE (ch >= '0') AND (ch <= '9') DO
									BEGIN
										numberVal := numberVal + ch;
										NewCh;
									END;
									sy := numSy;
								END (* 0 .. 9 *)
			ELSE
			BEGIN
				(* anything else *)
				sy := noSy;
			END;
		END; (* CASE *)
	END;

	PROCEDURE InitLex(input : STRING);
	BEGIN
		line := input;
		colNr := 0;
		NewCh;
	END;

	PROCEDURE NewCh;
	BEGIN
		IF colNr < Length(line) THEN
		BEGIN
			Inc(colNr);
			ch := line[colNr];
		END
		ELSE
		BEGIN
			ch := eofChr;    
		END;
	END;


BEGIN
END.