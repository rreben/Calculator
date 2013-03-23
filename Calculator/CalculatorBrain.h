//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Rupert Rebentisch on 07.03.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject{
    double operand;
}

-(void)setOperand:(double)aDouble;
-(double)performOperation:(NSString*)operation;
-(double)performCommand:(NSString*)command;

@end
