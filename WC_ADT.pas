UNIT WC_ADT;

INTERFACE
	TYPE
		wordContainer = POINTER;
	
	FUNCTION IsEmpty(t: wordContainer): BOOLEAN;
	PROCEDURE Init(VAR t: wordContainer);	
	PROCEDURE Insert(VAR t: wordContainer; val: STRING);
	PROCEDURE Remove(VAR t: wordContainer; val: STRING);
	FUNCTION Contains(t: wordContainer; val: STRING): BOOLEAN;
	PROCEDURE Show(t: wordContainer);
	PROCEDURE DeleteTree(VAR t: wordContainer);         
	
IMPLEMENTATION
	TYPE
		TreePtr = ^Node;
		Node = RECORD
			val: STRING;
			left, right: TreePtr;
		END;
	
	PROCEDURE Init(VAR t: wordContainer);
	BEGIN
		TreePtr(t) := NIL;
	END;
	
	FUNCTION IsEmpty(t: wordContainer): BOOLEAN;
	BEGIN
		IsEmpty := TreePtr(t) = NIL;
	END;
	
	PROCEDURE InsertSorted(VAR t: wordContainer; n: TreePtr);
	BEGIN
    IF TreePtr(t) = NIL THEN
      TreePtr(t) := n
    ELSE IF n^.val < TreePtr(t)^.val THEN
      InsertSorted(TreePtr(t)^.left, n)
    ELSE (* n^.val >= TreePtr(t)^.val *)
      InsertSorted(TreePtr(t)^.right, n);
  END;
	
	PROCEDURE Insert(VAR t: wordContainer; val: STRING);
	VAR
		n: TreePtr;
	BEGIN
		New(n);
		n^.val := val;
		n^.left := NIL;
		n^.right := NIL;
		InsertSorted(TreePtr(t), n);
	END;
	
	PROCEDURE Remove(VAR t: wordContainer; val: STRING);
  VAR
    parent, cur, replacement, replParent: TreePtr;
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
	
	FUNCTION Contains(t: wordContainer; val: STRING): BOOLEAN;
	BEGIN
		IF TreePtr(t) = NIL THEN
			Contains := FALSE
		ELSE
			IF TreePtr(t)^.val = val THEN
				Contains := TRUE
			ELSE IF val < TreePtr(t)^.val THEN
				Contains := Contains(TreePtr(t)^.left, val)
			ELSE (* val >= t^.val *)
				Contains := Contains(TreePtr(t)^.right, val);
	END;
	
	PROCEDURE Show(t: wordContainer);
	BEGIN
		IF TreePtr(t) <> NIL THEN
		BEGIN
			Show(TreePtr(t)^.left);
			WriteLn(TreePtr(t)^.val);
			Show(TreePtr(t)^.right);
		END;
	END;

	PROCEDURE DeleteTree(VAR t: wordContainer);
	BEGIN
		IF TreePtr(t) <> NIL THEN
		BEGIN
      DeleteTree(TreePtr(t)^.left);
      DeleteTree(TreePtr(t)^.right);
      Dispose(TreePtr(t));
      TreePtr(t) := NIL;
		END;
	END;

BEGIN
END.