//
//  GraphCalculatorProtocol.h
//  Calculator
//
//  Created by Rupert Rebentisch on 13.07.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GraphCalculatorProtocol <NSObject>
-(double)ValueOfGraphAt:(double)x withCalculator:(id)calculator;
@end
