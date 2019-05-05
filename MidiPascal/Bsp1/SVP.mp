PROGRAM SVP;
  VAR
    a, b, cs, f, n, test: INTEGER;
BEGIN
  READ(a);
  READ(b);
  cs := (a * a) + (b * b);
  WRITE(cs);
  READ(n);
  f := n;
  n := n - 1;
  test := 1;
  WHILE n DO
  BEGIN
  	IF test THEN
  	BEGIN
  		f := n * f;
  		n := n - 1;
  	END;
  END;
  WRITE(f);
END. 

