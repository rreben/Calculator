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
    }
    

    
//    if([operation isEqualToString:@"sqrt"]){
//        // thus this is a single operator operation, execute immidiately
//        operand = sqrt(operand);
//    }else if([operation isEqualToString:@"CHS"]){
//        operand = - operand;
//    }else if([operation isEqualToString:@"1/x"]){
//        operand = 1/operand;
//    }else if([operation isEqualToString:@"sin"]){
//        if (self.isCalculatingDegreesToRadians) operand = operand * 2 * [self returnPi] / 360.0;
//        operand = sin(operand);
//    }else if([operation isEqualToString:@"cos"]){
//        if (self.isCalculatingDegreesToRadians) operand = operand * 2 * [self returnPi] / 360.0;
//        operand = cos(operand);
//    }else{
//        // thus this is a double operator operation, do not execute immidiately
//        // suppose user presses 12 + 4 sqrt = result should be 14.
//        // so wait for execution till user presses another double operation (+ - *,...)
//        // or =. In the former case execute waiting operation and send actual operation to waiting
//        [self performWaitingOperation];
//        waitingOperand = operand;
//        waitingOperation = operation;
//    }
    [self pushOperand:result];
    return result;
}

-(double)returnPi{
    return (double)M_PI;
}

-(void)performWaitingOperation{
    if([@"+" isEqual:waitingOperation]){
        operand = waitingOperand + operand;
    }
    else if([@"-" isEqual:waitingOperation]){
        operand = waitingOperand - operand;
    }
    else if([@"x" isEqual:waitingOperation]){
        operand = waitingOperand * operand;
    }
    else if([@"/" isEqual:waitingOperation]){
        if(operand){
            operand = waitingOperand / operand;
        }
    }
}

-(void)performClearCommand{
    waitingOperand = 0;
    waitingOperation = nil;
    [self pushOperand:0.0];
}


@end
