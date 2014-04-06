//
//  DetailedWeatherController.h
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


#import <CoreLocation/CoreLocation.h>
#import "MapKit/MapKit.h"
#import <UIKit/UIKit.h>


@interface DetailedWeatherController : UIViewController <CLLocationManagerDelegate> {
    
    IBOutlet UITableView  *ftTableView;
    UILabel               *forecastHeaderLabel;
    
    NSArray               *textForecastMonth;
    NSArray               *textForecastWeekday;
    NSArray               *textForecastDayOfMonth;
    
    NSArray               *textForecastIcon;
    NSArray               *textForecastSum;

    NSMutableData         *responseData;
	CLLocationManager     *locationManager;
}

@property (assign) BOOL isMetric;

@property (nonatomic, retain) UITableView  *ftTableView;

@property (nonatomic, retain) NSArray      *textForecastMonth;
@property (nonatomic, retain) NSArray      *textForecastWeekday;
@property (nonatomic, retain) NSArray      *textForecastDayOfMonth;

@property (nonatomic, retain) NSArray      *textForecastIcon;
@property (nonatomic, retain) NSArray      *textForecastSum;

@property (nonatomic, retain) CLLocationManager		*locationManager;

@end