//
//  ViewController.m
//  Calculator
//
//  Created by Rupert Rebentisch on 04.03.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"


@interface CalculatorViewController (){
    BOOL userIsInTheMiddleOfTypingANumber;
//    BOOL userHasAlreadyPressedDecimalDelimeter;
}

@end

static NSString *CalculatorMemoryContext = @"com.convincingapps.calculator.calculatorMemory";
static NSString *CalculatorTrigonometryContext = @"com.convincingapps.calculator.caclculatorTrigonometryContext";


@implementation CalculatorViewController

@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

-(BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)dealloc{
//    [brain removeObserver:self forKeyPath:@"memoryValue"];
//    [brain release]; // forbidden in new llvm
//    [super dealloc]; // forbidden in new llvm
}


-(CalculatorBrain *) brain{
    if(!_brain){
        _brain = [[CalculatorBrain alloc] init];
        // http://www.dribin.org/dave/blog/archives/2008/09/24/proper_kvo_usage/
        
        [_brain addObserver:self   // sag mir bescheid,
                 forKeyPath:@"memoryValue" // wenn sich bar ändert
                    options:NSKeyValueObservingOptionNew
                    context:&CalculatorMemoryContext];

        [_brain addObserver:self   // sag mir bescheid,
                 forKeyPath:@"calculatingDegreesToRadians" // wenn sich bar ändert
                    options:NSKeyValueObservingOptionNew
                    context:&CalculatorTrigonometryContext];
        

        [self toggleDegreesVsRadiansInBrain];
    }
    return _brain;
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if (context == &CalculatorMemoryContext && [keyPath isEqualToString:@"memoryValue"]) {
  //      [memoryDisplay setText:[NSString stringWithFormat:@"%g",[(NSNumber*) object doubleValue]]];
        NSLog(@"%g",[self.brain.memoryValue doubleValue]);
        if (self.brain.memoryValue){
            [memoryDisplay setText:[NSString stringWithFormat:@"%g",[self.brain.memoryValue doubleValue]]];
        }else{
            [memoryDisplay setText:@""];
        }
    }else if (context == &CalculatorTrigonometryContext && [keyPath isEqualToString:@"calculatingDegreesToRadians"]) {
            if (self.brain.isCalculatingDegreesToRadians){
                [trigonometryDisplay setText:@"DEG"];
            }else{
                [trigonometryDisplay setText:@"RAD"];
            }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(BOOL)isStringAlreadyContainingDecimalDelimeter:(NSString *)aString{
    NSRange range = [aString rangeOfString:@"."];
    if (range.location == NSNotFound) { return NO; }
    else {return YES;}
 
}

-(IBAction)digitPressed:(UIButton *)sender{
    NSString * digit = [[sender titleLabel]text];
    if (userIsInTheMiddleOfTypingANumber){
        if ([digit isEqualToString:@"."] && ![self isStringAlreadyContainingDecimalDelimeter:[display text]]){
                [display setText:[[display text]stringByAppendingString:digit]];
        }else if  ([digit isEqualToString:@"."] && [self isStringAlreadyContainingDecimalDelimeter:[display text]]){
            // do nothing
        }else{
            [display setText:[[display text]stringByAppendingString:digit]];
        }
    }else{
        if ([digit isEqualToString:@"."] && [self isStringAlreadyContainingDecimalDelimeter:[display text]]){
            // user presses . decimal delimeter as first digit, e.g. .35 should give 0.35
            [display setText:@"0"];
            [display setText:[[display text]stringByAppendingString:digit]];
        }else{
            [display setText:digit];
        }
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

-(void)resetEditingMode{
    userIsInTheMiddleOfTypingANumber = NO;
}

-(void)pushOperandToBrain{
    [[self brain] pushOperand:[[display text]doubleValue]];
    [self appendToCalculation:[display text]];
    [self resetEditingMode];
}

-(IBAction)enterPressed{
    NSLog(@"%@",@"enterPressed");
    [self.brain pushOperand:[display.text doubleValue]];
    [self appendToCalculation:[display text]];
    [self resetEditingMode];
}

-(IBAction)variableEntered:(UIButton *)sender;
{
    if(userIsInTheMiddleOfTypingANumber){
        [self pushOperandToBrain];
    }
    NSString * variable = [[sender titleLabel] text];
    [self.brain pushVariable:variable];
    [self appendToCalculation:variable];
}

-(IBAction)operationPressed:(UIButton *)sender{
    if(userIsInTheMiddleOfTypingANumber){
        [self pushOperandToBrain];
    }
    NSString * operation = [[sender titleLabel] text];
    [self appendToCalculation:operation];
    double result = [[self brain] performOperation:operation usingVariableValues:self.testVariableValues];
    [self appendToCalculation:@"="];
    [self appendToCalculation:[NSString stringWithFormat:@"%g",result]];
    [display setText:[NSString stringWithFormat:@"%g",result]];
//    [self pushOperandToBrain];
}

- (IBAction)commandPressed:(UIButton *)sender{
    NSString * command = [[sender titleLabel] text];
    if([@"CLX" isEqualToString:command]){
        [[self brain] performClearCommand];
        [self resetEditingMode];
        [display setText:[NSString stringWithFormat:@"%g",0.0]];
        [inputStrip setText:@""];
        [inFixDescriptionOfProgram setText:@""];
    }else if ([@"RUN" isEqualToString:command]){
        [inFixDescriptionOfProgram setText:[self.brain descriptionOfProgram]];
    }else if ([@"STO" isEqualToString:command]){
        [self pushOperandToBrain];
        self.brain.memoryValue = [NSNumber numberWithDouble:[[display text]doubleValue]];
        NSLog(@"%g",[self.brain.memoryValue doubleValue]);
    }else if ([@"M+" isEqualToString:command]){
        [self pushOperandToBrain];
        double tmpValue = self.brain.memoryValue.doubleValue;
        tmpValue += [[display text]doubleValue];
        self.brain.memoryValue = [NSNumber numberWithDouble:tmpValue];
        NSLog(@"%g",[self.brain.memoryValue doubleValue]);
    }else if ([@"RCL" isEqualToString:command]){
        [display setText:[NSString stringWithFormat:@"%g", self.brain.memoryValue.doubleValue]];
        [self pushOperandToBrain];
        self.brain.memoryValue = [NSNumber numberWithDouble:[[display text]doubleValue]];
//    }else if ([@"PI" isEqualToString:command]){
//        // [brain returnPi] does not work when brain is not inititialized
//        // in this case you would have to press pi for two times
//        // [[self brain] returnPi] provides the necessary two calls in case of
//        // late instantiation. It is better to initialize brain in the setup.
//        [display setText:[NSString stringWithFormat:@"%g", [[self brain] returnPi]]];
//        [self pushOperandToBrain];
    }else if ([@"MC" isEqualToString:command]){
        self.brain.memoryValue = nil;
    }else if ([@"BS" isEqualToString:command]){
        NSString * displayString = [display text];
        if (userIsInTheMiddleOfTypingANumber) {
            if ([displayString length] > 1) {
                displayString = [displayString substringToIndex:[displayString length]-1];
            } else {
                displayString = @"0";
                [self resetEditingMode];
            }
            [display setText:displayString];
        }
    }
}

-(NSString *)variablesUsed{
    NSString * returnString = @"";
    NSSet *set = [[self.brain class] variablesUsedInProgram:[self.brain program]];
    NSEnumerator *enumerator = [set objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) {
        NSString * variableName = value;
        double result = [[self.brain class] lookUpValueforVariable:variableName InDictionary:self.testVariableValues];
        NSLog(@"%@ = %g",value, result);
        returnString = [returnString stringByAppendingFormat:@"%@ = %g",variableName, result];
    }
    return returnString;
}

- (void)appendToCalculation:(NSString*) text {
    [inputStrip setText:[[inputStrip text] stringByAppendingString:[NSString stringWithFormat:@"%@ ", text]]];
}


-(NSString *)userSettingUnitForCalculationTrigonometricFunctions{
    NSString* value = [[NSUserDefaults standardUserDefaults] stringForKey:@"unit_for_calculation_triogonometric_functions"];
    if (!([@"degrees" isEqualToString:value] || [@"radians" isEqualToString:value])){
        value = @"degrees";
    }
    return value;
}

-(void) toggleDegreesVsRadiansInBrain{
    if ([[self userSettingUnitForCalculationTrigonometricFunctions] isEqualToString:@"degrees"])
        // dot notation important, this adds code for KVO
        self.brain.calculatingDegreesToRadians = YES;
    if ([[self userSettingUnitForCalculationTrigonometricFunctions] isEqualToString:@"radians"])
        self.brain.calculatingDegreesToRadians = NO;    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowGraph"]) {
        GraphViewController *gvc = segue.destinationViewController;
        gvc.programToGraph = self.brain.program;
    }
}

-(void)defaultsChanged:(NSNotification*)notification {
    [self toggleDegreesVsRadiansInBrain];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNotificationCenter* center =[NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(defaultsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    self.testVariableValues =[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithDouble:2.2],
                                                                        [NSNumber numberWithDouble:3.3], nil]
                                                               forKeys:[NSArray arrayWithObjects:@"r",@"foo",nil]];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
