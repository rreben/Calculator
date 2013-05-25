//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Rupert Rebentisch on 07.03.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject{
}

@property (nonatomic, strong) NSNumber * memoryValue;
@property (nonatomic, getter = isCalculatingDegreesToRadians) BOOL calculatingDegreesToRadians;
@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program usingCalculation: (BOOL)degreesToRadians;

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString*)operation;
-(void)performClearCommand;

@end
