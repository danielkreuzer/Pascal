PROGRAM TelefonBuch;

CONST
	max = 10;

TYPE
	Entry = RECORD
		firstName: STRING[20];
		lastName: STRING[30];
		phoneNumber: INTEGER;
	END;
	PhoneBook = ARRAY[1..MAX] OF Entry;
	
FUNCTION FreePosition(pb: PhoneBook): INTEGER;
	VAR
		i, erg: INTEGER;
	BEGIN
		i := 1;
		erg := 0;
		
		REPEAT
			IF pb[i].firstName = '' THEN
				erg := 1;
			IF erg <> 1 THEN
				i := i + 1;
		UNTIL (erg = 1) OR (i > 10);
		
		IF erg = 1 THEN
			FreePosition := i
		ELSE
			FreePosition := -1;
	END;

PROCEDURE AddEntry(VAR pb: PhoneBook; newfn, newln: STRING; newnb: INTEGER);
	VAR
		newp: INTEGER;
	BEGIN
		IF FreePosition(pb) = -1 THEN
			WriteLn('Keine weitere Eingabe moeglich!')
		ELSE
		BEGIN
			newp := FreePosition(pb);
			
			pb[newp].firstName := newfn;
			pb[newp].lastName := newln;
			pb[newp].phoneNumber := newnb;
		END;
	END;

FUNCTION SearchNamePosition(pb: PhoneBook; fn, ln: STRING): INTEGER;
	VAR
		i, erg: INTEGER;
	BEGIN
		i := 1;
		erg := 0;
		
		REPEAT
			IF (pb[i].firstName = fn) AND (pb[i].lastName = ln) THEN
				erg := 1;
			IF erg <> 1 THEN
				i := i + 1;
		UNTIL (erg = 1) OR (i > 10);
		
		IF erg = 1 THEN
			SearchNamePosition := i
		ELSE
			SearchNamePosition := -1;
	END;

PROCEDURE DeleteEntry(VAR pb: PhoneBook; fn, ln: STRING);
	VAR
		namep: INTEGER;
	BEGIN
		IF SearchNamePosition(pb, fn, ln) = -1 THEN
			WriteLn('Kein Eintrag gefunden!')
		ELSE
		BEGIN
			namep := SearchNamePosition(pb, fn, ln);
			
			pb[namep].firstName := '';
			pb[namep].lastName := '';
			pb[namep].phoneNumber := 0;
			
			WHILE (namep + 1) < 11 DO
			BEGIN
				pb[namep].firstName := pb[namep + 1].firstName;
				pb[namep].lastName := pb[namep + 1].lastName;
				pb[namep].phoneNumber := pb[namep + 1].phoneNumber;
				
				pb[namep + 1].firstName := '';
				pb[namep + 1].lastName := '';
				pb[namep + 1].phoneNumber := 0;
				
				namep := namep + 1;
			END;
		END;			
	END;

PROCEDURE SearchNumber(pb: PhoneBook; fn, ln: STRING);
	VAR
		i, count: INTEGER;
	BEGIN
		count := 1;
		
		FOR i := 1 TO 10 DO
		BEGIN
			IF (pb[i].firstName = fn) AND (pb[i].lastName = ln) THEN
				WriteLn('Eintrag ', i, ': ', pb[i].phoneNumber)
			ELSE
				count := count + 1;
		END;
		
		IF count >= 10 THEN
			WriteLn('Keinen Eintrag gefunden!');
	END;

PROCEDURE SearchName(pb: PhoneBook; pn: INTEGER);
	VAR
		i, count: INTEGER;
	BEGIN
		count := 1;
		
		FOR i := 1 TO 10 DO
		BEGIN
			IF pb[i].phoneNumber = pn THEN
				WriteLn('Eintrag ', i, ': ', pb[i].firstName, ' ', pb[i].lastName)
			ELSE
				count := count + 1;
		END;
		
		IF count >= 10 THEN
			WriteLn('Keinen Eintrag gefunden!');
	END;

FUNCTION NrOfEntries(pb: PhoneBook): INTEGER;
	VAR
		i, count: INTEGER;
	BEGIN
		count := 0;
		
		FOR i := 1 TO 10 DO
		BEGIN
			IF pb[i].firstName <> '' THEN
				count := count + 1;
		END;
		
		NrOfEntries := count;
	END;
(* TESTPROZEDUREN/FUNKTIONEN *)
PROCEDURE WritePB(pb: PhoneBook);
	VAR
		i: INTEGER;
	BEGIN
		FOR i := 1 TO 10 DO
			WriteLn('Eintrag ', i, ': ', pb[i].firstName, ' ', pb[i].lastname, ' ', pb[i].phoneNumber);
	END;

PROCEDURE TestSearchNumbers(pb: PhoneBook);
	BEGIN
		SearchNumber(pb, 'Max', 'Muster');
		WriteLn('Expected: 112')
	END;

PROCEDURE TestSearchEntries(pb: PhoneBook);
	BEGIN
		SearchName(pb, 112);
		WriteLN('Expected: Max Muster');
	END;

VAR
	pbook: Phonebook;
	i: INTEGER;

BEGIN
	
	WriteLn('TestProgram ''Telefonverzeichnis''');
	WriteLn();
	
	WriteLn('Leeres Telefonbuch: ', NrOfEntries(pbook), ' erwartet: 0');
	WriteLn();
	
	(* Telefonbuch befuellen *)
	FOR i := 1 TO 8 DO
	BEGIN
		AddEntry(pbook, 'Max', 'Muster', 112);
	END;
	AddEntry(pbook, 'Florian', 'Muster', 109);
	AddEntry(pbook, 'Daniel', 'Muster', 132);
	
	WriteLn('Komplett befuelltes Telefonbuch (10 Eintraege): ');
	
	WritePB(pbook);
	
	WriteLn('Einträge: ', NrOfEntries(pbook), ' erwartet: 10');
	WriteLn();
	
	WriteLn('Nummer von Max Muster suchen:');
	TestSearchNumbers(pbook);
	WriteLn();
	
	WriteLn('Eintrag fuer die Nummer 112 suchen: ');
	TestSearchEntries(pbook);
	WriteLn();
	
	Write('Versuch das Telefonbuch zu ueberfuellen: ');
	AddEntry(pbook, 'Soll nicht', 'funktionieren', 133);
	WriteLn('Erwartet: Fehler');
	WriteLn();
	
	WriteLn('Eintrag Florian Muster loeschen');
	DeleteEntry(pbook, 'Florian', 'Muster');
	WritePB(pbook);
	WriteLn();
	
	WriteLn('Versuch den Eintrag Florian Muster zu finden: ');
	SearchNumber(pbook, 'Florian', 'Muster');
	SearchName(pbook, 109);
	WriteLn('Erwartet: Fehler');
	WriteLn();
	
	WriteLn('Aktuelle Anzahl von Eintraegen: ');
	WriteLn(NrOfEntries(pbook));
	WriteLn('Erwartet 9');
	WriteLN();
	
	WriteLn('Versuch den Eintrag Florian Muster nochmal zu loeschen');
	DeleteEntry(pbook, 'Florian', 'Muster');
	WriteLn('Erwartet: Fehler');
	WriteLn();
	
	WriteLn('Versuch ueberlange Namen einzugeben');
	WriteLn('VN: HALLOHALLOHALLOHALLOHALLOHALLO NM: HALLOHALLOHALLOHALLOHALLOHALLOHALLOHALLO');
	AddEntry(pbook, 'HALLOHALLOHALLOHALLOHALLOHALLO', 'HALLOHALLOHALLOHALLOHALLOHALLOHALLOHALLO', 154);
	WritePB(pbook);
	WriteLn('Neuer Eintrag mit abgeschnittenen Namen');
	WriteLn();
	
	
END.