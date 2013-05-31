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

- (void)testExample
{
    CalculatorBrain * _brain;

    _brain = [[CalculatorBrain alloc] init];
    [_brain pushOperand:1.0];
    [_brain pushOperand:1.0];
    STAssertTrue([_brain performOperation:@"+"] == 2.0, @"simple addition");
    
//    STFail(@"Unit tests are not implemented yet in CalculatorTests");
}

- (void)testThatMakesSureWeDontFinishTooFast
{
    // Trick from
    // http://stackoverflow.com/questions/12308297/some-of-my-unit-tests-tests-are-not-finishing-in-xcode-4-4/12386018#12386018
    // too prevent warning "all tests did not finish" from timing issues in xcode
    [NSThread sleepForTimeInterval:1.0];
}


@end
