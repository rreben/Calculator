Calculator
==========

Calculator is based on the c193p iOS development course at ITunes U Stanford. I use it as a test project. 

Todos:
+ Backspace button to correct numbers in x / display register (done)
+ pi button (done)

+ correct bug. result of calculation has to be usable as input of next calculation. (done)
+ correct bug. Division does not work (done)
+ switch radians (0 t 2 pi, default) in degrees, try UI Switch (done)
  + Refactoring: dnry with setting degree or radians on brain / model (done)
  + Refactoring: use boolean property to enable KVO and dnry (done)
  
Assignment 1 (fall 2011)
+ input of decimal numbers (done)
  + no leading 0 like 05.67 (done)
  + no leading . like .56 (should be 0.56) (done)
  + no non valid numbers like 4.123.9.78 (done)
+ sin (done)
+ cos (done)
+ sqrt (done)
+ 1/x (extra) (done)
+ pi as an operation 
  + pi as an operation not just entering pi in the display (done)
  + pi enter 3 * (results 3*pi) (done)
  + pi 3 * (results 3*pi) (done)
  + pi enter 3 * + (should result in 4*pi, which might be unexpected) (done) 
+ input strip on top of display (done)
  + user enters 6.52 5 + 2 * so this should be shown in the input strip (done)
+ C button (done)
  + clear input strip (done)
  + clear operand stack (done)
  + clear state of UI (done)
  + 5 7 C 5 should result in 5 being shown. (done)
+ hanlde 1/0 gracefully
+ supplement any operation with 0 if there are not enough operands
+ Backspace to correct numbers which have been typed in. (done)
+ Add = to the input strip to mark results of computations (done)
+ CHS (will not be done)
  + If user is in the middle of typing in a number then just change the sign of the string
  + If enter has been pressed then CHS should work as a unanry operator
* Hint: NSString *greeting = @"Hello There Joe, how are ya?";
       NSRange range = [greeting rangeOfString:@"Bob"];
       if (range.location == NSNotFound) { ... /* no Bob */ }
       

Assignment 2 (fall 2011)
+ Merge Calculatorbrain with runProgram (done)
+ implement interface (done, however added parameter to control degrees vs radians for calculation)
  !   @property (readonly) id program;
  !   + (double)runProgram:(id)program;
  !   + (NSString *)descriptionOfProgram:(id)program;
+ variables as operands (done)
  !   + (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
  !   + (NSSet *)variablesUsedInProgram:(id)program;
+ UILabel for descriptionOfProgram (done)
+ Add a few variable buttons (done)
+ update display by using runProgram:usingVariableValues: (done)
+ The variable values dictionary it passes to this method should be a property in your Controller (let’s call it “testVariableValues”). (done)
  * The NSDictionary class method dictionaryWithObjectsAndKeys: is great for Required Task 3e.
+ Add a UILabel to your UI whose contents are determined by iterating through all the variablesUsedInProgram: and displaying each with its current value from testVariableValues. Example display: “x = 5 y = 4.8 foo = 0”.
+ Add a few different “test” buttons which set testVariableValues to some preset testing values. 
  + One of them should set testVariableValues to nil. 
  + update the rest of your UI when you change testVariableValues by pressing one of these test buttons. 
  + Make sure that your preset values are good edge-cases for testing
+ Re-implement the descriptionOfProgram: 
  + unary operands: 10 sqrt as sqrt(10)
  + binary operands: 3 E 5 + as 3 + 5
  + Any no-operand operations, like π, should appear unadorned. For example, π
  + Variables (Required Task #1) should also appear unadorned. For example, x
  + Testing
    + 3 E 5 E 6 E 7 + * - should display as 3 - (5 * (6 + 7)) or 3 - 5 * (6 + 7)
    + 3 E 5 + sqrt should display as sqrt(3 + 5)
    + 3 sqrt sqrt should display as sqrt(sqrt(3))
    + 3 E 5 sqrt + should display as 3 + sqrt(5)
    + π r r * * should display as π * (r * r) or, even better, π * r * r
    + a a * b b * + sqrt would be, at best, sqrt(a * a + b * b)
    + 3 E 5 + 6 * is not 3 + 5 * 6, it is (3 + 5) * 6
  + Separate multiple things on stack with commas
    + 3 E 5 E as 5, 3
    + 3 E 5 + 6 E 7 * 9 sqrt would be “sqrt(9), 6 * 7, 3 + 5”
+ Add an Undo button to your calculator. 
  + Hitting Undo when the user is in the middle of typing should take back the last digit or decimal point pressed until doing so would clear the display entirely 
  + at which point it should show the result of running the brain’s current program in the display (and now the user is clearly not in the middle of typing, so take care of that). 
  + Hitting Undo when the user is not in the middle of typing should remove the top item from the program stack in the brain and update the user- interface.
  * This task can be implemented with 1 method in your Controller (of about 5-6 lines of code, assuming you’ve factored out the updating of your user-interface into a single method somewhere) and 1 method (with 1 line of code) in your Model. 
* The NSMutableArray method replaceObjectAtIndex:withObject: might be useful to you in this assignment. Note that you cannot call this method inside a for-in type of enumeration (since you don’t have the index in that case): you’d need a for loop that is iterating by index through the array.
* It is possible to implement runProgram:usingVariableValues: without modifying the method popOperandOffStack: at all.
* You will almost certainly want to use recursion to implement descriptionOfProgram: (just like we did to implement runProgram:). You might find it useful to write yourself a descriptionOfTopOfStack: method too (just like we wrote ourselves a popOperandOffStack: method to help us implement runProgram:). If you find recursion a challenge, think “simpler,” not “more complex.” Your descriptionOfTopOfStack: method should be less than 20 lines of code and will be very similar to popOperandOffStack:. The next hint will also help.
* One of the things your descriptionOfProgram: method is going to need to know is whether a given string on the stack is a two-operand operation, a single-operand operation, a no-operand operation or a variable (because it gives a different description for each of those kinds of things). Implementing some private helper method(s) to determine this is probably a good idea. You could implement such a method with a lot of if-thens, of course, but you might also think about whether NSSet (and its method containsObject:) might be helpful.
* You might find the private helper methods mentioned in Hint #4 useful in distinguishing between variables and operations in your other methods as well. It’s very likely that you’re going to want a + (BOOL)isOperation:(NSString *)operation method.
* It might be a good idea not to worry about extraneous parentheses in your descriptionOfProgram: output at first, then, when you have it working, go back and figure out how to suppress them in certain cases where you know they are going to be redundant. As you’re thinking about this, at least consider handling the case of the highest precedence operations in your CalculatorBrain where you clearly do not need parentheses. Also think about the need for parentheses inside parentheses when doing function notation (e.g. sqrt((5 + 3)) is ugly).
* 
