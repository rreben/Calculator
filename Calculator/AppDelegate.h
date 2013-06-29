//
//  AppDelegate.h
//  Calculator
//
//  Created by Rupert Rebentisch on 04.03.13.
//  Copyright (c) 2013 Rupert Rebentisch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CalculatorViewController *viewController;

@end
