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

@property (nonatomic, strong) NSNumber * memoryValue;
//@property (nonatomic) BOOL calculatingDegreesToRadians;
@property (nonatomic, getter = isCalculatingDegreesToRadians) BOOL calculatingDegreesToRadians;

-(void)setOperand:(double)aDouble;
-(double)performOperation:(NSString*)operation;
-(void)performClearCommand;
-(double)returnPi;

@end
