//
//  WxKitAppDelegate.h
//  Weather 7
//
//  Created by Christopher Coudriet on 10/15/2012.
//  Copyright Christopher Coudriet 2012. All rights reserved.
//
//  Permission is given to license this source code file, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that this source code cannot be redistributed or sold (in part or whole) and must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <UIKit/UIKit.h>

// Copy To Your Project

#import "Recents.h"

// End Copy To Your Project

@interface WxKitAppDelegate : NSObject <UIApplicationDelegate> {
    
    // Copy To Your Project
    
    UIViewController        *leftSideDrawerViewController;
    UIViewController        *centerViewController;
    UIViewController        *rightSideDrawerViewController;

    UINavigationController  *drawerNavigationController;
    NSMutableArray          *recentsArray;
    
    // End Copy To Your Project
    
    UIWindow                *window;
}

// Copy To Your Project

@property (nonatomic, strong) UIViewController     *centerViewController;
@property (nonatomic, strong) UIViewController     *leftSideDrawerViewController;
@property (nonatomic, strong) UIViewController     *rightSideDrawerViewController;
@property (nonatomic, strong) NSMutableArray       *recentsArray;

// End Copy To Your Project


@property (nonatomic, strong) IBOutlet UIWindow    *window;


// Copy To Your Project

- (NSString *)getDBPath;

- (void)createEditableCopyOfRecentsDatabaseIfNeeded;
- (void)addRecent:(Recents *)recentObj;
- (void)removeRecent:(Recents *)recentObj;

// End Copy To Your Project

@end

