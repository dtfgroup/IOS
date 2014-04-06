//
//  WxKitAppDelegate.m
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

#import "WxKitAppDelegate.h"

// Copy To Your Project

#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "WeatherViewController.h"
#import "RecentsViewController.h"
#import "DetailedWeatherController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
// End Copy To Your Project


@implementation WxKitAppDelegate

// Copy To Your Project

@synthesize recentsArray;

// End Copy To Your Project

@synthesize leftSideDrawerViewController, rightSideDrawerViewController, centerViewController, window;


#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Copy To Your Project
    
    // MMDrawerController
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                // NSLog(@"Classic iPhone/iPod Support");
                
                centerViewController = [[WeatherViewController alloc] initWithNibName:@"WeatherViewControllerSmall" bundle:nil];
            }
            if(result.height == 568)
            {
                // NSLog(@"iPhone 5 Support");
                
                centerViewController = [[WeatherViewController alloc] initWithNibName:@"WeatherViewControllerLarge" bundle:nil];
            }
        }

        leftSideDrawerViewController = [[RecentsViewController alloc] initWithNibName:@"RecentsView" bundle:nil];
        
        rightSideDrawerViewController = [[DetailedWeatherController alloc] initWithNibName:@"DetailedWeatherController" bundle:nil];
        
        drawerNavigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                // NSLog(@"Classic iPhone/iPod Support");
                
                centerViewController = [[WeatherViewController alloc] initWithNibName:@"WeatherViewControllerSmall" bundle:nil];
            }
            if(result.height == 568)
            {
                // NSLog(@"iPhone 5 Support");
                
                centerViewController = [[WeatherViewController alloc] initWithNibName:@"WeatherViewControllerLarge" bundle:nil];
            }
        }

        leftSideDrawerViewController = [[RecentsViewController alloc] initWithNibName:@"RecentsView_iOS6" bundle:nil];
        
        rightSideDrawerViewController = [[DetailedWeatherController alloc] initWithNibName:@"DetailedWeatherController_iOS6" bundle:nil];
    }
    
    drawerNavigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    
    [drawerNavigationController setNavigationBarHidden:YES];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:drawerNavigationController
                                            leftDrawerViewController:leftSideDrawerViewController
                                            rightDrawerViewController:rightSideDrawerViewController];
    
    [drawerController setMaximumLeftDrawerWidth:280.0];
    [drawerController setMaximumRightDrawerWidth:280.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:drawerController];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // MMDrawerController

    [self createEditableCopyOfRecentsDatabaseIfNeeded];
    
    // Initialize the Recents array.
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.recentsArray = tempArray;
    
    // Once the db is copied, get the initial data to display on the screen.
	[Recents getInitialDataToDisplay:[self getDBPath]];
    
    // End Copy To Your Project
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}


// Copy To Your Project

- (void)createEditableCopyOfRecentsDatabaseIfNeeded {
	
	// Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
        
        NSError	*error;
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Recents.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (NSString *)getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"Recents.sqlite"];
}

- (void)removeRecent:(Recents *)recentsObj {
	
	// Delete it from the database.
	[recentsObj deleteRecent];
	
	// Remove it from the array.
	[recentsArray removeObject:recentsObj];
}

- (void)addRecent:(Recents *)recentsObj {
	
	// Add it to the database.
	[recentsObj addRecent];
	
	// Add it to the Favorites array.
	[recentsArray addObject:recentsObj];
}

// End Copy To Your Project

@end