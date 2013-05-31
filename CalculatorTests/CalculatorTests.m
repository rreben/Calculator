//
//  CalculatorTests.m
//  CalculatorTests
//
//  Created by Rupert Rebentisch on 30.05.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import "CalculatorTests.h"

@implementation CalculatorTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testAddition
{
    CalculatorBrain * brain;

    brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:1.0];
    [brain pushOperand:1.0];
    STAssertTrue([brain performOperation:@"+"] == 2.0, @"simple addition");
    
}

- (void)testDescriptionMultiplyAndAdd
{
    //+ 3 E 5 E 6 E 7 + * - should display as 3 - (5 * (6 + 7)) or 3 - 5 * (6 + 7)
    CalculatorBrain * brain;
    brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:3.0];
    [brain pushOperand:5.0];
    [brain pushOperand:6.0];
    [brain pushOperand:7.0];
    STAssertTrue([brain performOperation:@"+"] == 13.0, @"simple addition");
    STAssertTrue([brain performOperation:@"x"] == 65.0, @"simple addition");
    STAssertTrue([brain performOperation:@"-"] == -62.0, @"simple addition");
    NSLog(@"%@",[brain descriptionOfProgram]);
}


-(void)testGetRidOfSuperfluousOuterBrackets
{
    CalculatorBrain * brain;
    brain = [[CalculatorBrain alloc] init];
    STAssertTrue([@"3+5+6" isEqualToString:[[brain class] getRidOfSuperfluousOuterBrackets:@"(3+5+6)"]],@"clean strin");
    
}


- (void)testThatMakesSureWeDontFinishTooFast
{
    // Trick from
    // http://stackoverflow.com/questions/12308297/some-of-my-unit-tests-tests-are-not-finishing-in-xcode-4-4/12386018#12386018
    // too prevent warning "all tests did not finish" from timing issues in xcode
    [NSThread sleepForTimeInterval:1.0];
}


@end
