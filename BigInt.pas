(* BigInts:																				F.Li, 1998-11-22
	-------																					HDO, 2000-11-13
	Artihmetic for arbitrary size integers which are
	represented as singly-linked lists.
==================================================================*)

PROGRAM BigInts;

(*$DEFINE SIGNED*)	(*when defined: first digit is sign +1 or -1*)

CONST
	base = 1000;			(*base of number system used in all*)
										(*  calculations, big digits: 0 .. base - 1*)

TYPE
	NodePtr = ^Node;
	Node = RECORD
		next: NodePtr;
		val: INTEGER;
	END; (*RECORD*)
	BigIntPtr = NodePtr;


FUNCTION NewNode(val: INTEGER): NodePtr;
	VAR
		n: NodePtr;
	BEGIN
		New(n);
		(*IF n == NIL THEN ...*)
		n^.next := NIL;
		n^.val := val;
		NewNode := n;
	END; (*NewNode*)

FUNCTION Zero: BigIntPtr;
	BEGIN
		Zero := NewNode(0);
	END; (*Zero*)

PROCEDURE Append(VAR bi: BigIntPtr; val: INTEGER);
	VAR
		n, last: NodePtr;
	BEGIN
		n := NewNode(val);
		IF bi = NIL THEN
			bi := n
		ELSE BEGIN (*l <>NIL*)
			last := bi;
			WHILE last^.next <> NIL DO BEGIN
				last := last^.next;
			END; (*WHILE*)
			last^.next := n;
		END; (*ELSE*)
	END; (*Append*)

PROCEDURE Prepend(VAR bi: BigIntPtr; val: INTEGER);
	VAR
		n: NodePtr;
	BEGIN
		n := NewNode(val);
		n^.next := bi;
		bi := n;
	END; (*Prepend*)

FUNCTION Sign(bi: BigIntPtr): INTEGER;
	BEGIN
(*$IFDEF SIGNED*)
		(*assert: bi <> NIL*)
		Sign := bi^.val; (*results in +1 or -1*)
(*$ELSE*)
		WriteLn('Error in Sign: no sign node available');
		Halt;
(*$ENDIF*)
	END; (*Sign*)

FUNCTION CopyOfBigInt(bi: BigIntPtr): BigIntPtr;
		VAR
			n: NodePtr;
			cBi: BigIntPtr; (*cBi = copy of BigIntPtr*)
	BEGIN
		cBi := NIL;
		n := bi;
		WHILE n <> NIL DO BEGIN
			Append(cBi, n^.val);
			n := n^.next;
		END; (*WHILE*)
		CopyOfBigInt := cBi;
	END; (*CopyOfBigInt*)

PROCEDURE InvertBigInt(VAR bi: BigIntPtr);
	VAR
		iBi, next: NodePtr; (*iBi = inverted BigIntPtr*)
	BEGIN
		IF bi <> NIL THEN BEGIN
			iBi := bi;
			bi := bi^.next;
			iBi^.next := NIL;
			WHILE bi <> NIL DO BEGIN
				next := bi^.next;
				bi^.next := iBi;
				iBi := bi;
				bi := next;
			END; (*WHILE*)
			bi := iBi;
		END; (*IF*)
	END; (*InvertBigInt*)

PROCEDURE DisposeBigInt(VAR bi: BigIntPtr);
	VAR
		next: NodePtr;
	BEGIN
		WHILE bi <> NIL DO BEGIN
			next := bi^.next;
			Dispose(bi);
			bi := next;
		END; (*WHILE*)
	END; (*DisposeBigInt*)


	(* ReadBigInt: reads BigIntPtr, version for base = 1000
		 Input syntax: BigIntPtr = { digit }.
									 BigIntPtr = [+ | -] digit { digit }.
		 The empty string is treated as zero, and as the whole
		 input is read into one STRING, max. length is 255.
	-------------------------------------------------------*)
PROCEDURE ReadBigInt(VAR bi: BigIntPtr);
	VAR
		s: STRING;           (*input string*)
		iBeg, iEnd: INTEGER; (*begin and end of proper input *)
		bigDig, decDig: INTEGER;
		nrOfBigDigits, lenOfFirst: INTEGER;
		sign, i, j: INTEGER;

		PROCEDURE WriteWarning(warnPos: INTEGER);
			BEGIN
				WriteLn('Warning in ReadBigInt: ',
								'character ', s[warnPos],
								' in column ', warnPos, ' is treated as zero');
			END; (*WriteWarning*)

	BEGIN (*ReadBigInt*)
		IF base <> 1000 THEN 
		BEGIN
			WriteLn('Error in ReadBigInt: ',
							'procedure currently works for base = 1000 only');
			Halt;
		END; (*IF*)
		ReadLn(s);
		iEnd := Length(s);
		IF iEnd = 0 THEN
			bi := Zero
		ELSE BEGIN

(*$IFDEF SIGNED*)
			IF s[1] = '-' THEN BEGIN
				sign := -1;
				iBeg :=  2;
			END (*THEN*)
			ELSE IF s[1] = '+' THEN BEGIN
				sign := 1;
				iBeg := 2;
			END (*THEN*)
			ELSE BEGIN
(*$ENDIF*)
				sign := 1;
				iBeg := 1;
(*$IFDEF SIGNED*)
			END; (*ELSE*)
(*$ENDIF*)

			WHILE (iBeg <= iEnd) AND
						((s[iBeg] < '1') OR (s[iBeg] > '9')) DO BEGIN
				IF (s[iBeg] <> '0') AND (s[iBeg] <> ' ') THEN
					WriteWarning(iBeg);
				iBeg := iBeg + 1;
			END; (*WHILE*)

			(*get value from s[iBeg .. iEnd]*)
			IF iBeg > iEnd THEN
				bi := Zero
			ELSE BEGIN
				bi := NIL;
				nrOfBigDigits := (iEnd - iBeg) DIV 3 + 1;
				lenOfFirst    := (iEnd - iBeg) MOD 3 + 1;
				FOR i := 1 TO nrOfBigDigits DO BEGIN
					bigDig := 0;
					FOR j := iBeg TO iBeg + lenOfFirst - 1 DO BEGIN
						IF (s[j] >= '0') AND (s[j] <= '9') THEN
							decDig := Ord(s[j]) - Ord('0')
						ELSE BEGIN
							WriteWarning(j);
							decDig := 0;
						END; (*ELSE*)
						bigDig := bigDig * 10 + decDig;
					END; (*FOR*)
					Prepend(bi, bigDig);
					iBeg := iBeg + lenOfFirst;
					lenOfFirst := 3;
				END; (*FOR*)
(*$IFDEF SIGNED*)
				Prepend(bi, sign);
(*$ENDIF*)
			END; (*IF*)
		END; (*ELSE*)
	END; (*ReadBigInt*)


  (* WriteBigInt: writes BigIntPtr, version for base = 1000
  -------------------------------------------------------*)
PROCEDURE WriteBigInt(bi: BigIntPtr);
	VAR
		revBi: BigIntPtr;
		n: NodePtr;
	BEGIN
		IF base <> 1000 THEN BEGIN
			WriteLn('Error in WriteBigInt: ',
							'procedure currently works for base = 1000 only');
			Halt;
		END; (*IF*)
		IF bi^.next = NIL THEN
			Write('0')
		ELSE BEGIN
	(*$IFDEF SIGNED*)
				IF Sign(bi) = -1 THEN
					Write('-');
				revBi := CopyOfBigInt(bi^.next);
	(*$ELSE*)
				revBi := CopyOfBigInt(bi);
	(*$ENDIF*)
			InvertBigInt(revBi);
			n := revBi;
			Write(n^.val); (*first big digit printed without leading zeros*)
			n := n^.next;
			WHILE n <> NIL DO BEGIN
				IF n^.val >= 100 THEN
					Write(n^.val)
				ELSE IF n^.val >= 10 THEN
					Write('0', n^.val)
				ELSE (*n^.val < 10*)
					Write('00', n^.val);
				n := n^.next;
			END; (*WHILE*)
			DisposeBigInt(revBi); (*release the copy*)
		END; (*IF*)
	END; (*WriteBigInt*)

FUNCTION LengthOfBigInt(bi: BigIntPtr): INTEGER;
	VAR
		x: INTEGER;
		leng: NodePtr;
		
	BEGIN
		leng := bi;
		x := 0;
		
		WHILE leng <> NIL DO
		BEGIN
			x := x + 1;
			leng := leng^.next;
		END;
		
		LengthOfBigInt := x;
	END;
	
(* Sum: Adds two bigint numbers
  -------------------------------------------------------*)
 
FUNCTION SumUp(a1, b1: BigIntPtr; siA, siB: INTEGER): BigIntPtr;
	VAR
		summed, carry : INTEGER;
		result: BigIntPtr;
		
	BEGIN
		(* initialise *)
		carry := 0;
		summed := 0;
		result := NIL;
		
		WHILE b1 <> NIL DO
		BEGIN
			summed :=	abs(a1^.val + b1^.val + carry) MOD 1000;
			carry := abs(a1^.val + b1^.val + carry) DIV 1000;
			Append(result, summed);
			b1 := b1^.next;
			a1 := a1^.next;
		END;
		(* Check carry if leng A = leng B *)
		IF (carry <> 0) AND (a1 = NIL) THEN
			Append(result, carry);
		(* Append rest of a1 *)
		WHILE a1 <> NIL DO
		BEGIN
			summed :=	abs(a1^.val + carry) MOD 1000;
			carry := abs(a1^.val + carry) DIV 1000;
			Append(result, summed);
			(* Check carry *)
			IF (a1^.next = NIL) AND (carry <> 0) THEN
				Append(result, carry);
			a1 := a1^.next;
		END;
		IF siA = 1 THEN
			Prepend(result, 1)
		ELSE IF siA = -1 THEN
			Prepend(result, -1);
		SumUp := result;
	END; (* SumUP *)

PROCEDURE SumUpDifSign(b1, a1: BigIntPtr; siA, siB: INTEGER; VAR result: BigIntPtr);
	VAR
		summed, carry: INTEGER;
		
	BEGIN
		carry := 0;
		summed := 0;
		WHILE a1 <> NIL DO
		BEGIN
			IF b1^.val >= a1^.val THEN
			BEGIN
				summed :=	abs(b1^.val - (a1^.val + carry)) MOD 1000;
				carry := 0;
				Append(result, summed);
			END
			ELSE IF b1^.val < a1^.val THEN
			BEGIN
				summed :=	abs((b1^.val + 1000) - (a1^.val + carry)) MOD 1000;
				carry := 1;
				Append(result, summed);
			END;
			b1 := b1^.next;
			a1 := a1^.next;
		END;
		(* Append rest of a1 *)
		WHILE b1 <> NIL DO
		BEGIN
			summed :=	abs(b1^.val - carry) MOD 1000;
			carry := abs(b1^.val - carry) DIV 1000;
			Append(result, summed);
			b1 := b1^.next;
		END;
	END;
  
FUNCTION Sum(a, b: BigIntPtr): BigIntPtr; (* compute sum = a + b *)
	VAR
		a1, b1, result: BigIntPtr;
		na1, nb1: NodePtr;
		siA, siB, lengA, lengB: INTEGER;
		
	BEGIN
		(* value possibilities *)
		IF (a^.val = 0) AND (b^.val = 0) THEN
			Sum := a
		ELSE IF (a^.val = 0) AND (b^.val <> 0) THEN
			Sum := b
		ELSE IF (a^.val <> 0) AND (b^.val = 0) THEN
			Sum := a
		ELSE IF (a^.val <> 0) AND (b^.val <> 0) THEN
		BEGIN
			(* initialise *)
			result := NIL;
			(* Check Sign *)
			siA := Sign(a);
			siB := Sign(b);
			(* List without Sign *)
			a1 := CopyOfBigInt(a^.next);
			b1 := CopyOfBigInt(b^.next);
			(* check length of a and b *)
			lengA := LengthOfBigInt(a1);
			lengB := LengthOfBigInt(b1);
			
			(* varius sign possibilities ---- (-x) + (-x) OR (+x) + (+x) ---- *)
			IF (siA = siB) THEN
			BEGIN
				(* varius length possiblities *)
				IF (lengA >= lengB) THEN
				BEGIN
					Sum := SumUp(a1, b1, siA, siB);
				END (* length if *)
				ELSE IF (lengA < lengB) THEN
				BEGIN
					Sum := SumUp(b1, a1, siA, siB);
				END; (* length if *)
				DisposeBigInt(a1);
				DisposeBigInt(b1);
			END (* varius sign *)
			(* varius sign possibilities ---- (-x) + (+x) OR (+x) + (-x) ---- *)
			ELSE IF (siA <> siB) THEN	
			BEGIN
				na1 := a1;
				nb1 := b1;
				(* find bigger value *)
				WHILE na1^.next <> NIL DO
					na1 := na1^.next;
				WHILE nb1^.next <> NIL DO
					nb1 := nb1^.next;
				(* varius value and length possibilities *)
				IF ((lengA = lengB) AND (na1^.val > nb1^.val)) XOR (lengA > lengB) THEN
				BEGIN
					SumUpDifSign(a1, b1, siA, siB, result);
					Prepend(result, siA);
					Sum := result;
				END (* bigger value *)
				(* varius value and length possibilities *)
				ELSE IF ((lengA = lengB) AND (na1^.val < nb1^.val)) XOR (lengA < lengB) THEN
				BEGIN
					SumUpDifSign(b1, a1, siA, siB, result);
					Prepend(result, siB);
					Sum := result;
				END; (* bigger value *)
				DisposeBigInt(a1);
				DisposeBigInt(b1);
			END; (* Varius sign *)
		END; (* value possibilities *)
	END; (* SUM *)

(* Product: Multiplied two bigint numbers
  -------------------------------------------------------*)
FUNCTION Product(a, b: BigIntPtr): BigIntPtr;
	VAR
		result, tempresult: BigIntPtr;
		a1, b1, va1, vb1, nb1, cn: NodePtr;
		siA, siB, carry, ncarry, prod, position, lengA, lengB: INTEGER;
		
	BEGIN
		IF (a^.val = 0) OR (b^.val = 0) THEN
		BEGIN
			result := NIL;
			Append(result, 0);
			Product := result;
		END
		ELSE
		BEGIN
			(* initialise *)
			carry := 0;
			prod := 0;
			result := NIL;
			position := 0;
			(* Check Sign *)
			siA := Sign(a);
			siB := Sign(b);
			(* List without Sign *)
			a1 := CopyOfBigInt(a^.next);
			b1 := CopyOfBigInt(b^.next);
			
			(* find bigger value *)
			va1 := a1;
			vb1 := b1;
			(* check length of a and b *)
			lengA := LengthOfBigInt(a1);
			lengB := LengthOfBigInt(b1);
			WHILE va1^.next <> NIL DO
				va1 := va1^.next;
			WHILE vb1^.next <> NIL DO
				vb1 := vb1^.next;
			(* turn operation to  [smaller bigInt] * [bigger bigInt] *)
			IF ((lengA = lengB) AND (va1^.val > vb1^.val)) XOR (lengA > lengB) THEN
			BEGIN
				cn := a1;
				a1 := b1;
				b1 := cn;
			END;
			
			WHILE a1 <> NIL DO
			BEGIN
				nb1 := b1;
				tempresult := NIL;
				WHILE nb1 <> NIL DO
				BEGIN
					prod := ((a1^.val * nb1^.val) + carry) MOD 1000;
					carry := ((a1^.val * nb1^.val) + carry) DIV 1000;
					Prepend(tempresult, prod);
					nb1 := nb1^.next;
				END; (* WHILE b1 *)
				(* check carry *)
				WHILE carry <> 0 DO
				BEGIN
					ncarry := carry MOD 1000;
					Prepend(tempresult, ncarry);
					carry := carry DIV 1000;
				END;
				(* check Prepend 0 to compute sum of result + tempresult *)
				IF position <> 0 THEN
				BEGIN
					Append(tempresult, 0);
					position := 0;
				END;
				(* InvertBigInt tempresult *)
				InvertBigInt(tempresult);
				(* create sign to compute sum of result + tempresult *)
				Prepend(result, 1);
				Prepend(tempresult, 1);
				(* compute sum of result + tempresult *)
				result := SUM(result, tempresult);
				(* result without sign *)
				result := CopyOfBigInt(result^.next);
				(* Dispose tempresult *)
				DisposeBigInt(tempresult);
				(* set position, for check Prepend *)
				position := position + 1;
				a1 := a1^.next;
			END; (* WHILE a1 *)
			(* compute sign of Product *)
			Prepend(result, (siA * siB));
			Product := result;
		END; (* NIL IF *)
	END; (* Product *)

PROCEDURE ShowBigInt(b: BigIntPtr);
	VAR
		bip: NodePtr;
		
	BEGIN
		bip := b;
			WHILE bip <> NIL DO
			BEGIN
				Write(' ->', bip^.val);
				bip := bip^.next;
			END;
		WriteLn('-|');
	END;


(*=== main program, for test purposes ===*)

VAR
	ba, bb, bis, bip: BigIntPtr;

BEGIN (*BigInts*)
	
	(* Read Input *)
	Write('big int A > ');
	ReadBigInt(ba);
	Write('big int B > ');
	ReadBigInt(bb);
	
	(* Compute Sum, Product *)
	bis := Sum(ba, bb);
	bip := Product(ba, bb);
	WriteLn;
	Write('big int Sum = ');
	WriteBigInt(bis);
	WriteLn;
	Write('big int Prod = ');
	WriteBigInt(bip);
	WriteLn;
	ReadLn;
	
	(* Show List *)
	WriteLn('Show Sum List:');
	ShowBigInt(bis);
	WriteLn('Show Product List:');
	ShowBigInt(bip);

END. (*BigInts*)