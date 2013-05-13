//
//  ViewController.m
//  Calculator
//
//  Created by Rupert Rebentisch on 04.03.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    BOOL userIsInTheMiddleOfTypingANumber;
    BOOL userHasAlreadyPressedDecimalDelimeter;
}

@end

static NSString *CalculatorMemoryContext = @"com.convincingapps.calculator.calculatorMemory";
static NSString *CalculatorTrigonometryContext = @"com.convincingapps.calculator.caclculatorTrigonometryContext";


@implementation ViewController

@synthesize brain = _brain;

-(BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
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
        

        if ([[self userSettingUnitForCalculationTrigonometricFunctions] isEqualToString:@"degrees"])
            [_brain setTrigonometriyToDegrees];
        if ([[self userSettingUnitForCalculationTrigonometricFunctions] isEqualToString:@"radians"])
            [_brain setTrigonometriyToRadians];

        //        NSLog(@"%@",[self userSettingUnitForCalculationTrigonometricFunctions]);
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

-(IBAction)digitPressed:(UIButton *)sender{
    NSString * digit = [[sender titleLabel]text];
    if (userIsInTheMiddleOfTypingANumber){
        if ([digit isEqualToString:@"."] && !userHasAlreadyPressedDecimalDelimeter){
                [display setText:[[display text]stringByAppendingString:digit]];
                userHasAlreadyPressedDecimalDelimeter = YES;
        }else if  ([digit isEqualToString:@"."] && userHasAlreadyPressedDecimalDelimeter){
            // do nothing
        }else{
            [display setText:[[display text]stringByAppendingString:digit]];
        }
    }else{
        if ([digit isEqualToString:@"."] && !userHasAlreadyPressedDecimalDelimeter){
            // user presses . decimal delimeter as first digit, e.g. .35 should give 0.35
            [display setText:@"0"];
            [display setText:[[display text]stringByAppendingString:digit]];
            userHasAlreadyPressedDecimalDelimeter = YES;
        }else{
            [display setText:digit];
        }
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

-(void)resetEditingMode{
    userIsInTheMiddleOfTypingANumber = NO;
    userHasAlreadyPressedDecimalDelimeter = NO;    
}

-(void)pushOperandToBrain{
    [[self brain] setOperand:[[display text]doubleValue]];
    [self resetEditingMode];
}


-(IBAction)operationPressed:(UIButton *)sender{
    if(userIsInTheMiddleOfTypingANumber){
        [self pushOperandToBrain];
    }
    NSString * operation = [[sender titleLabel] text];
    double result = [[self brain] performOperation:operation];
    [display setText:[NSString stringWithFormat:@"%g",result]];
    [self pushOperandToBrain];
}

- (IBAction)commandPressed:(UIButton *)sender{
    NSString * command = [[sender titleLabel] text];
    if([@"CLX" isEqualToString:command]){
        [[self brain] performClearCommand];
        [self resetEditingMode];
        [display setText:[NSString stringWithFormat:@"%g",0.0]];
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
    }else if ([@"PI" isEqualToString:command]){
        // [brain returnPi] does not work when brain is not inititialized
        // in this case you would have to press pi for two times
        // [[self brain] returnPi] provides the necessary two calls in case of
        // late instantiation. It is better to initialize brain in the setup.
        [display setText:[NSString stringWithFormat:@"%g", [[self brain] returnPi]]];
        [self pushOperandToBrain];
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


-(NSString *)userSettingUnitForCalculationTrigonometricFunctions{
    NSString* value = [[NSUserDefaults standardUserDefaults] stringForKey:@"unit_for_calculation_triogonometric_functions"];
    if (!([@"degrees" isEqualToString:value] || [@"radians" isEqualToString:value])){
        value = @"degrees";
    }
    return value;
}


-(void)defaultsChanged:(NSNotification*)notification {
    if ([[self userSettingUnitForCalculationTrigonometricFunctions] isEqualToString:@"degrees"])
        [_brain setTrigonometriyToDegrees];
    if ([[self userSettingUnitForCalculationTrigonometricFunctions] isEqualToString:@"radians"])
        [_brain setTrigonometriyToRadians];
    NSLog(@"%@",[self userSettingUnitForCalculationTrigonometricFunctions]);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNotificationCenter* center =[NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(defaultsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
