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
@end



@implementation CalculatorBrain

@synthesize memoryValue = _memoryValue;

-(void)setOperand:(double)aDouble{
    operand = aDouble;
}
-(double)performOperation:(NSString*)operation{
    if([operation isEqualToString:@"sqrt"]){
        // thus this is a single operator operation, execute immidiately
        operand = sqrt(operand);
    }else if([operation isEqualToString:@"CHS"]){
        operand = - operand;
    }else if([operation isEqualToString:@"1/x"]){
        operand = 1/operand;
    }else if([operation isEqualToString:@"sin"]){
        operand = sin(operand);
    }else if([operation isEqualToString:@"cos"]){
        operand = cos(operand);
    }else{
        // thus this is a double operator operation, do not execute immidiately
        // suppose user presses 12 + 4 sqrt = result should be 14.
        // so wait for execution till user presses another double operation (+ - *,...)
        // or =. In the former case execute waiting operation and send actual operation to waiting
        [self performWaitingOperation];
        waitingOperand = operand;
        waitingOperation = operation;
    }
    return operand;
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
    [self setOperand:0.0];
}


@end
