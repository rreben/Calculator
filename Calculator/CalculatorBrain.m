//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Rupert Rebentisch on 07.03.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain(){
}
@property (nonatomic, strong) NSMutableArray *programStack;

@end



@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize memoryValue = _memoryValue;
@synthesize calculatingDegreesToRadians;

//-(BOOL) isCalculatingDegreesToRadians{  
//    return hasToTransforDegreesToRadians;
//}

-(id) init
{
    self = [super init];
    _programStack = [[NSMutableArray alloc]init];
    return self;
}

+ (NSSet *)variablesUsedInProgram:(id)program{
    return nil;
}

-(NSString *)descriptionOfProgram{
    return [[self class] descriptionOfProgram:[self program]];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString * result = @"";
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    if (stack)
    {
        // first operation / operand without leading comma
        result = [result stringByAppendingFormat:@"%@",[[self class] popRHSItemOffStack:stack]];
        while ([stack count] > 0) {
            // all further operations / operands appended with a leading comma.
            result = [result stringByAppendingFormat:@", %@",[[self class] popRHSItemOffStack:stack]];
        }
    }
    return [[self class] getRidOfSuperfluousOuterBrackets:result];
}
+(NSString *)getRidOfSuperfluousOuterBrackets: (NSString*) inputString{
    if ([inputString characterAtIndex:0] == '('
        &&
        [inputString characterAtIndex:[inputString length]-1] == ')'){
        NSRange aRange;
        aRange.length = [inputString length]-2;
        aRange.location = 1;
        return [inputString substringWithRange:(NSRange)aRange];
    }
    return inputString;
}

+(NSString *)popRHSItemOffStack: (NSMutableArray *)stack{
    NSString * result = @"";

    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [(NSNumber*)topOfStack stringValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if([@"+" isEqual:operation])
        {
            // get order right. Important even for symmetric operators to have a description that can be understood easily
            NSString * secondOperand = [[self class] getRidOfSuperfluousOuterBrackets:[self popRHSItemOffStack:stack]];
            result = [result stringByAppendingFormat:@"(%@ %@ %@)",[[self class] getRidOfSuperfluousOuterBrackets:[self popRHSItemOffStack:stack]],@"+",secondOperand];
        }else if([@"-" isEqual:operation]){
            NSString * subtrahend = [self popRHSItemOffStack:stack];
            result = [result stringByAppendingFormat:@"(%@ %@ %@)",[[self class] getRidOfSuperfluousOuterBrackets:[self popRHSItemOffStack:stack]],@"-",subtrahend];
        }else if([@"x" isEqual:operation])
        {
            NSString * secondOperand = [self popRHSItemOffStack:stack];
            result = [result stringByAppendingFormat:@"%@ %@ %@",[self popRHSItemOffStack:stack],@"*",secondOperand];
        }else if([@"/" isEqual:operation]){
            NSString * divisor = [self popRHSItemOffStack:stack];
                result = [result stringByAppendingFormat:@"%@ %@ %@",[self popRHSItemOffStack:stack],@"/",divisor];
        } else if([operation isEqualToString:@"PI"]){
            result = [result stringByAppendingFormat:@"%g",(double)M_PI];
        } else if([operation isEqualToString:@"sqrt"]){
            // thus this is a single operator operation, execute immidiately
            result = [result stringByAppendingFormat:@"%@%@%@",@"sqrt(",[[self class] getRidOfSuperfluousOuterBrackets:[self popRHSItemOffStack:stack]],@")"];
        }else if([operation isEqualToString:@"CHS"]){
            result = [result stringByAppendingFormat:@"%@%@%@",@"-(",[[self class] getRidOfSuperfluousOuterBrackets:[self popRHSItemOffStack:stack]],@")"];
        }else if([operation isEqualToString:@"1/x"]){
            result = [result stringByAppendingFormat:@"%@%@%@",@"1/(",[[self class] getRidOfSuperfluousOuterBrackets:[self popRHSItemOffStack:stack]],@")"];
        }else if([operation isEqualToString:@"sin"]){
            result = [result stringByAppendingFormat:@"%@%@%@",@"sin(",[[self class] getRidOfSuperfluousOuterBrackets:[self popRHSItemOffStack:stack]],@")"];
        }else if([operation isEqualToString:@"cos"]){
            result = [result stringByAppendingFormat:@"%@%@%@",@"cos(",[[self class] getRidOfSuperfluousOuterBrackets:[self popRHSItemOffStack:stack]],@")"];
        }
    }

    
    return result;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingCalculation:self.isCalculatingDegreesToRadians usingVariableValues:nil];
}


+ (double)runProgram:(id)program usingCalculation: (BOOL)degreesToRadians  usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians];
}


+(double)popOperandOffProgramStack:(NSMutableArray *)stack usingCalculation:(BOOL)degreesToRadians{
    double result = 0;
    
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if([@"+" isEqual:operation])
        {
            result = [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians] + [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians];
        }else if([@"-" isEqual:operation]){
            double subtrahend = [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians];
            result = [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians] - subtrahend;
        }else if([@"x" isEqual:operation])
        {
            result = [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians] * [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians];
        }else if([@"/" isEqual:operation]){
            double divisor = [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians];
            if(divisor)
            {
                result = [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians] / divisor;
            }
        } else if([operation isEqualToString:@"PI"]){
        result = (double)M_PI;;
        } else if([operation isEqualToString:@"sqrt"]){
            // thus this is a single operator operation, execute immidiately
            result = sqrt([self popOperandOffProgramStack:stack usingCalculation:degreesToRadians]);
        }else if([operation isEqualToString:@"CHS"]){
            result = - [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians];
        }else if([operation isEqualToString:@"1/x"]){
            result = 1/[self popOperandOffProgramStack:stack usingCalculation:degreesToRadians];
        }else if([operation isEqualToString:@"sin"]){
            double argument = [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians];
            if (degreesToRadians) argument = argument * 2 * (double)M_PI / 360.0;
            result = sin(argument);
        }else if([operation isEqualToString:@"cos"]){
            double argument = [self popOperandOffProgramStack:stack usingCalculation:degreesToRadians];
            if (degreesToRadians) argument = argument * 2 * (double)M_PI / 360.0;
            result = cos(argument);
        }
    }
    return result;
}

-(void)performClearCommand{
    [self.programStack removeAllObjects];
}

- (id)program
{
    // copy returns immutable array
    return [self.programStack copy];
}

@end
