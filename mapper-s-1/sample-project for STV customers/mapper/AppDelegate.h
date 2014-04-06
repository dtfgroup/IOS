//
//  AppDelegate.h
//  mapper
//
//  Created by Tope on 24/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorSwitcher.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(AppDelegate*)instance;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) ColorSwitcher *colorSwitcher;

- (void)customizeGlobalTheme;

@end
