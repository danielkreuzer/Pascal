PROGRAM Bsp2_Calc;

USES
	Bsp1_CalcLex, Bsp2_CalcSem;
	
PROCEDURE Test(t: TreePtr);
	BEGIN
		Write('In Order:	');
		InOrder(t);
		WriteLn;
		Write('Pre Order:	');
		PreOrder(t);
		WriteLn;
		Write('Post Order:	');
		PostOrder(t);
		WriteLn;
		WriteLn('Value of	 = ', ValueOf(t));
	END;


VAR
	line: STRING;
	t: TreePtr;
BEGIN
	Write('> ');
	ReadLn(line);
	WHILE line <> '' DO
	BEGIN
		InitLex(line);
		InitSyn(t);
		S(t); 
		WriteLn('Input valid: ', success);
		IF success THEN Test(t);
		WriteLn;
		Write('> ');
		ReadLn(line);
		DisposeTree(t);
  END; (* WHILE *)
END.