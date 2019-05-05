PROGRAM MP_VM;

USES
  CodeDef, CodeInt, CodeDis;

VAR
  ca: CodeArray;
  ok: BOOLEAN;
BEGIN
  LoadCode('SVP.mpc', ca, ok);
  IF ok THEN BEGIN
    //InterpretCode(ca);
    DisassembleCode(ca);
  END
  ELSE BEGIN
    WriteLn('ERROR: File not found!');
  END;
END.