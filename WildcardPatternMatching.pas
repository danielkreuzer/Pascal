PROGRAM WildcardPatternMatching;

USES
	Timer;

VAR
	passages: INTEGER;

FUNCTION BruteSearch(s, p: STRING): BOOLEAN;
	VAR
		sLen, pLen: INTEGER;
		i, j: INTEGER;
	BEGIN
		sLen := Length(s);
		pLen := Length(p);
		i := 1;
		j := 1;

		REPEAT
			Inc(passages);
			IF (s[i] = p[j]) OR (p[j] = '?') THEN BEGIN
				Inc(i);
				Inc(j);
			END
			ELSE BEGIN
				i := i - j + 2;
				j := 1;
			END;
		UNTIL (i > sLen) OR (j > pLen) OR (s[i-1] = '$');
		IF j > pLen THEN BEGIN
			BruteSearch := TRUE;
		END
		ELSE
			BruteSearch := FALSE;
	END;
	
FUNCTION Matching(p: STRING; s: STRING): BOOLEAN;
	BEGIN
		Inc(passages);
		IF (p[1] = '$') AND (s[1] = '$') THEN
			Matching := TRUE
		ELSE IF ((p[1] = '*') AND (Length(p) = 2)) AND (s[1] = '$') THEN
			Matching := TRUE
		ELSE IF ((p[1] = s[1]) AND (s[1] <> '$')) OR ((p[1] = '?') AND (s[1] <> '$')) THEN
			Matching := Matching(Copy(p, 2, Length(p)), Copy(s, 2, Length(s)))
		ELSE IF (p[1] = '*') AND (s[1] <> '$') THEN
		BEGIN
			IF Length(p) > 2 THEN
			BEGIN
				IF NOT Matching(Copy(p, 2, Length(p)), s) THEN
					Matching := Matching(p, Copy(s, 2, Length(s)))
				ELSE
					Matching := TRUE;
			END
			ELSE
				Matching := Matching(p, Copy(s, 2, Length(s)));
		END
		ELSE
			Matching := FALSE;
	END;
	
FUNCTION MatchingIterativ(p: STRING; s: STRING): BOOLEAN;
	VAR
		p_new, s_new: STRING;
		sLen, pLen: INTEGER;
	BEGIN
		p_new := p;
		s_new := s;
		sLen := Length(s);
		pLen := Length(p);
		WHILE (s_new[1] <> '$') AND (p_new[1] <> '$') DO
		BEGIN
			Inc(passages);
			IF (p_new[1] <> '?') AND (p_new[1] <> s_new[1]) AND (p_new[1] <> '*') THEN
			BEGIN
				s_new := Copy(s_new, 2, sLen-1);
				Dec(sLen);
			END
			ELSE IF (s_new[1] = p_new[1]) OR (p_new[1] = '?') THEN
			BEGIN
				p_new := Copy(p_new, 2, pLen-1);
				Dec(pLen);
				s_new := Copy(s_new, 2, sLen-1);
				Dec(sLen);
			END
			ELSE (*IF (p_new[1] = '*') THEN*)
			BEGIN
				p_new := Copy(p_new, 2, pLen-1);
				Dec(pLen);
				IF (p_new[1] = '?') AND (s_new[1] <> '$') THEN
				BEGIN
					p_new := Copy(p_new, 2, pLen-1);
					Dec(pLen);
					s_new := Copy(s_new, 2, sLen-1);
					Dec(sLen);
				END;
				WHILE (s_new[1] <> '$') AND (s_new[1] <> p_new[1]) DO
				BEGIN
					Inc(passages);
					s_new := Copy(s_new, 2, sLen-1);
					Dec(sLen);
				END;
			END;
		END;
		
		IF (p_new = '*$') THEN
			Dec(pLen);
			
		MatchingIterativ := (sLen = pLen);
	END;
		
VAR
	s, p: STRING;
	i: LONGINT;
	check: BOOLEAN;
BEGIN
	WriteLn(' Test Wildcard Pattern Matching ');
	WriteLn;
	StartTimer;
	passages := 0;
	WriteLn(' Test 2a ');
	s := 'ABC$';
	p := 'A?C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', BruteSearch(s, p), '	Expected: TRUE');
	s := 'ABCDE$';
	p := 'A?C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', BruteSearch(s, p), '	Expected: FALSE');
	s := 'AAA$';
	p := 'A?C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', BruteSearch(s, p), '	Expected: FALSE');
	s := 'AAA$';
	p := 'A??$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', BruteSearch(s, p), '	Expected: TRUE');
	s := 'Qwr$';
	p := '???$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', BruteSearch(s, p), '	Expected: TRUE');
	s := 'Qwr$';
	p := '????$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', BruteSearch(s, p), '	Expected: FALSE');
	s := '';
	p := '';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', BruteSearch(s, p), '	Expected: TRUE');
	StopTimer;
	WriteLn;
	WriteLn(' Wildcard Pattern Matching Elapsed Time 2a: ', ElapsedTime, ' passages: ', passages);
	WriteLn;
	StartTimer;
	passages := 0;
	WriteLn(' Test 2b rekursiv');
	s := 'ABC$';
	p := 'A?C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'ABCDE$';
	p := 'A?C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: FALSE');
	s := 'AAA$';
	p := 'A?C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: FALSE');
	s := 'AAA$';
	p := 'A??$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'Qwr$';
	p := '???$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'Qwr$';
	p := '????$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: FALSE');
	s := '';
	p := '';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: FALSE');
	s := '$';
	p := '$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'ABCDEF$';
	p := '*$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := '$';
	p := '*$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'AC$';
	p := 'A*C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'AXYZC$';
	p := 'A*C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'AXYZCE$';
	p := 'A*CE$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'AXYZCD$';
	p := 'A*C*$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'AXYZC$';
	p := 'A*L$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: FALSE');
	s := 'AZCTF$';
	p := 'A*L$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: FALSE');
	s := 'R$';
	p := 'A*L$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: FALSE');
	s := 'ACCEDZ$';
	p := 'A*CED*$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	s := 'ACCEDZ$';
	p := 'A*?ED*$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', Matching(p, s), '	Expected: TRUE');
	WriteLn('Repeat 2000 times last test...');
	FOR i := 1 TO 2000 DO check := Matching(p, s);
	StopTimer;
	WriteLn;
	WriteLn(' Wildcard Pattern Matching Elapsed Time 2b rekursiv: ', ElapsedTime, ' passages: ', passages);
	WriteLn;
	StartTimer;
	passages := 0;
	WriteLn(' Test 2b iterativ');
	s := 'ABC$';
	p := 'A?C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'ABCDE$';
	p := 'A?C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: FALSE');
	s := 'AAA$';
	p := 'A?C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: FALSE');
	s := 'AAA$';
	p := 'A??$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'Qwr$';
	p := '???$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'Qwr$';
	p := '????$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: FALSE');
	s := '';
	p := '';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := '$';
	p := '$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'ABCDEF$';
	p := '*$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := '$';
	p := '*$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'AC$';
	p := 'A*C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'AXYZC$';
	p := 'A*C$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'AXYZCE$';
	p := 'A*CE$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'AXYZCD$';
	p := 'A*C*$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'AXYZC$';
	p := 'A*L$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: FALSE');
	s := 'AZCTF$';
	p := 'A*L$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: FALSE');
	s := 'R$';
	p := 'A*L$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: FALSE');
	s := 'ACCEDZ$';
	p := 'A*CEDZ$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	s := 'ACCEDZ$';
	p := 'A*?ED*$';
	WriteLn('s:	', s, '	p:	', p, '	Match:	', MatchingIterativ(p, s), '	Expected: TRUE');
	WriteLn('Repeat 2000 times last test...');
	FOR i := 1 TO 2000 DO MatchingIterativ(p, s);
	WriteLn;
	StopTimer;
	WriteLn(' Wildcard Pattern Matching Elapsed Time 2b iterativ: ', ElapsedTime, ' passages: ', passages);
	WriteLn;
	WriteLn(' Try with big string ');
	WriteLn;
	s := 'lllaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbccccccccccccccccccccccccccccccccdddddddddddddddddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddd$';
	p := 'lllaaaaaaaaaa?????????????????aaaaaaaaaaaaaabbbbbb????????????????????????????????ddddddddddddddddddddddddd*$';
	StartTimer;
	passages := 0;
	FOR i := 1 TO 150 DO
	check := Matching(p, s);
	StopTimer;
	WriteLn('Matching: ', ElapsedTime, ' ', check, ' passages: ', passages, ' Expected TRUE');
	StartTimer;
	passages := 0;
	FOR i := 1 TO 150 DO
	check := MatchingIterativ(p, s);
	StopTimer;
	WriteLn('MatchingIterativ: ', ElapsedTime, ' ', check, ' passages: ', passages, ' Expected TRUE');
	WriteLn;
	WriteLn(' Try with big string 2');
	WriteLn;
	s := 'helloPasXAEFRAScal$';
	p := 'hello?as*cal$';
	StartTimer;
	passages := 0;
	FOR i := 1 TO 1000 DO
	check := Matching(p, s);
	StopTimer;
	WriteLn('Matching: ', ElapsedTime, ' ', check, ' passages: ', passages, ' Expected TRUE');
	StartTimer;
	passages := 0;
	FOR i := 1 TO 1000 DO
	check := MatchingIterativ(p, s);
	StopTimer;
	WriteLn('MatchingIterativ: ', ElapsedTime, ' ', check, ' passages: ', passages, ' Expected TRUE');

	END.