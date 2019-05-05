PROGRAM BalanceBinTree;

TYPE
	NodePtr = ^Node;
	Node = RECORD
		val: INTEGER;
		left, right: NodePtr;
	END;
	TreePtr = NodePtr;
	DynArr = ARRAY [1..1] OF INTEGER;

VAR
	TreeArr: ^DynArr;
	
	
FUNCTION NewNode(val: INTEGER): NodePtr;
  VAR
    n: NodePtr;
  BEGIN
    New(n);
    n^.val := val;
    n^.left := NIL;
    n^.right := NIL;
    NewNode := n;
  END;

FUNCTION IsSorted(t: TreePtr): BOOLEAN;
  VAR
    b: BOOLEAN;
  BEGIN
    b := TRUE;
    IF t <> NIL THEN BEGIN
      b := IsSorted(t^.left) AND IsSorted(t^.right);
      IF t^.left <> NIL THEN
        b := b AND (t^.left^.val < t^.val);
      IF t^.right <> NIL THEN
        b := b AND (t^.right^.val >= t^.val);
    END;
    IsSorted := b;
  END;
  
PROCEDURE InsertSorted(VAR t: TreePtr; n: NodePtr);
   BEGIN
     IF NOT IsSorted(t) THEN BEGIN
       WriteLn('Tree is not sorted');
       HALT;
     END;
     IF t = NIL THEN
       t := n
     ELSE IF n^.val < t^.val THEN
       InsertSorted(t^.left, n)
     ELSE (* n^.val >= t^.val *)
       InsertSorted(t^.right, n);
  END;

PROCEDURE WriteTree(t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      Write(t^.val, ' ');
      WriteTree(t^.left);
      WriteTree(t^.right);
    END;
  END;

PROCEDURE NumOfElements(VAR count: INTEGER; t: TreePtr);
	BEGIN
		IF t <> NIL THEN
		BEGIN
			count := count + 1;
			NumOfElements(count, t^.left);
			NumOfElements(count, t^.right);
		END;
	END;

PROCEDURE SaveInArr(tree: TreePtr; VAR pos: INTEGER);
	BEGIN
		IF tree <> NIL THEN
		BEGIN
			
			SaveInArr(tree^.left, pos);
			pos := pos + 1;
			(*$R-*)
			TreeArr^[pos] := tree^.val;
			(*$R+*)
			SaveInArr(tree^.right, pos);
		END;
	END;

PROCEDURE DisposeTree(VAR tree: TreePtr);
	BEGIN
		IF tree <> NIL THEN BEGIN
			DisposeTree(tree^.left);
			DisposeTree(tree^.right);
			Dispose(tree);
			tree := NIL;
	   END;
  END;

(* build always the right and left side of the tree and
   always search the middle of the array *)
FUNCTION BuildNewTree(i, breakCount: INTEGER): TreePtr;
	VAR
		insideCounter: INTEGER;
		n: NodePtr;
	BEGIN
		(* check if last array position reached *)
		IF i <= breakCount THEN BEGIN
			(* search the new middle position of the array *)
			insideCounter := (i + breakCount) DIV 2;
			
			(*$R-*)
			n := NewNode(TreeArr^[insideCounter]);
			(*$R+*)
			
			(* build left side of tree *)
			n^.left := BuildNewTree(i, insideCounter-1);
			
			(* build right side of tree *)
			n^.right := BuildNewTree(insideCounter+1, breakCount);
			BuildNewTree := n;
		END 
		ELSE BEGIN
			BuildNewTree := NIL;
		END;
	END;

PROCEDURE ShowArray(count: INTEGER);
	VAR
		i: INTEGER;
		
	BEGIN
		FOR i := 0 TO (count - 1) DO
		BEGIN
			(*$R-*)
			WriteLn('Array on Pos ', i, ': ', TreeArr^[i]);
			(*$R+*)
		END;
	END;


PROCEDURE Balance(VAR tree: TreePtr);
	VAR
		count, breakCount, pos: INTEGER;
	BEGIN
		count := 0;
		pos := -1;
		
		(* count tree elements *)
		NumOfElements(count, tree);
		
		(* initialise dynamic array *)
		GetMem(TreeArr, count * SIZEOF(NodePtr));
		
		(* save value of tree in array *)
		SaveInArr(tree, pos);
		
		(* show saved array *)
		WriteLn('Show saved array: ');
		ShowArray(count);
		WriteLn;
		
		(* check if tree is destroyed after saving in array *)
		WriteLn('Tree after saving in array: ');
		WriteTree(tree);
		WriteLn;
		
		(* dispose tree *)
		DisposeTree(tree);
		
		(* check disposed tree *)
		WriteLn('Tree after Dispose: ');
		WriteTree(tree);
		WriteLn;
		
		(* build up new balanced tree *)
		breakCount := count - 1;
		tree := BuildNewTree(0, breakCount);
		
		(* free dynamic array *)
		FreeMem(TreeArr, count * SIZEOF(NodePtr));
	END;

VAR
	tree: TreePtr;
	count: INTEGER;

BEGIN
	(* --- *)(* Test 1 *)(* --- *)
		
	tree := NIL;
	count := 0;

	(* build new tree *)
	InsertSorted(tree, NewNode(3));
	InsertSorted(tree, NewNode(2));
	InsertSorted(tree, NewNode(1));
	InsertSorted(tree, NewNode(5));
	InsertSorted(tree, NewNode(8));
	InsertSorted(tree, NewNode(9));
	InsertSorted(tree, NewNode(89));
	InsertSorted(tree, NewNode(23));

	(* check tree *)
	WriteLn('New tree: ');
	WriteTree(tree);
	NumOfElements(count, tree);
	WriteLn('Num: ', count);
	WriteLn;

	(* balance Tree *)
	Balance(tree);

	(* write new tree *)
	WriteLn('Show new tree: ');
	WriteTree(tree);
	count := 0;
	NumOfElements(count, tree);
	WriteLn('Num: ', count);
		
	DisposeTree(tree);
	
END.