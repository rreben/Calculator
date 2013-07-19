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


#define DEFAULT_SCALE 1.0

- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE; // don't allow zero scale
    } else {
        return _scale;
    }
}


- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

-(void)setup{
    _origin = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2,
                          self.bounds.origin.y + self.bounds.size.height / 2);
    _graphRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                            self.bounds.size.width, self.bounds.size.height);
    
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
    [AxesDrawer drawAxesInRect:_graphRect originAtPoint:_origin scale:[self scale]];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    for (int i = 0; i<_graphRect.size.width; i++) {
        int xPoint = i;
        double xValue = [self abszisVaulueOfPoint:xPoint inRectangle:_graphRect withOrigin:_origin scale:[self scale]];
        double yValue = [self.caclulatorDelegate ValueOfGraphAt:xValue withCalculator:self];
        int yPoint = [self ordinatePointOfYValue:yValue inRectangle:_graphRect withOrigin:_origin scale:[self scale]];
        if (yPoint >=0 && yPoint <= _graphRect.size.height){
            CGContextAddLineToPoint(context, i,yPoint);            
        }
    }
    [[UIColor redColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
//    ￼￼￼CGContextDrawPath(context,kCGPathFillStroke);
}

-(void)pinch:(UIPinchGestureRecognizer *)recognizer{
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) {
        self.scale *= recognizer.scale; // adjust our scale
        recognizer.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
    
}


- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) {
            CGPoint translation = [recognizer translationInView:self];
            // move something in myself (I’m a UIView) by translation.x and translation.y
            // for example, if I were a graph and my origin was set by an @property called origin
            _origin = CGPointMake(_origin.x+translation.x, _origin.y+translation.y);
            [self setNeedsDisplay];
            [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void)tripleTap:(UITapGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) {
        _origin = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}

@end
