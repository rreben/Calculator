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
+ input of decimal numbers
  + no leading 0 like 05.67
  + no leading . like .56 (should be 0.56)
  + no non valid numbers like 4.123.9.78
+ sin
+ cos
+ sqrt
+ pi as an operation 
  + pi as an operation not just entering pi in the display
  + pi enter 3 * (results 3*pi)
  + pi 3 * (results 3*pi)
  + pi enter 3 * + (should _not_ result in 4*pi)
+ input strip on top of display
  + user enters 6.52 5 + 2 * so this should be shown in the input strip
+ C button
  + clear input strip
  + clear operand stack
  + clear state of UI
  + 5 7 C 5 should result in 5 being shown.
+ hanlde 1/0 gracefully
+ supplement any operation with 0 if there are not enough operands
+ Backspace to correct numbers which have been typed in.
+ Add = to the input strip to mark results of computations
+ CHS
  + If user is in the middle of typing in a number then just change the sign of the string
  + If enter has been pressed then CHS should work as a unanry operator
* Hint: NSString *greeting = @"Hello There Joe, how are ya?";
       NSRange range = [greeting rangeOfString:@"Bob"];
       if (range.location == NSNotFound) { ... /* no Bob */ }
       

