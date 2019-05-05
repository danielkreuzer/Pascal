PROGRAM Bsp3_Test;

USES
	Bsp3;

VAR
	container: Map;
	value: String;
BEGIN
	WriteLn('	---- Test Bsp3	Container Map ----');
	WriteLn;
	
	WriteLn('- init new container');
		container.Init;
		WriteLn('	Done!');
	WriteLn;
	
	WriteLn('- show size');
		WriteLn('	', container.Size);
	WriteLn;
	
	WriteLn('- add test entrys and print');
		container.Put('Ade', 'Algorithmen und Datenstrukturen');
		container.Put('Dem', 'Datenbanken');
		container.Put('Mat', 'Mathe');
		container.Put('Ossi', 'Oswald');
		container.Put('Bla', 'Blablablabla');
		container.Put('Nope', 'Auf keinen Fall');
		container.Put('Ue9', 'Uebung 10');
		container.Print;
	WriteLn;
	
	WriteLn('- show size');
		WriteLn('	', container.Size);
	WriteLn;

	
	WriteLn('- get value of key Ossi');
		container.GetValue('Ossi', value);
		WriteLn('	got with key Ossi value: ', value);
	WriteLn;
	
	WriteLn('- remove entry with key bla, and show container and size');
		container.Remove('Bla');
		container.Print;
		WriteLn;
		WriteLn('	Size: ', container.Size);
	WriteLn;
	
	WriteLn('- Try to remove entry bla again');
		container.Remove('Bla');
	WriteLn;
	
	WriteLn('- Try to add Uebung 9 with existing keywort Ue9 and print');
		container.Put('Ue9', 'Uebung 9');
		container.Print;
	WriteLn;
	
	WriteLn('- destruct container');
		container.Done;
		WriteLn('	Done!');
	WriteLn;
	
END.