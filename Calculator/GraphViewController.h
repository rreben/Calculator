//
//  GraphViewController.h
//  Calculator
//
//  Created by Rupert Rebentisch on 29.06.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *descriptionOfProgram;
@property (nonatomic, strong) id programToGraph; // program for caclulator brain

@end
