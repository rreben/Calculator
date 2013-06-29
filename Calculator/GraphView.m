//
//  GraphView.m
//  Calculator
//
//  Created by Rupert Rebentisch on 29.06.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect labelRect = CGRectMake(20, 20, 50, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    [label setText:@"hello"];
    [self addSubview:label];
    CGRect graphRect = CGRectMake(5, 5, 200, 100);
    CGPoint origin = CGPointMake(100, 50);
    [AxesDrawer drawAxesInRect:graphRect originAtPoint:origin scale:1.0];
}


@end
