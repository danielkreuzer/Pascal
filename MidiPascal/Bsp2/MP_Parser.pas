UNIT MP_Parser;

INTERFACE

  VAR
    success: BOOLEAN;
    
  PROCEDURE S;
  
IMPLEMENTATION

  USES
    MP_Scanner, SymTab, CodeDef, CodeGen;
    
 	TYPE
		NodePtr = ^Node;
		Node = RECORD
			val: STRING;
			left, right: NodePtr;
		END;
		TreePtr = NodePtr;
		
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
 
   FUNCTION NewNode(val: STRING): NodePtr;
   VAR
     n: NodePtr;
   BEGIN
     New(n);
     n^.val := val;
     n^.left := NIL;
     n^.right := NIL;
     NewNode := n;
   END;
 
   PROCEDURE DisposeTree(VAR t: TreePtr);
   BEGIN
     IF t <> NIL THEN BEGIN
       DisposeTree(t^.left);
       DisposeTree(t^.right);
       Dispose(t);
       t := NIL;
     END;
   END;
	
	PROCEDURE EmitCodeForExprTree(t: TreePtr);
	VAR
		numVal, code: INTEGER;
	BEGIN
		IF t <> NIL THEN
		BEGIN
			EmitCodeForExprTree(t^.left);
			EmitCodeForExprTree(t^.right);
			IF t^.val = '+' THEN
				Emit1(AddOpc)
			ELSE IF t^.val = '-' THEN
				Emit1(SubOpc)
			ELSE IF t^.val = '*' THEN
				Emit1(MulOpc)
			ELSE IF t^.val = '/' THEN
				Emit1(DivOpc)
			ELSE IF t^.val[1] IN ['0'..'9'] THEN
			BEGIN
				Val(t^.val, numVal, code);
				Emit2(LoadConstOpc, numVal);
			END
			ELSE
				Emit2(LoadValOpc, AddrOf(t^.val));
		END;
	END;
	
	FUNCTION OptiOne(e: TreePtr): BOOLEAN;
	BEGIN
		OptiOne := NOT (e^.val = '1');
	END;
	
	FUNCTION OptiZero(e: TreePtr): BOOLEAN;
	BEGIN
		OptiZero := NOT (e^.val = '0');
	END;
	
	FUNCTION OptiConst(e: TreePtr): BOOLEAN;
	BEGIN
		OptiConst := NOT (e^.val[1] IN ['0'..'9']);
	END;
	
	FUNCTION ValueOf(VAR t: TreePtr): STRING;
	VAR
		valLeft, ValRight, code: INTEGER;
		valSolved: INTEGER;
		valSolvedStr: STRING;
	BEGIN
		IF t <> NIL THEN
		BEGIN
			Val(ValueOf(t^.left), valLeft, code);
			Val(ValueOf(t^.right), valRight, code);
			(* -- WriteLn for testing -- *)
			CASE t^.val[1] OF
				'+': BEGIN valSolved := valLeft + valRight; 
				Str(valSolved, valSolvedStr); ValueOf := valSolvedStr; WriteLn(ValSolvedStr); END;
				'-': BEGIN valSolved := valLeft - valRight;
				Str(valSolved, valSolvedStr); ValueOf := valSolvedStr; WriteLn(ValSolvedStr); END;
				'*': BEGIN valSolved := valLeft * valRight;
				Str(valSolved, valSolvedStr); ValueOf := valSolvedStr; WriteLn(ValSolvedStr); END;
				'/': BEGIN valSolved := valLeft DIV valRight;
				Str(valSolved, valSolvedStr); ValueOf := valSolvedStr; WriteLn(ValSolvedStr); END;
				ELSE
					BEGIN
						ValueOf := t^.val;
					END;
			END;
		END
		ELSE
			ValueOf := '0';
	END;
  
  PROCEDURE MP;      FORWARD;
  PROCEDURE VarDecl; FORWARD;
  PROCEDURE StatSeq; FORWARD;
  PROCEDURE Stat;    FORWARD;
  PROCEDURE Expr(VAR e: TreePtr);    FORWARD;
  PROCEDURE Term(VAR t: TreePtr);    FORWARD;
  PROCEDURE Fact(VAR f: TreePtr);    FORWARD;
  
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
    e: TreePtr;
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
									 Expr(e);
									 EmitCodeForExprTree(e);
									 IF NOT success THEN Exit;
									 DisposeTree(e);
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
									Expr(e);
									EmitCodeForExprTree(e);
									IF NOT success THEN Exit;
									DisposeTree(e);
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
  
  PROCEDURE Expr(VAR e: TreePtr);
  VAR
  	n: NodePtr;
  	t: TreePtr;
  BEGIN
    Term(e);
    WHILE (success) AND ((sy = plusSy) OR (sy = minusSy)) DO BEGIN
      CASE sy OF
        plusSy: BEGIN 
                  NewSy;
                  t := NIL;
                  Term(t);
                  IF NOT success THEN Exit;
                  (* Optimize *)
                  (* e.g. 1+1 *)
                  IF (OptiZero(e) AND OptiZero(t)) THEN
                  BEGIN
										(* SEM *)
										n := NewNode('+');
										n^.left := e;
										n^.right := t;
										(* Optimize *)
										IF (OptiConst(e) AND OptiConst(t)) THEN
											e := n
										ELSE
										BEGIN
											e := NewNode(ValueOf(n));
											DisposeTree(n);
										END;
										(* ENDSEM *)
                  END
                  (* e.g. 0 + 1 *)
                  ELSE IF ((NOT OptiZero(e)) AND OptiZero(t)) THEN
                  BEGIN
                  	e := t;
                  END;
                  (* 1 + 0, no statemant needed *)
                END;
        minusSy: BEGIN 
                   NewSy;
                   t := NIL;
                   Term(t);
                   IF NOT success THEN Exit;
                   (* Optimize *)
                   (* Case e.g. 1-0 *)
                   IF OptiZero(t) THEN
                   BEGIN
										 (* SEM *)
											n := NewNode('-');
											n^.left := e;
											n^.right := t;
											(* Optimize *)
											IF (OptiConst(e) AND OptiConst(t)) THEN
												e := n
											ELSE
											BEGIN
												e := NewNode(ValueOf(n));
												DisposeTree(n);
											END;
										 (* ENDSEM *)
                   END;
                 END;
      END;
    END;
  END;
  
  PROCEDURE Term(VAR t: TreePtr);
	VAR 
		n: NodePtr;
		f: TreePtr;
  BEGIN
    Fact(t);
    WHILE (success) AND ((sy = multSy) OR (sy = divSy)) DO BEGIN
      CASE sy OF
        multSy: BEGIN 
                  NewSy;
                  f := NIL;
                  Fact(f);
                  IF NOT success THEN Exit;
                  (* Optimize *)
                  (* e.g. 5 * 5 *)
                  IF (OptiOne(t) AND OptiOne(f)) THEN
                  BEGIN
										(* SEM *)
										n := NewNode('*');
										n^.left := t;
										n^.right := f;
										(* Optimize *)
										IF (OptiConst(t) AND OptiConst(f)) THEN
											t := n
										ELSE
										BEGIN
											t := NewNode(ValueOf(n));
											DisposeTree(n);
										END;
                  	(* ENDSEM *)
                  END
                  (* e.g. 1 * 5 *)
                  ELSE IF ((NOT OptiOne(t)) AND OptiOne(f)) THEN
                  BEGIN
                  	t := f;
                  END;
                  (* e.g. 5 * 1 no statemant needed *)
                END;
        divSy: BEGIN 
                 NewSy;
                 f := NIL;
                 Fact(f);
                 IF NOT success THEN Exit;
                 (* Optimize *)
                 (* e.g. 5 / 1 *)
                 IF OptiOne(f) THEN
                 BEGIN
									 (* SEM *)
										n := NewNode('/');
										n^.left := t;
										n^.right := f;
										(* Optimize *)
										IF (OptiConst(t) AND OptiConst(f)) THEN
											t := n
										ELSE
										BEGIN
											t := NewNode(ValueOf(n));
											DisposeTree(n);
										END;              
									 (* ENDSEM *)
									END;
               END;
      END;
    END;
  END;
  
  PROCEDURE Fact(VAR f: TreePtr);
  BEGIN
    CASE sy OF
      identSy: BEGIN
                 (* SEM *)
                 IF IsDecl(identStr) THEN BEGIN
                 		f := NewNode(identStr);
                 END
                 ELSE BEGIN
                   SemErr('variable ' + identStr + ' not declared');
                 END;
                 (* ENDSEM *)
                 NewSy;
               END;
      numberSy: BEGIN
                  (* SEM *)
                  f := NewNode(numberStr);
                  (* ENDSEM *)
                  NewSy;
                END;
      leftParSy: BEGIN
                   NewSy;
                   Expr(f);
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