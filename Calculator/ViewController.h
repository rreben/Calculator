//
//  ViewController.h
//  Calculator
//
//  Created by Rupert Rebentisch on 04.03.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface ViewController : UIViewController{
    IBOutlet UILabel *display;
    IBOutlet UILabel *memoryDisplay;
    IBOutlet UILabel *trigonometryDisplay;
    IBOutlet UILabel *inputStrip;
    IBOutlet UILabel *inFixDescriptionOfProgram;
    CalculatorBrain * _brain;
}

@property (nonatomic,strong) CalculatorBrain * brain;
@property (nonatomic,strong) NSDictionary * testVariableValues;

-(IBAction)enterPressed;
-(IBAction)digitPressed:(UIButton *)sender;
-(IBAction)operationPressed:(UIButton *)sender;
-(IBAction)variableEntered:(UIButton *)sender;
-(IBAction)commandPressed:(UIButton *)sender;

-(NSString *)variablesUsed;
@end
