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


@implementation ViewController

-(BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)dealloc{
    [brain removeObserver:self forKeyPath:@"memoryValue"];
//    [brain release]; // forbidden in new llvm
//    [super dealloc]; // forbidden in new llvm
}


-(CalculatorBrain *) brain{
    if(!brain) brain = [[CalculatorBrain alloc] init];
    
    
// http://www.dribin.org/dave/blog/archives/2008/09/24/proper_kvo_usage/
    
    [brain addObserver:self   // sag mir bescheid,
            forKeyPath:@"memoryValue" // wenn sich bar ändert
               options:NSKeyValueObservingOptionNew
               context:&CalculatorMemoryContext];
    return brain;
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if (context == &CalculatorMemoryContext && [keyPath isEqualToString:@"memoryValue"]) {
  //      [memoryDisplay setText:[NSString stringWithFormat:@"%g",[(NSNumber*) object doubleValue]]];
        NSLog(@"%g",[brain.memoryValue doubleValue]);
        if (brain.memoryValue){
            [memoryDisplay setText:[NSString stringWithFormat:@"%g",[brain.memoryValue doubleValue]]];
        }else{
            [memoryDisplay setText:@""];
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

-(void)pushOperandToBrain{
    [[self brain] setOperand:[[display text]doubleValue]];
    userIsInTheMiddleOfTypingANumber = NO;
    userHasAlreadyPressedDecimalDelimeter = NO;
}


-(IBAction)operationPressed:(UIButton *)sender{
    if(userIsInTheMiddleOfTypingANumber){
        [self pushOperandToBrain];
    }
    NSString * operation = [[sender titleLabel] text];
    double result = [[self brain] performOperation:operation];
    [display setText:[NSString stringWithFormat:@"%g",result]];
}

- (IBAction)commandPressed:(UIButton *)sender{
    NSString * command = [[sender titleLabel] text];
    if([@"CLX" isEqualToString:command]){
        [[self brain] performClearCommand];
        userIsInTheMiddleOfTypingANumber = NO;
        userHasAlreadyPressedDecimalDelimeter = NO;
        [display setText:[NSString stringWithFormat:@"%g",0.0]];
    }else if ([@"STO" isEqualToString:command]){
        [self pushOperandToBrain];
        brain.memoryValue = [NSNumber numberWithDouble:[[display text]doubleValue]];
        NSLog(@"%g",[brain.memoryValue doubleValue]);
    }else if ([@"M+" isEqualToString:command]){
        [self pushOperandToBrain];
        double tmpValue = brain.memoryValue.doubleValue;
        tmpValue += [[display text]doubleValue];
        brain.memoryValue = [NSNumber numberWithDouble:tmpValue];
        NSLog(@"%g",[brain.memoryValue doubleValue]);
    }else if ([@"RCL" isEqualToString:command]){
        [display setText:[NSString stringWithFormat:@"%g", brain.memoryValue.doubleValue]];
        [self pushOperandToBrain];
        brain.memoryValue = [NSNumber numberWithDouble:[[display text]doubleValue]];
    }else if ([@"MC" isEqualToString:command]){
        brain.memoryValue = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
