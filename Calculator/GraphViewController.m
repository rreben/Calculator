//
//  GraphViewController.m
//  Calculator
//
//  Created by Rupert Rebentisch on 29.06.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController ()

@end

@implementation GraphViewController
@synthesize programToGraph;
@synthesize descriptionOfProgram;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO];
    [self.descriptionOfProgram setText:[CalculatorBrain descriptionOfProgram:self.programToGraph]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
