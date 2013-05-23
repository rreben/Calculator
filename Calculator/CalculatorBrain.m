//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Rupert Rebentisch on 07.03.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain(){
    NSString * waitingOperation;
    double waitingOperand;
}
@property (nonatomic, strong) NSMutableArray *operandStack;

@end



@implementation CalculatorBrain

@synthesize operandStack = _operandStack;
@synthesize memoryValue = _memoryValue;
@synthesize calculatingDegreesToRadians;

//-(BOOL) isCalculatingDegreesToRadians{  
//    return hasToTransforDegreesToRadians;
//}

-(id) init
{
    self = [super init];
    _operandStack = [[NSMutableArray alloc]init];
    return self;
}

-(void)pushOperand:(double)aDouble
{
    [self.operandStack addObject:[NSNumber numberWithDouble:aDouble]];
    operand = aDouble;
}

-(double)popOperand
{
    NSNumber * nextOperand = [self.operandStack lastObject];
    if (nextOperand)[self.operandStack removeLastObject];
    return [nextOperand doubleValue];
}

-(double)performOperation:(NSString*)operation{
    double result = 0;
    
    if([@"+" isEqual:operation])
    {
        result = [self popOperand] + [self popOperand];
        
    }else if([@"-" isEqual:operation]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    }else if([@"x" isEqual:operation])
    {
        result = [self popOperand] * [self popOperand];
    }else if([@"/" isEqual:operation]){
        double divisor = [self popOperand];
        if(divisor)
        {
                result = [self popOperand] / operand;
        }
    } else if([operation isEqualToString:@"PI"]){
        result = (double)M_PI;;
    } else if([operation isEqualToString:@"sqrt"]){
        // thus this is a single operator operation, execute immidiately
        result = sqrt([self popOperand]);
    }else if([operation isEqualToString:@"CHS"]){
        result = - operand;
    }else if([operation isEqualToString:@"1/x"]){
        result = 1/[self popOperand];
    }else if([operation isEqualToString:@"sin"]){
        double argument = [self popOperand];
        if (self.isCalculatingDegreesToRadians) argument = argument * 2 * (double)M_PI / 360.0;
        result = sin(argument);
    }else if([operation isEqualToString:@"cos"]){
        double argument = [self popOperand];
        if (self.isCalculatingDegreesToRadians) argument = argument * 2 * (double)M_PI / 360.0;
        result = cos(argument);
    }
    [self pushOperand:result];
    return result;
}

-(void)performClearCommand{
    [self.operandStack removeAllObjects];
}


@end
