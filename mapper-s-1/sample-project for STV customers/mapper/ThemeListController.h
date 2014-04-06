//
//  ViewController.h
//  PodRadio
//
//  Created by Tope on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SensibleTableView/SensibleTableView.h"
#import <UIKit/UIKit.h>

@interface ThemeListController : SCViewController


@property (nonatomic, retain) NSMutableArray* models;

@property (nonatomic, strong) IBOutlet UIView *distanceBar;

@end
