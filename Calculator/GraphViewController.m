//
//  GraphViewController.m
//  Calculator
//
//  Created by Rupert Rebentisch on 29.06.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"
#import "GraphView.h"

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
//    GraphView * gv = (GraphView*) self.view;
//    gv.caclulatorDelegate = self;
    
    UIPanGestureRecognizer *pangr =
    [[UIPanGestureRecognizer alloc] initWithTarget:self.view action:@selector(pan:)];
    [self.view addGestureRecognizer:pangr];
    
    UIPinchGestureRecognizer * pnchgr =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self.view action:@selector(pinch:)];
    [self.view addGestureRecognizer:pnchgr];
    
    UITapGestureRecognizer * trptapgr =
    [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(tripleTap:)];
    trptapgr.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:trptapgr];

    [[self navigationController] setNavigationBarHidden:NO];
    [self.descriptionOfProgram setText:[CalculatorBrain descriptionOfProgram:self.programToGraph]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GraphCalculatorProtocol

-(double)ValueOfGraphAt:(double)x withCalculator:(id)calculator{
    return x * x *0.025 -50;
}


@end
