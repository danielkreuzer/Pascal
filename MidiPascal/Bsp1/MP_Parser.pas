UNIT MP_Parser;

INTERFACE

  VAR
    success: BOOLEAN;
    
  PROCEDURE S;
  
IMPLEMENTATION

  USES
    MP_Scanner, SymTab, CodeDef, CodeGen;
    
  FUNCTION SyIsNot(expectedSy: SymbolCode): BOOLEAN;
  BEGIN
    success := success AND (sy = expectedSy);
    SyIsNot := NOT success;
  END;
  
 PROCEDURE SemErr(msg: STRING);
  BEGIN
    WriteLn('ERROR in line ', syLnr, ', column ', syCnr, ': ', msg);
    success := FALSE;
  END;
  
  
  PROCEDURE MP;      FORWARD;
  PROCEDURE VarDecl; FORWARD;
  PROCEDURE StatSeq; FORWARD;
  PROCEDURE Stat;    FORWARD;
  PROCEDURE Expr;    FORWARD;
  PROCEDURE Term;    FORWARD;
  PROCEDURE Fact;    FORWARD;

  
  PROCEDURE S;
  BEGIN
    success := TRUE;
    MP;
    success := success AND (sy = eofSy);
  END;
  
  PROCEDURE MP;
  BEGIN
    (* SEM *)
    InitSymbolTable;
    InitCodeGenerator;
    (* ENDSEM *)
    IF SyIsNot(programSy) THEN Exit;
    NewSy;
    IF SyIsNot(identSy) THEN Exit;
    NewSy;
    IF SyIsNot(semicolonSy) THEN Exit;
    NewSy;
    IF sy = varSy THEN BEGIN
      VarDecl;
      IF NOT success THEN Exit;
    END;
    IF SyIsNot(beginSy) THEN Exit;
    NewSy;
    StatSeq;
    IF NOT success THEN Exit;
    (* SEM *)
    Emit1(EndOpc);
    (* ENDSEM *)
    IF SyIsNot(endSy) THEN Exit;
    NewSy;
    IF SyIsNot(periodSy) THEN Exit;
    NewSy;
  END;
  
  PROCEDURE VarDecl;
  VAR
    ok: BOOLEAN; 
  BEGIN
    IF SyIsNot(varSy) THEN Exit;
    NewSy;
    IF SyISNot(identSy) THEN Exit;
    (* SEM *)
    DeclVar(identStr, ok);
    (* ENDSEM *)
    NewSy;
    WHILE sy = commaSy DO BEGIN
      NewSy;
      IF SyIsNot(identSy) THEN Exit;
      (* SEM *)
      DeclVar(identStr, ok);
      IF NOT ok THEN BEGIN
        SemErr('multiple declaration');
      END;
      (* ENDSEM *)
      NewSy;
    END;
    IF SyIsNot(colonSy) THEN Exit;
    NewSy;
    IF SyIsNot(integerSy) THEN Exit;
    NewSy;
    IF SyIsNot(semicolonSy) THEN Exit;
    NewSy;
  END;
  
  PROCEDURE StatSeq;
  BEGIN
    Stat;
    IF NOT success THEN Exit;
    WHILE sy = semicolonSy DO BEGIN
      NewSy;
      Stat;
      IF NOT success THEN Exit;
    END;
  END;
  
  PROCEDURE Stat;
  VAR
    destId: STRING;
    addr, addr1, addr2: INTEGER;
  BEGIN
    CASE sy OF 
				identSy: BEGIN
									 (* SEM *)
									 destId := identStr;
									 IF IsDecl(destid) THEN BEGIN
										 Emit2(LoadAddrOpc, AddrOf(destId));
									 END
									 ELSE BEGIN
										 SemErr('variable ' + identStr + ' not declared');
									 END;
									 (* ENDSEM *)
									 NewSy;
									 IF SyIsNot(assignSy) THEN Exit;
									 NewSy;
									 Expr;
									 IF NOT success THEN Exit;
									 (* SEM *)
									 IF IsDecl(destId) THEN BEGIN
										 Emit1(StoreOpc);
									 END;
									 (* ENDSEM *)
								 END;
				readSy: BEGIN
									NewSy;
									IF SyIsNot(leftParSy) THEN Exit;
									NewSy;
									IF SyIsNot(identSy) THEN Exit;
									(* SEM *)
									IF IsDecl(identStr) THEN BEGIN
										Emit2(ReadOpc, AddrOf(identStr));
									END
									ELSE BEGIN
										SemErr('variable ' + identStr + ' not declared');
									END;
									(* ENDSEM *)
									NewSy;
									IF SyIsNot(rightParSy) THEN Exit;
									NewSy;
								END;
				writeSy: BEGIN
									NewSy;
									IF SyIsNot(leftParSy) THEN Exit;
									NewSy;
									Expr;
									IF NOT success THEN Exit;
									(* SEM *)
									Emit1(WriteOpc);
									(* ENDSEM *)
									IF SyIsNot(rightParSy) THEN Exit;
									NewSy;
								END;
				beginSy:	BEGIN
										NewSy;
										StatSeq;
										IF NOT success THEN Exit;
										IF SyIsNot(endSy) THEN Exit;
										NewSy;
									END;
				ifSy:			BEGIN
										(* SEM *)
										NewSy;
										IF SyIsNot(identSy) THEN Exit;
										IF NOT IsDecl(identStr) THEN
										BEGIN
											SemErr('variable ' + identStr + ' not declared');
										END;
										Emit2(LoadValOpc, AddrOf(identStr));
										Emit2(JmpZOpc, 0); (* 0 as dummy address *)
										addr := CurAddr - 2;
										(* ENDSEM *)
										NewSy;
										IF SyIsNot(ThenSy) THEN Exit;
										NewSy;
										Stat;
										IF NOT success THEN Exit;
										IF sy = elseSy THEN
										BEGIN
											(* SEM *)
											Emit2(JmpOpc, 0); (* 0 as dummy address *)
											FixUp(addr, CurAddr);
											addr := CurAddr - 2;
											(* ENDSEM *)
											NewSy;
											Stat;
											IF NOT success THEN Exit;
									 END;
									 (* SEM *)
									 	FixUp(addr, CurAddr);
									 (* ENDSEM *)
									END;
				whileSy:	BEGIN
										NewSy;
										IF SyIsNot(identSy) THEN Exit;
										(* SEM *)
										IF NOT IsDecl(identStr) THEN
										BEGIN
											SemErr('variable ' + identStr + ' not declared');
										END;
										addr1 := CurAddr;
										Emit2(LoadValOpc, AddrOf(identStr));
										Emit2(JmpZOpc, 0); (* 0 as dummy address *)
										addr2 := CurAddr - 2;
										(* ENDSEM *)
										NewSy;
										IF SyIsNot(doSy) THEN Exit;
										NewSy;
										Stat;
										IF NOT success THEN Exit;
										(* SEM *)
										Emit2(JmpOpc, addr1);
										FixUp(addr2, CurAddr);
										(* ENDSEM *)
									END;
    ELSE
      (* empty statement *)
    END;
  END;
  
  PROCEDURE Expr;
  BEGIN
    Term;
    WHILE (success) AND ((sy = plusSy) OR (sy = minusSy)) DO BEGIN
      CASE sy OF
        plusSy: BEGIN 
                  NewSy; 
                  Term; 
                  IF NOT success THEN Exit;
                  (* SEM *)
                  Emit1(AddOpc);
                  (* ENDSEM *)
                END;
        minusSy: BEGIN 
                   NewSy; 
                   Term;
                   IF NOT success THEN Exit;
                   (* SEM *)
                   Emit1(SubOpc);
                   (* ENDSEM *)
                 END;
      END;
    END;
  END;
  
  PROCEDURE Term;
  BEGIN
    Fact;
    WHILE (success) AND ((sy = multSy) OR (sy = divSy)) DO BEGIN
      CASE sy OF
        multSy: BEGIN 
                  NewSy; 
                  Fact; 
                  IF NOT success THEN Exit;
                  (* SEM *)
                  Emit1(MulOpc);
                  (* ENDSEM *)
                END;
        divSy: BEGIN 
                 NewSy; 
                 Fact;
                 IF NOT success THEN Exit;
                 (* SEM *)
                 Emit1(DivOpc);
                 (* ENDSEM *)
               END;
      END;
    END;
  END;
  
  PROCEDURE Fact;
  BEGIN
    CASE sy OF
      identSy: BEGIN
                 (* SEM *)
                 IF IsDecl(identStr) THEN BEGIN
                   Emit2(LoadValOpc, AddrOf(identStr));
                 END
                 ELSE BEGIN
                   SemErr('variable ' + identStr + ' not declared');
                 END;
                 (* ENDSEM *)
                 NewSy;
               END;
      numberSy: BEGIN
                  (* SEM *)
                  Emit2(LoadConstOpc, numberVal);
                  (* ENDSEM *)
                  NewSy;
                END;
      leftParSy: BEGIN
                   NewSy;
                   Expr;
                   IF NOT success THEN Exit;
                   IF sy <> rightParSy THEN BEGIN
                     success := FALSE;
                     Exit;
                   END;
                   NewSy;
                 END;
      ELSE BEGIN 
        success := FALSE; 
        Exit;
      END;
    END;
  END;

  
BEGIN
END.