//
//  ViewController.m
//  PodRadio
//
//  Created by Tope on 08/11/2011.
//  Copyright (c) 2011 AppDesignVault. All rights reserved.
//

#import "ThemeListController.h"
#import "ThemeListCell.h"
#import "DataLoader.h"
#import "Model.h"
#import "DetailThemeController.h"
#import "AppDelegate.h"
#import "Utils.h"

@interface ThemeListController ()

- (void)customizeTabbar;

@end



@implementation ThemeListController
@synthesize tabBar;
@synthesize tableListView, models, furthestLabel, nearestLabel;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    self.models = [DataLoader loadSampleData];
    
    [nearestLabel setText:@"0.43"];
    [furthestLabel setText:@"4.34"];
    
    [tableListView setDelegate:self];
    [tableListView setDataSource:self];
    
    [tableListView setBackgroundColor:[UIColor clearColor]];
    [tableListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.view setBackgroundColor:bgColor];
    
    [self customizeTabbar];
    [self.tabBar setSelectedItem:(self.tabBar.items)[0]];
}

- (void)viewDidUnload {
    [self setTabBar:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Visual stuff

- (void)customizeTabbar {
    UITabBarItem *tabItem1 = (self.tabBar.items)[0];
    UIImage* icon1 = [UIImage imageNamed:@"tabbar-icon1.png"];
    [tabItem1 setFinishedSelectedImage:icon1 withFinishedUnselectedImage:icon1];
    
    UITabBarItem *tabItem2 = (self.tabBar.items)[1];
    UIImage* icon2 = [UIImage imageNamed:@"tabbar-icon2.png"];
    [tabItem2 setFinishedSelectedImage:icon2 withFinishedUnselectedImage:icon2];
    
    UITabBarItem *tabItem3 = (self.tabBar.items)[2];
    UIImage* icon3 = [UIImage imageNamed:@"tabbar-icon3.png"];
    [tabItem3 setFinishedSelectedImage:icon3 withFinishedUnselectedImage:icon3];
    
    UITabBarItem *tabItem4 = (self.tabBar.items)[3];
    UIImage* icon4 = [UIImage imageNamed:@"tabbar-icon4.png"];
    [tabItem4 setFinishedSelectedImage:icon4 withFinishedUnselectedImage:icon4];
}


#pragma mark - Table View datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ThemeListCell";

    ThemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    Model* model = models[indexPath.row];
    
    [cell.titleLabel setText:model.title];
    [cell.locationLabel setText:model.location];
    [cell.paidTypeLabel setText:model.paidType];
    [cell.distanceMetricLabel setText:model.distanceMetric];
    [cell.distanceLabel setText:model.distance];
    
    [cell.paidTypeLabel setTextColor:[[AppDelegate instance].colorSwitcher textColor]];
    [cell.locationLabel setTextColor:[[AppDelegate instance].colorSwitcher textColor]];
    
    return cell;    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [models count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailThemeController* detail = segue.destinationViewController;
    
    Model* model = models[[[tableListView indexPathForSelectedRow] row]];    
    [detail setModel:model];    
}

@end
