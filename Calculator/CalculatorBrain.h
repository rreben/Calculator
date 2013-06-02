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
+ (double)runProgram:(id)program usingCalculation: (BOOL)degreesToRadians usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
+(NSString *)getRidOfSuperfluousOuterBrackets: (NSString*) inputString;
+(double)lookUpValueforVariable:(NSString*) variable InDictionary:(NSDictionary *)variableValues;

-(void)pushOperand:(double)operand;
-(void)pushVariable:(NSString *)variable;
-(double)performOperation:(NSString*)operation usingVariableValues:(NSDictionary *)variableValues;
-(void)performClearCommand;
-(NSString *)descriptionOfProgram;

@end
