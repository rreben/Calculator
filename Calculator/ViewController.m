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
}

@end

@implementation ViewController

-(CalculatorBrain *) brain{
    if(!brain) brain = [[CalculatorBrain alloc] init];
    return brain;
}
-(IBAction)digitPressed:(UIButton *)sender{
    NSString * digit = [[sender titleLabel]text];
    if (userIsInTheMiddleOfTypingANumber){
        [display setText:[[display text]stringByAppendingString:digit]];
    }else{
        [display setText:digit];
        userIsInTheMiddleOfTypingANumber = YES;
    }
}
-(IBAction)operationPressed:(UIButton *)sender{
    if(userIsInTheMiddleOfTypingANumber){
        [[self brain] setOperand:[[display text]doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    NSString * operation = [[sender titleLabel] text];
    double result = [[self brain] performOperation:operation];
    [display setText:[NSString stringWithFormat:@"%g",result]];
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
