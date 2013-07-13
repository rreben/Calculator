//
//  GraphView.m
//  Calculator
//
//  Created by Rupert Rebentisch on 29.06.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView (){
    CGPoint _origin;
    CGRect _graphRect;
    double _scale;
}

@end

@implementation GraphView
@synthesize caclulatorDelegate = _caclulatorDelegate;

-(void)setup{
    _origin = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2,
                          self.bounds.origin.y + self.bounds.size.height / 2);
    _graphRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                            self.bounds.size.width, self.bounds.size.height);
    _scale = 1.0;
    
}

// important when started from story board
- (void)awakeFromNib { [self setup]; }

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
    }
    [self setup];
    return self;
}

-(double)abszisVaulueOfPoint:(int)xPoint inRectangle:(CGRect)rectangle withOrigin:(CGPoint)origin scale:(double)scale{
    double x;
    if (xPoint <0){xPoint=0;}
    if (xPoint>rectangle.size.width){xPoint=rectangle.size.width;}
    x = (xPoint - origin.x)/scale;
    return x;
}

-(int)ordinatePointOfYValue:(double)y inRectangle:(CGRect)rectangle withOrigin:(CGPoint)origin scale:(double)scale{
    int yPoint = 0;
    yPoint = rectangle.size.height - scale * y - (rectangle.size.height - origin.y);
    return yPoint;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //[self setUp];
    [AxesDrawer drawAxesInRect:_graphRect originAtPoint:_origin scale:_scale];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    for (int i = 0; i<_graphRect.size.width; i++) {
        int xPoint = i;
        double xValue = [self abszisVaulueOfPoint:xPoint inRectangle:_graphRect withOrigin:_origin scale:_scale];
        double yValue = [self.caclulatorDelegate ValueOfGraphAt:xValue withCalculator:self];
        int yPoint = [self ordinatePointOfYValue:yValue inRectangle:_graphRect withOrigin:_origin scale:_scale];
        if (yPoint >=0 && yPoint <= _graphRect.size.height){
            CGContextAddLineToPoint(context, i,yPoint);            
        }
    }
    [[UIColor redColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
//    ￼￼￼CGContextDrawPath(context,kCGPathFillStroke);
}


@end
