PROGRAM MP_Compiler;

USES
  MP_Scanner, MP_Parser, CodeDef, CodeGen;

VAR
  ca: CodeArray;

BEGIN
  IF InitScanner('SVP.mp') THEN BEGIN
    S; (* compilation *)
    IF success THEN BEGIN
      WriteLn('Compiling successful!');
      GetCode(ca);
      StoreCode('SVP.mpc', ca);
    END 
    ELSE BEGIN
      WriteLn('ERROR in line ', syLnr, ', column ', syCnr, ', with symbol ', sy)
    END;
  END
  ELSE
    WriteLn('ERROR Reading File!');
END.