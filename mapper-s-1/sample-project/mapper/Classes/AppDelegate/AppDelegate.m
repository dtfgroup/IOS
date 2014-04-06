//
//  AppDelegate.m
//  mapper
//
//  Created by Tope on 24/01/2012.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Utils.h"

@implementation AppDelegate

@synthesize window = _window;

@synthesize colorSwitcher;

+(AppDelegate*)instance
{
    return [[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.colorSwitcher = [[ColorSwitcher alloc] initWithScheme:@"blue"];
    //self.colorSwitcher = [[ColorSwitcher alloc] initWithScheme:@"brown"];
    
    [self customizeGlobalTheme];
 
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    
    if (idiom == UIUserInterfaceIdiomPad) 
    {
        [self iPadInit];
    }
    
    if(![Utils isVersion6AndBelow]){
        
        self.window.rootViewController.view.tintColor = [UIColor whiteColor];
    }
    // Override point for customization after application launch.
    return YES;
}
	
- (void)customizeGlobalTheme
{
    UIImage *navBarImage = [colorSwitcher getImageWithName:@"menubar-7"];
    
    if([Utils isVersion6AndBelow]){
        navBarImage = [colorSwitcher getImageWithName:@"menubar"];
    }
    
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage 
                                       forBarMetrics:UIBarMetricsDefault];
    
    if([Utils isVersion6AndBelow]){
        UIImage *barButton = [[colorSwitcher getImageWithName:@"bar-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        
        [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal 
                                              barMetrics:UIBarMetricsDefault];
        
        UIImage *backButton = [[colorSwitcher getImageWithName:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,8)];

        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal 
                                                        barMetrics:UIBarMetricsDefault];
        
    }
    else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    UIImage *minImage = [colorSwitcher getImageWithName:@"slider-fill"];
    UIImage *maxImage = [UIImage imageNamed:@"slider-track.png"];
    UIImage *thumbImage = [UIImage imageNamed:@"slider-handle.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage 
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage 
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage 
                                forState:UIControlStateNormal];
    
    UIImage* tabBarBackground = [colorSwitcher getImageWithName:@"tabbar"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar-item.png"]];
}


-(void)iPadInit
{
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController; 
    
    splitViewController.delegate = [splitViewController.viewControllers lastObject];
    
    
    id<MasterViewControllerDelegate> delegate = [splitViewController.viewControllers lastObject];
    UINavigationController* nav = (splitViewController.viewControllers)[0];
    
    MasterViewController* master = (nav.viewControllers)[0];
    
    master.delegate = delegate;
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
