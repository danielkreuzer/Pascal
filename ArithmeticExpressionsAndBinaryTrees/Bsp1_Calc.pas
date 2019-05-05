PROGRAM Bsp1_Calc;

USES
	Bsp1_CalcLex, Bsp1_CalcSem;

VAR
	line: STRING;
BEGIN
	Write('> ');
	ReadLn(line);
	WHILE line <> '' DO
	BEGIN
		InitLex(line);
		InitSyn;
		S; 
		WriteLn;
		WriteLn('Input valid: ', success);
		Write('> ');
		ReadLn(line);
  END; (* WHILE *)
END.