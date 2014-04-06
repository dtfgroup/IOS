//
//  DetailThemeiPadController.m
//  mapper
//
//  Created by Tope on 12/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailThemeiPadController.h"
#import "AppDelegate.h"

@interface DetailThemeiPadController ()

@end

@implementation DetailThemeiPadController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tableViewModel.theme = [SCTheme themeWithPath:@"mapper-iPad-detail.sct"];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
