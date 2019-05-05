PROGRAM Bsp2_Test;

USES
	Bsp2;

VAR
	Stack: PositiveStack;
	Queue: EvenQueue;
BEGIN
	WriteLn('		---- Test Bsp2	stack and queue ----');
	WriteLn;
	
	WriteLn('- init stack and queue');
		Stack.Init;
		Queue.Init;
		WriteLn('	Done!');
	WriteLn;
	
	WriteLn('		-- Test stack --');
	WriteLn;
	
	WriteLn('- test is empty stack and queue');
		WriteLn('	stack: ', Stack.IsEmpty);
		WriteLn('	queue: ', Queue.IsEmpty);
	WriteLn;
	
	WriteLn('- push test entrys in stack and print');
		Stack.Push(4);
		Stack.Push(3);
		Stack.Push(9);
		Stack.Push(55);
		Stack.Push(321);
		Stack.Print;
	WriteLn;
	
	WriteLn('- try to push negative integer -54');
		Stack.Push(-54);
	WriteLn;
	
	WriteLn('- test is empty stack');
		WriteLn('	stack: ', Stack.IsEmpty);
	WriteLn;
	
	WriteLn('- pop 2 entrys, show them and print stack afterwards');
		WriteLn('	1st pop: ',Stack.Pop);
		WriteLn('	2nd pop: ',Stack.Pop);
		WriteLn;
		Stack.Print;
	WriteLn;
	
	WriteLn('		-- Test queue --');
	WriteLn;
	
	WriteLn(' enqueue test entrys and print queue');
		Queue.Enqueue(6);
		Queue.Enqueue(4);
		Queue.Enqueue(2);
		Queue.Enqueue(422);
		Queue.Enqueue(122);
		Queue.Print;
	WriteLn;
	
	WriteLn('- try to enqueue odd integer 89');
		Queue.Enqueue(89);
	WriteLn;
	
	WriteLn('- test is empty queue');
		WriteLn('	queue: ', Queue.IsEmpty);
	WriteLn;

	WriteLn('- dequeue 2 entrys, show them and print queue afterwards');
		WriteLn('	1st dequeue: ', Queue.Dequeue);
		WriteLn('	2nd dequeue: ', Queue.Dequeue);
		WriteLn;
		Queue.Print;
	WriteLn;
	
	WriteLn('- destruct stack and queue');
		Stack.Done;
		Queue.Done;
		WriteLn('	Done!');
	WriteLn;
	
END.