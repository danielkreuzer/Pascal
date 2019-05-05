UNIT Bsp2;

INTERFACE

	USES
		Bsp1;

	TYPE
		PositiveStackPtr = ^PositiveStack;
		PositiveStack = OBJECT
			PRIVATE
				Stack: Vector;
			PUBLIC
				CONSTRUCTOR Init;
				DESTRUCTOR Done; VIRTUAL;
				FUNCTION IsEmpty: BOOLEAN; VIRTUAL;
				PROCEDURE Push(e: INTEGER); VIRTUAL;
				FUNCTION Pop: INTEGER; VIRTUAL;
				PROCEDURE Print; VIRTUAL;
				PRIVATE FUNCTION IsPositive(e: INTEGER): BOOLEAN;
		END;
			
			EvenQueuePtr = ^EvenQueue;
			EvenQueue = OBJECT
				PRIVATE
					Queue: Vector;
				PUBLIC
					CONSTRUCTOR Init;
					DESTRUCTOR Done; VIRTUAL;
					FUNCTION IsEmpty: BOOLEAN; VIRTUAL;
					PROCEDURE Enqueue(e: INTEGER); VIRTUAL;
					FUNCTION Dequeue: INTEGER; VIRTUAL;
					PROCEDURE Print; VIRTUAL;
			END;

IMPLEMENTATION

(* Positive Stack - - - - - - - - - - - *)
	
	CONSTRUCTOR PositiveStack.Init;
	BEGIN
		Stack.Init;
	END;
	
	DESTRUCTOR PositiveStack.Done;
	BEGIN
		Stack.Done;
	END;
	
	FUNCTION PositiveStack.IsEmpty: BOOLEAN;
	BEGIN
		IsEmpty := Stack.Size = 0;
	END;
	
	PROCEDURE PositiveStack.Push(e: INTEGER);
	BEGIN
		IF IsPositive(e) THEN
			Stack.Add(e)
		ELSE
			WriteLn('	Only positive INTEGER in Stack allowed!');
	END;
	
	FUNCTION PositiveStack.Pop: INTEGER;
	VAR
		ok: BOOLEAN;
		value: INTEGER;
	BEGIN
		Stack.RemoveElementAt(Stack.Size, ok, value);
		IF ok THEN
			Pop := value
		ELSE
			WriteLn('	Pop failed!');
	END;
	
	FUNCTION PositiveStack.IsPositive(e: INTEGER): BOOLEAN;
	BEGIN
		IsPositive := e >= 0;
	END;
	
	PROCEDURE PositiveStack.Print;
	BEGIN
		Stack.Print;
	END;

(* EvenQueue - - - - - - - - - - - - - - - - *)

	CONSTRUCTOR EvenQueue.Init;
	BEGIN
		Queue.Init;
	END;
	
	DESTRUCTOR EvenQueue.Done; 
	BEGIN
		Queue.Done;
	END;
	
	FUNCTION EvenQueue.IsEmpty: BOOLEAN;
	BEGIN
		IsEmpty := Queue.Size = 0;
	END;
	
	PROCEDURE EvenQueue.Enqueue(e: INTEGER);
	BEGIN
		IF NOT Odd(e) THEN
			Queue.Add(e)
		ELSE
			WriteLn('	Only Even INTEGER allowed!');
	END;
	
	FUNCTION EvenQueue.Dequeue: INTEGER;
	VAR
		ok: BOOLEAN;
		Value: INTEGER;
	BEGIN
		Queue.RemoveElementAt(1, ok, value);
		IF ok THEN
			Dequeue := value
		ELSE
			WriteLn('	Dequeue not possible!');
	END;
	
	PROCEDURE EvenQueue.Print;
	BEGIN
		Queue.Print;
	END;
	
BEGIN
END.