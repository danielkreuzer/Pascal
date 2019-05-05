PROGRAM Bsp1_Test;

USES
	Bsp1;
VAR
	Set1: SOS;
	Set2: SOS;
	Set3: SOSPtr;
	Set4: SOSPtr;
	SOSNew: SOS;
BEGIN
	WriteLn('----		Test Bsp 1 - Set of Strings		----');
	WriteLn;
	
	WriteLn('- Initialise dynamic and static SOS');
		Set1.Init;
		Set2.Init;
		New(Set3, Init);
		New(Set4, Init);
		WriteLn('	Completed!');
	WriteLn;
	
	WriteLn('- Test Empty and Cardinality');
		WriteLn('	Set1:');
		WriteLn('	Empty: ', Set1.Empty);
		WriteLn('	Cardinality: ', Set1.Cardinality);
		WriteLn('	Set2:');
		WriteLn('	Empty: ', Set2.Empty);
		WriteLn('	Cardinality: ', Set2.Cardinality);
		WriteLn('	Set3:');
		WriteLn('	Empty: ', Set3^.Empty);
		WriteLn('	Cardinality: ', Set3^.Cardinality);
		WriteLn('	Set4:');
		WriteLn('	Empty: ', Set4^.Empty);
		WriteLn('	Cardinality: ', Set4^.Cardinality);
	WriteLn;

	WriteLn('- Add Test-String');
		Set1.Add('Hallo');
		(* Test double insert *)
		Set1.Add('Hallo');
		Set1.Add('Willkommen');
		Set1.Add('ADE');
		Set1.Add('Blabla');
		Set1.Add('blabla');
		Set1.Add('Stop');
		Set1.Add('Begin');
		Set2.Add('Hallo');
		(* Test double insert *)
		Set2.Add('Hallo');
		Set2.Add('Willkommen');
		Set2.Add('ADE');
		Set2.Add('Blabla');
		Set2.Add('balablaed');
		Set2.Add('Stop it');
		Set2.Add('Begin now!');
		Set3^.Add('Hallo');
		(* Test double insert *)
		Set3^.Add('Hallo');
		Set3^.Add('Willkommen');
		Set3^.Add('ADE');
		Set3^.Add('Blabla');
		Set3^.Add('blabla');
		Set3^.Add('Stop');
		Set3^.Add('Begin');
		Set4^.Add('Hallo');
		(* Test double insert *)
		Set4^.Add('Hallo');
		Set4^.Add('Willkommen');
		Set4^.Add('ADE');
		Set4^.Add('Blabla');
		Set4^.Add('balablaed');
		Set4^.Add('Stop it');
		Set4^.Add('Begin now!');
	WriteLn;

	WriteLn('- Test Print');
		Set1.Print;
		WriteLn;
		Set2.Print;
		WriteLn;
		Set3^.Print;
		WriteLn;
		Set4^.Print;
	WriteLn;
	
	WriteLn('- Test Empty and Cardinality');
		WriteLn('	Set1:');
		WriteLn('	Empty: ', Set1.Empty);
		WriteLn('	Cardinality: ', Set1.Cardinality);
		WriteLn('	Set2:');
		WriteLn('	Empty: ', Set2.Empty);
		WriteLn('	Cardinality: ', Set2.Cardinality);
		WriteLn('	Set3:');
		WriteLn('	Empty: ', Set3^.Empty);
		WriteLn('	Cardinality: ', Set3^.Cardinality);
		WriteLn('	Set4:');
		WriteLn('	Empty: ', Set4^.Empty);
		WriteLn('	Cardinality: ', Set4^.Cardinality);
	WriteLn;
	
	WriteLn('- Test Contains');
		WriteLn('	Set 1 contains Hallo: ', Set1.Contains('Hallo'));
		WriteLn('	Set 2 contains Hallo: ', Set2.Contains('Hallo'));
		WriteLn('	Set 3 contains Hallo: ', Set3^.Contains('Hallo'));
		WriteLn('	Set 4 contains Hallo: ', Set4^.Contains('Hallo'));
	WriteLn;
	
	WriteLn('- Test Union');
		WriteLn('	Union of Set1 and Set2');
		SOSNew.Init;
		SOSNew := Set1.Union(Set2);
		WriteLn('	Cardinality of New Set: ', SOSNew.Cardinality);
		SOSNew.Done;
		WriteLn;
		WriteLn('	Union of Set3 and Set4');
		SOSNew.Init;
		SOSNew := Set3^.Union(Set4^);
		WriteLn('	Cardinality of New Set: ', SOSNew.Cardinality);
		WriteLn;
		SOSNew.Print;
		SOSNew.Done;
	WriteLn;

	WriteLn('- Test Intersection');
		WriteLn('	Intersection of Set1 and Set2');
		SOSNew.Init;
		SOSNew := Set1.Intersection(Set2);
		WriteLn('	Cardinality of New Set: ', SOSNew.Cardinality);
		SOSNew.Done;
		WriteLn;
		WriteLn('	Intersection of Set3 and Set4');
		SOSNew.Init;
		SOSNew := Set3^.Intersection(Set4^);
		WriteLn('	Cardinality of New Set: ', SOSNew.Cardinality);
		WriteLn;
		SOSNew.Print;
		SOSNew.Done;
	WriteLn;

	WriteLn('- Test Difference');
		WriteLn('	Difference of Set1 and Set2');
		SOSNew.Init;
		SOSNew := Set1.Difference(Set2);
		WriteLn('	Cardinality of New Set: ', SOSNew.Cardinality);
		SOSNew.Done;
		WriteLn;
		WriteLn('	Difference of Set3 and Set4');
		SOSNew.Init;
		SOSNew := Set3^.Difference(Set4^);
		WriteLn('	Cardinality of New Set: ', SOSNew.Cardinality);
		WriteLn;
		SOSNew.Print;
		SOSNew.Done;
	WriteLn;

	WriteLn('- Test Subset');
		WriteLn('	Subset of Set1 and Set1');
		WriteLn('	Is Set1 Subset of Set1?: ', Set1.Subset(Set1), ' expected: TRUE');
		WriteLn;
		WriteLn('	Subset of Set3 and Set4');
		WriteLn('	Is Set4 Subset of Set3?: ', Set3^.Subset(Set4^), ' expected: FALSE');
	WriteLn;
	
	WriteLn('- Test Remove');
		WriteLn('	Remove all elements in Set1');
		Set1.Remove('Hallo');
		(* Test double remove *)
		Set1.Remove('Hallo');
		Set1.Remove('Willkommen');
		Set1.Remove('ADE');
		Set1.Remove('Blabla');
		Set1.Remove('blabla');
		Set1.Remove('Stop');
		Set1.Remove('Begin');
		WriteLn('	Is Empty after remove?: ', Set1.Empty);
		WriteLn;
		
		WriteLn('	Remove all elements in Set3');
		Set3^.Remove('Hallo');
		(* Test double insert *)
		Set3^.Remove('Hallo');
		Set3^.Remove('Willkommen');
		Set3^.Remove('ADE');
		Set3^.Remove('Blabla');
		Set3^.Remove('blabla');
		Set3^.Remove('Stop');
		Set3^.Remove('Begin');
		WriteLn('	Is Empty after remove?: ', Set3^.Empty);
		Set3^.Print;
	WriteLn;

	WriteLn('- Set done');
		Set1.Done;
		Set2.Done;
		Dispose(Set3, Done);
		Dispose(Set4, Done);
		WriteLn('	Completed!');
	WriteLn;
	
END.