PROGRAM RLE;

PROCEDURE Filter;
	VAR
		outFile, inFile: Text;
		i, num, p: INTEGER;
		ch: CHAR;
		prev: STRING;
		mode: INTEGER;
		
	BEGIN
		// check Parameters
		IF NOT ((ParamCount = 2) OR (ParamCount = 3)) THEN
		BEGIN
			WriteLn('Wrong number of parameters!');
			Halt;
		END;
	
		mode := 1;
		p := 1;
		
		IF ParamCount = 3 THEN
		BEGIN
			Inc(p);
			//Check mode
			IF ParamStr(1) = '-c' THEN
				mode := 1
			ELSE IF ParamStr(1) = '-d' THEN
				mode := 2
			ELSE
			BEGIN
				WriteLn('Wrong mode!');
				Halt;
			END;
		END;
			
		//Check files and open them
		{$I-}
		Assign(inFile, ParamStr(p));
		Reset(inFile);
		IF IOResult <> 0 THEN
		BEGIN
			WriteLn('Error opening file ', ParamStr(p));
			HALT;
		END;
		Assign(outFile, ParamStr(p+1));
		Rewrite(outFile);
		IF IOResult <> 0 THEN
		BEGIN
			WriteLn('Error rewriting file ', ParamStr(p+1));
			HALT;
		END;
		{$I+}						

		//Start De-/Encode
		WriteLn('Start process...');
		IF mode = 1 THEN //compress -----------------------------------------
		BEGIN
			prev := '';
			WHILE NOT EOF(inFile) DO
			BEGIN
				Read(inFile, ch);
				IF (ch = prev[1]) AND (Length(prev) < 9) THEN
					prev := prev + ch
				ELSE IF (ch = prev[1]) AND (Length(prev) = 9) THEN
				BEGIN
					Write(outfile, prev[1]);
					Write(outfile, Length(prev));	
					prev := ch;
				END
				ELSE //prev[1] <> ch
				BEGIN
					IF (Length(prev) = 1) OR (Length(prev) = 2) THEN
					BEGIN
						Write(outfile, prev);
						prev := ch;
					END
					ELSE IF Length(prev) > 2 THEN
					BEGIN
						Write(outfile, prev[1]);
						Write(outfile, Length(prev));
						prev := ch;
					END
					ELSE // prev = 0
						prev := ch;
				END;
			END; //WHILE
			IF length(prev) <> 0 THEN
			BEGIN
				IF (Length(prev) = 1) OR (Length(prev) = 2) THEN
					Write(outfile, prev)
				ELSE
				BEGIN
					Write(outfile, prev[1]);
					Write(outfile, Length(prev));
				END;
			END;
		END
		ELSE //decode ---------------------------------------------------
		BEGIN
			WHILE NOT EOF(inFile) DO
			BEGIN
				Read(inFile, ch);
				IF (Ord(ch) > 47) AND (Ord(ch) < 58) THEN
				BEGIN
					num := Ord(ch) - 49;
					FOR i := 1 TO num DO
						Write(outFile, prev);
				END
				ELSE
					Write(outFile, ch);
				prev := ch;
			END;
		END;
		
		//Close Textfiles
		Close(inFile);
		Close(outFile);
		WriteLn('Prozess completed!');
	END; //Filter

BEGIN
	//Start Filter Programm
	Filter;
END.