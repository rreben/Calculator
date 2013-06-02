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
    STAssertTrue([brain performOperation:@"+" usingVariableValues:nil] == 2.0, @"simple addition");
    
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
    STAssertTrue([brain performOperation:@"+" usingVariableValues:nil] == 13.0, @"simple addition");
    STAssertTrue([brain performOperation:@"x" usingVariableValues:nil] == 65.0, @"simple addition");
    STAssertTrue([brain performOperation:@"-" usingVariableValues:nil] == -62.0, @"simple addition");
    STAssertTrue([@"3 - 5 * (6 + 7)" isEqualToString:[brain descriptionOfProgram]], @"3 - 5 * (6 + 7)");
}


-(void)testGetRidOfSuperfluousOuterBrackets
{
    CalculatorBrain * brain;
    brain = [[CalculatorBrain alloc] init];
    STAssertTrue([@"3+5+6" isEqualToString:[[brain class] getRidOfSuperfluousOuterBrackets:@"(3+5+6)"]],@"clean strin");
    
}

- (void)testBracketsForUnaryOperators
{
    //+ 3 E 5 E 6 E 7 + * - sqrt should display as sqrt(3 - 5 * (6 + 7))
    CalculatorBrain * brain;
    brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:3.0];
    [brain pushOperand:5.0];
    [brain pushOperand:6.0];
    [brain pushOperand:7.0];
    STAssertTrue([brain performOperation:@"+" usingVariableValues:nil] == 13.0, @"simple addition");
    STAssertTrue([brain performOperation:@"x" usingVariableValues:nil] == 65.0, @"simple addition");
    STAssertTrue([brain performOperation:@"-" usingVariableValues:nil] == -62.0, @"simple addition");
    [brain performOperation:@"sqrt" usingVariableValues:nil];
    NSLog(@"%@",[brain descriptionOfProgram]);
    STAssertTrue([@"sqrt(3 - 5 * (6 + 7))" isEqualToString:[brain descriptionOfProgram]], @"sqrt(3 - 5 * (6 + 7))");
}

- (void)testConcatenationForUnaryOperators
{
    //3 sqrt sqrt should display as sqrt(sqrt(3))
    CalculatorBrain * brain;
    brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:3.0];
    [brain performOperation:@"sqrt" usingVariableValues:nil];
    [brain performOperation:@"sqrt" usingVariableValues:nil];
    STAssertTrue([@"sqrt(sqrt(3))" isEqualToString:[brain descriptionOfProgram]], @"sqrt(sqrt(3))");
}

- (void)testBracketsForUnaryOperatorsAndAddition
{
    // 3 E 5 sqrt + should display as 3 + sqrt(5)
    CalculatorBrain * brain;
    brain = [[CalculatorBrain alloc] init];
    [brain pushOperand:3.0];
    [brain pushOperand:5.0];
    [brain performOperation:@"sqrt" usingVariableValues:nil];
    [brain performOperation:@"+" usingVariableValues:nil];
    STAssertTrue([@"3 + sqrt(5)" isEqualToString:[brain descriptionOfProgram]], @"3 + sqrt(5)");
}

-(void)testUsingVariable
{
    CalculatorBrain * brain;
    NSDictionary * variableValues =[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithDouble:2.2],
                                                                        [NSNumber numberWithDouble:3.3], nil]
                                                               forKeys:[NSArray arrayWithObjects:@"r",@"foo",nil]];
    brain = [[CalculatorBrain alloc] init];
    STAssertTrue([[brain class] lookUpValueforVariable:@"r" InDictionary:variableValues]==2.2, @"r");
    [brain pushOperand:3.0];
    [brain pushVariable:@"r"];
    NSLog(@"%g",[brain performOperation:@"+" usingVariableValues:nil]);
    double result = [[brain class] runProgram:brain.program usingCalculation:NO usingVariableValues:variableValues];
    STAssertTrue(result == 5.2, @"3+r=5.2");
}

//+ π r r * * should display as π * (r * r) or, even better, π * r * r
//+ a a * b b * + sqrt would be, at best, sqrt(a * a + b * b)
//+ 3 E 5 + 6 * is not 3 + 5 * 6, it is (3 + 5) * 6
//+ Separate multiple things on stack with commas
//+ 3 E 5 E as 5, 3
//+ 3 E 5 + 6 E 7 * 9 sqrt would be “sqrt(9), 6 * 7, 3 + 5”


- (void)testThatMakesSureWeDontFinishTooFast
{
    // Trick from
    // http://stackoverflow.com/questions/12308297/some-of-my-unit-tests-tests-are-not-finishing-in-xcode-4-4/12386018#12386018
    // too prevent warning "all tests did not finish" from timing issues in xcode
    [NSThread sleepForTimeInterval:1.0];
}


@end
