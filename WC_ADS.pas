UNIT WC_ADS;

INTERFACE
	FUNCTION IsEmpty: BOOLEAN;
	PROCEDURE Insert(val: STRING);
	PROCEDURE Remove(val: STRING);
	FUNCTION Contains(val: STRING): BOOLEAN;
	PROCEDURE Show;
	PROCEDURE DeleteAll;
	
IMPLEMENTATION
	TYPE
		NodePtr = ^Node;
		Node = RECORD
			val: STRING;
			left, right: NodePtr;
		END;
		TreePtr = NodePtr;
	
	VAR
		tree: TreePtr;
	
	PROCEDURE InitTree;
	BEGIN
		tree := NIL;
	END;
	
	FUNCTION IsEmpty: BOOLEAN;
	BEGIN
		IsEmpty := tree = NIL;
	END;
	
	PROCEDURE InsertSorted(VAR t: TreePtr; n: NodePtr);
	BEGIN
    IF t = NIL THEN
      t := n
    ELSE IF n^.val < t^.val THEN
      InsertSorted(t^.left, n)
    ELSE (* n^.val >= t^.val *)
      InsertSorted(t^.right, n);
  END;
	
	PROCEDURE Insert(val: STRING);
	VAR
		n: NodePtr;
	BEGIN
		New(n);
		n^.val := val;
		n^.left := NIL;
		n^.right := NIL;
		InsertSorted(tree, n);
	END;
	
	PROCEDURE DeleteNode(VAR t: TreePtr; val: STRING);
  VAR
    parent, cur, replacement, replParent: NodePtr;
  BEGIN
    parent := NIL;
    cur := t;
    
    (* find node with val *)
    WHILE (cur <> NIL) AND(cur^.val <> val) DO BEGIN
      parent := cur;
      IF val < cur^.val THEN
        cur := cur^.left
      ELSE
        cur := cur^.right;
    END;
    
    IF CUR <> NIL THEN BEGIN
      (* only if node is found *)
      IF cur^.right = NIL THEN
        replacement := cur^.left
      ELSE BEGIN
        (* find smallest node in right subtree *)
        replParent := NIL;
        replacement := cur^.right;
        WHILE replacement^.left <> NIL DO BEGIN
          replParent := replacement;
          replacement := replacement^.left;
        END;
      END;
      
      (* check if root should be deleted *)
      IF parent = NIL THEN
        t := replacement
      ELSE IF parent^.left = cur THEN
        (* check if left or right node is to be deleted *)
        parent^.left := replacement
      ELSE
        parent^.right := replacement;
      
      IF cur^.left <> replacement THEN BEGIN
        (* replacement^.left = NIL *)
        replacement^.left := cur^.left;
        IF replParent <> NIL THEN BEGIN
          replParent ^.left := replacement^.right;
          replacement^.right := cur^.right;
        END;
      END;
      Dispose(cur);
    END;
  END;
  
	PROCEDURE Remove(val: STRING);
	BEGIN
		DeleteNode(tree, val);
	END;
	
	FUNCTION ContainsVal(t: TreePtr; val: STRING): BOOLEAN;
	BEGIN
		IF t = NIL THEN
			ContainsVal := FALSE
		ELSE
			IF t^.val = val THEN
				ContainsVal := TRUE
			ELSE IF val < t^.val THEN
				ContainsVal := ContainsVal(t^.left, val)
			ELSE (* val >= t^.val *)
				ContainsVal := ContainsVal(t^.right, val);
	END;
	
	FUNCTION Contains(val: STRING): BOOLEAN;
	BEGIN
		Contains := ContainsVal(tree, val);
	END;
	
	PROCEDURE WriteTree(t: TreePtr);
	BEGIN
		IF t <> NIL THEN
		BEGIN
			WriteTree(t^.left);
			WriteLn(t^.val);
			WriteTree(t^.right);
		END;
	END;
	
	PROCEDURE Show;
	BEGIN
		IF tree = NIL THEN
			WriteLn('Empty!')
		ELSE
			WriteTree(tree);
	END;

	PROCEDURE DisposeTree(VAR t: TreePtr);
	BEGIN
		IF t <> NIL THEN
		BEGIN
      DisposeTree(t^.left);
      DisposeTree(t^.right);
      Dispose(t);
      t := NIL;
		END;
	END;

	PROCEDURE DeleteAll;
	BEGIN
		DisposeTree(tree);
	END;
	
BEGIN
	InitTree;
END.