PROGRAM mChainProblem;

FUNCTION MinM(s: STRING): INTEGER;
	VAR
		i, h: INTEGER;
		found: ARRAY[0..255] OF BOOLEAN;
	BEGIN
		(* INIT Hash-Table *)
		FOR i := Low(found) TO High(found) DO
		BEGIN
			found[i] := FALSE;
		END;
		
		FOR i := 1 TO Length(s) DO
		BEGIN
			found[Ord(s[i])] := TRUE;
		END;
		
		h := 0;
		FOR i := Low(found) TO High(found) DO
		BEGIN
			IF found[i] THEN Inc(h);
		END;

		MinM := h;
	END;

FUNCTION MaxMStringLen(s: STRING; m: INTEGER): INTEGER;
	VAR
		h: STRING;
		i, j, max: INTEGER;	
	BEGIN
		i := 1;
		j := 1;
		max := 0;
		h := '';
		
		REPEAT
			IF MinM(h) <= m THEN
			BEGIN
				h := h + s[i];
				Inc(i);
				Inc(j);
			END
			ELSE
			BEGIN
				IF (Length(h) - 1) > max THEN
					max := (Length(h) - 1);
				i := i - j + 2;
				j := 1;
				h := '';
			END;
		UNTIL i > Length(s)+1;
		
		IF (i > Length(s)) AND (max = 0) THEN
			MaxMStringLen := Length(s)
		ELSE
			MaxMStringLen := max;
			
	END;

BEGIN
	WriteLn('Test	MinM		m-Chain-Problem');
	WriteLn;
	WriteLn('abcaac ', '			MinM: ', MinM('abcaac'), ' 	Expected: 3');
	WriteLn('bbbbbbbbbbbbeeeeeeeee ', '	MinM: ', MinM('bbbbbbbbbbbbeeeeeeeee'), ' 	Expected: 2');
	WriteLn('a ', '			MinM: ', MinM('a'), ' 	Expected: 1');
	WriteLn('""', '			MinM: ', MinM(''), ' 	Expected: 0');
	WriteLn;
	
	WriteLn('Test	MaxMStringLen	m-Chain-Problem');
	WriteLn;
	WriteLn('abcdddeeeecdfg ', '			MinM: ', MinM('abcdddeeeecdfg'), ' 	Expected: 7');
	WriteLn('abcdddeeeecdfg 	', '	MaxMSL(s, 1): ', MaxMStringLen('abcdddeeeecdfg', 1), '		Expected: 4');
	WriteLn('abcdddeeeecdfg 	', '	MaxMSL(s, 2): ', MaxMStringLen('abcdddeeeecdfg', 2), '		Expected: 7');
	WriteLn('abcdddeeeecdfg 	', '	MaxMSL(s, 3): ', MaxMStringLen('abcdddeeeecdfg', 3), '	Expected: 10');
	WriteLn('abcdddeeeecdfg 	', '	MaxMSL(s, 4): ', MaxMStringLen('abcdddeeeecdfg', 4), '	Expected: 11');
	WriteLn('abcdddeeeecdfg 	', '	MaxMSL(s, 5): ', MaxMStringLen('abcdddeeeecdfg', 5), '	Expected: 12');
	WriteLn('abcdddeeeecdfg 	', '	MaxMSL(s, 6): ', MaxMStringLen('abcdddeeeecdfg', 6), '	Expected: 13');
	WriteLn('abcdddeeeecdfg 	', '	MaxMSL(s, 7): ', MaxMStringLen('abcdddeeeecdfg', 7), '	Expected: 14');
	WriteLn('""		', '	MaxMSL(s, 2): ', MaxMStringLen('', 2), '		Expected: 0');
	WriteLn;
END.