//
//  ViewController.m
//  PodRadio
//
//  Created by Tope on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ThemeListController.h"
#import "ThemeListCell.h"
#import "DataLoader.h"
#import "Model.h"
#import "DetailThemeController.h"
#import "AppDelegate.h"


@implementation ThemeListController
@synthesize models, distanceBar;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    self.models = [NSMutableArray arrayWithArray:[DataLoader loadSampleData]];
    
    UILabel* nearest = (UILabel*)[self.distanceBar viewWithTag:1];
    UILabel* furthest = (UILabel*)[self.distanceBar viewWithTag:2];
    
    [nearest setText:@"0.43"];
    [furthest setText:@"4.65"];

    SCTheme *theme = [SCTheme themeWithPath:@"mapper-iPhone.sct"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"ATMs";
    [theme styleObject:titleLabel usingThemeStyle:@"navigationItemTitleLabel"];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    [theme styleObject:self.tableView usingThemeStyle:@"UITableView"];

    [self.tableViewModel setTheme:theme];
    
    SCClassDefinition *poiDef = [SCClassDefinition definitionWithClass:[Model class] propertyNames:[NSArray arrayWithObjects:@"title",@"location", @"zipCode", @"distance", @"distanceMetric", @"paidType", nil]];
    
    
    SCArrayOfObjectsSection *arraySection = [SCArrayOfObjectsSection sectionWithHeaderTitle:nil items:models itemsDefinition:poiDef];
    
    arraySection.sectionActions.cellForRowAtIndexPath = ^SCCustomCell*(SCArrayOfItemsSection *itemsSection, NSIndexPath *indexPath)
    {
        NSArray *propertiesArray = [NSArray arrayWithObjects:@"title",@"location", @"distance", @"distanceMetric", @"paidType", nil];
        NSArray *tagsArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
        
        SCControlCell *customCell = [SCControlCell cellWithText:nil boundObject:nil objectBindings:[NSDictionary dictionaryWithObjects:propertiesArray forKeys:tagsArray] nibName:@"ThemeCell"];
        
        
        
        return customCell;
    };
    
    arraySection.cellActions.willDisplay = ^(SCTableViewCell *cell, NSIndexPath *indexPath)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    };
    
    [self.tableViewModel addSection:arraySection];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
