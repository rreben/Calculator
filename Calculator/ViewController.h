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
    CalculatorBrain * brain;
}
-(IBAction)digitPressed:(UIButton *)sender;
-(IBAction)operationPressed:(UIButton *)sender;
@end
