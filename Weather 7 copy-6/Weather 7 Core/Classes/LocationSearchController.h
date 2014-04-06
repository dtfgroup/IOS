//
//  LocationSearchController.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>


@interface LocationSearchController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate> {
    
    NSArray           *items;
    NSMutableData     *responseData;
    
    UITableView       *tableView;
    UISearchBar       *searchBar;
    
    CLLocationManager *locationManager;
}

- (IBAction)getCurrentLocation:(id)sender;

@property (nonatomic, strong) NSArray                *items;
@property (nonatomic, strong) IBOutlet UITableView   *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar   *searchBar;
@property (nonatomic, strong) CLLocationManager      *locationManager;

@end
