UNIT MP_Scanner;

INTERFACE

TYPE
  SymbolCode = (errorSy, eofSy, 
                programSy, beginSy, endSy, varSy,
                integerSy, readSy, writeSy, 
                commaSy, colonSy, semicolonSy,
                assignSy, periodSy, (* period = . *)
                plusSy, minusSy, multSy, divSy,
                leftParSy, rightParSy,
                numberSy, identSy, ifSy, elseSy, thenSy,
                whileSy, doSy);

CONST
  EOF_CH = Chr(0);
  TAB_CH = Chr(9);

VAR
  sy: SymbolCode;
  syLnr, syCnr: INTEGER;
  numberVal: INTEGER;
  numberStr: STRING;
  identStr: STRING;
  
FUNCTION InitScanner(srcName: STRING): BOOLEAN; (* initializes scanner with filename*)
PROCEDURE NewSy; (* reads next symbol *)

IMPLEMENTATION

VAR
  srcFile: TEXT;
  line: STRING;
  ch: CHAR;
  chLnr, chCnr: INTEGER;
  
PROCEDURE NewCh;
BEGIN
  IF chCnr < Length(line) THEN BEGIN
    Inc(chCnr);
    ch := line[chCnr];
  END
  ELSE BEGIN
    IF NOT Eof(srcFile) THEN BEGIN
      ReadLn(srcFile, line);
      Inc(chLnr);
      ch := ' ';
      chCnr := 0;
    END
    ELSE BEGIN
      ch := EOF_CH;
      Close(srcFile);
    END;
  END;
END;

FUNCTION InitScanner(srcName: STRING): BOOLEAN;
BEGIN
  Assign(srcFile, srcName);
  {$I-}
  Reset(srcFile);
  {$I+}
  IF IOResult = 0 THEN BEGIN
    line := '';
    chLnr := 0;
    chCnr := 1;
    NewCh;
    NewSy;
    InitScanner := TRUE;
  END
  ELSE BEGIN
    InitScanner := FALSE;
  END;
END;

PROCEDURE NewSy;
VAR
  code: INTEGER;
BEGIN
  WHILE (ch = ' ') OR (ch = TAB_CH) DO BEGIN (* ignore spaces *)
    NewCh;
  END;
  syLnr := chLnr;
  syCnr := chCnr;
  CASE ch OF
    EOF_CH:    BEGIN sy := eofSy; END;
    '+':       BEGIN sy := plusSy; NewCh; END;
    '-':       BEGIN sy := minusSy; NewCh; END;
    '*':       BEGIN sy := multSy; NewCh; END;
    '/':       BEGIN sy := divSy; NewCh; END;
    '(':       BEGIN sy := leftParSy; NewCh; END;
    ')':       BEGIN sy := rightParSy; NewCh; END;
    ',':       BEGIN sy := commaSy; NewCh; END;
    '.':       BEGIN sy := periodSy; NewCh; END;
    ';':       BEGIN sy := semicolonSy; NewCh; END;
    ':':       BEGIN 
                 NewCh;
                 IF ch = '=' THEN BEGIN
                   sy := assignSy; NewCh;
                 END
                 ELSE BEGIN
                   sy := colonSy;
                 END;
               END;
    '0'..'9':  BEGIN 
                 sy := numberSy;
                 numberStr := '';
                 WHILE (ch >= '0') AND (ch <= '9') DO BEGIN
                   numberStr := numberStr + ch;
                   NewCh;
                 END;
                 Val(numberStr, numberVal, code);
               END;
     'a'..'z',
     'A'..'Z': BEGIN
                 identStr := '';
                 WHILE ch IN ['a'..'z', 'A'..'Z', '0'..'9', '_'] DO BEGIN
                   identStr := identStr + UpCase(ch);
                   NewCh;
                 END;
                 IF identStr = 'BEGIN' THEN
                   sy := beginSy
                 ELSE IF identStr = 'END' THEN
                   sy := endSy
                 ELSE IF identStr = 'INTEGER' THEN
                   sy := integerSy
                 ELSE IF identStr = 'PROGRAM' THEN
                   sy := programSy
                 ELSE IF identStr = 'READ' THEN
                   sy := readSy
                 ELSE IF identStr = 'VAR' THEN
                   sy := varSy
                 ELSE IF identStr = 'WRITE' THEN
                   sy := writeSy
                 ELSE IF identStr = 'IF' THEN
                 	 sy := ifSy
                 ELSE IF identStr = 'ELSE' THEN
                   sy := elseSy
                 ELSE IF identStr = 'THEN' THEN
                 	 sy := thenSy
                 ELSE IF identStr = 'WHILE' THEN
                   sy := whileSy
                 ELSE IF identStr = 'DO' THEN
                   sy := doSy
                 ELSE
                   sy := identSy;
               END;     
  ELSE
    sy := errorSy;
  END;
END;

END.