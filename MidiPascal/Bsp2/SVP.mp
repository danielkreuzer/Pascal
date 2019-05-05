PROGRAM SVP;
  VAR
    a, b, cs, n, f, test: INTEGER;
BEGIN
  READ(a);
  READ(b);
  cs := (a * a) + (b * b);
  WRITE(cs);
  READ(n);
  f := n;
  n := 0;
  test := 1;
  WHILE n DO
  BEGIN
  	IF test THEN
  	BEGIN
  		f := n * f;
  	END;
  END;
  WRITE(f);

  a := 0 + ( 17 + 4 ) * 1;
END. 

