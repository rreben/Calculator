//
//  GraphView.h
//  Calculator
//
//  Created by Rupert Rebentisch on 29.06.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphCalculatorProtocol.h"

@interface GraphView : UIView
@property(weak, nonatomic) IBOutlet id <GraphCalculatorProtocol> caclulatorDelegate; // it is an outlet to be able to connect
// the view to its delegate in xcode storyboard

//@property (strong, nonatomic) CGPoint origin;
@end
