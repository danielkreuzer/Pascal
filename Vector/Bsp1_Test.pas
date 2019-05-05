PROGRAM Bsp1_Test;

USES
	Bsp1;

VAR
	container: Vector;
	i: INTEGER;
	ok: BOOLEAN;
	value: INTEGER;
	
BEGIN
	WriteLn(' 	---- Test Bsp1	class vector ----');
	WriteLn;
	
	WriteLn('- Init container');
		container.Init;
		value := 0;
		WriteLn('	Done!');
	WriteLn;
	
	WriteLn('- Test Add with 25 entrys and Print it');
		FOR i := 1 TO 25 DO
		BEGIN
			container.Add(i);
		END;
		container.Print;
		WriteLn;
		WriteLn('	Size:		',container.size);
		WriteLn('	Capacity:	', container.capacity);
	WriteLn;
	
	WriteLn('- Test GetElementAt with the first 5 entrys');
		FOR i := 1 TO 5 DO
		BEGIN
			container.GetElementAt(i, ok, value);
			WriteLn('	Element:	', value, '	on pos: ', i, '	', ok);
		END;
	WriteLn;

	WriteLn('- Test Remove of the first 10 elements and print outcome');
	WriteLn('- This test shows functionality of MoveUp to');
		FOR i := 1 TO 10 DO
		BEGIN
			container.RemoveElementAt(1, ok, value);
			WriteLn('	Element:	', value, '	on pos:	1	removed!	', ok);
		END;
		WriteLn;
		container.Print;
		WriteLn;
		WriteLn('	Size:		',container.size);
		WriteLn('	Capacity:	', container.capacity);
	WriteLn;
	
	WriteLn('- Dispose container');
		container.Done;
		WriteLn('	Done!');
	WriteLn;
	
END.