//
//  WeatherViewController.h
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
#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"


@interface WeatherViewController : UIViewController <CLLocationManagerDelegate> {
    
	//Current Weather
	IBOutlet UILabel      *cityLabel, *conditionsLabel, *windLabel, *humidityLabel; 
	IBOutlet UILabel	  *currentTempLabel;
	IBOutlet UIImageView  *conditionsImageView;
	
	//Current Day
	IBOutlet UILabel      *dayLabel, *conditionsLabel1;
	IBOutlet UILabel      *lowTempLabel, *highTempLabel;
	IBOutlet UIImageView  *conditionsImageView1;
	
	//Day 2
	IBOutlet UILabel      *dayLabel2, *conditionsLabel2;
	IBOutlet UILabel      *lowTempLabel2, *highTempLabel2;
	IBOutlet UIImageView  *conditionsImageView2;
	
	//Day 3
	IBOutlet UILabel      *dayLabel3, *conditionsLabel3;
	IBOutlet UILabel      *lowTempLabel3, *highTempLabel3;
	IBOutlet UIImageView  *conditionsImageView3;
	
	//Day 4
	IBOutlet UILabel      *dayLabel4, *conditionsLabel4;
	IBOutlet UILabel      *lowTempLabel4, *highTempLabel4;
	IBOutlet UIImageView  *conditionsImageView4;
		
    IBOutlet UIImageView             *tempBg;
    
    NSMutableData                    *responseData;
	CLLocationManager                *locationManager;
    
    NSArray                          *arraysContent;
    BOOL                             _isUpdating;
}

@property (assign) BOOL isMetric;

//Current Weather
@property (nonatomic, strong) IBOutlet UILabel       *cityLabel, *conditionsLabel, *windLabel, *humidityLabel;
@property (nonatomic, strong) IBOutlet UILabel       *currentTempLabel;
@property (nonatomic, strong) IBOutlet UIImageView	 *conditionsImageView;

//Current Day
@property (nonatomic, strong) IBOutlet UILabel      *dayLabel, *conditionsLabel1;
@property (nonatomic, strong) IBOutlet UILabel      *lowTempLabel, *highTempLabel;
@property (nonatomic, strong) IBOutlet UIImageView  *conditionsImageView1;

//Day 2
@property (nonatomic, strong) IBOutlet UILabel      *dayLabel2, *conditionsLabel2;
@property (nonatomic, strong) IBOutlet UILabel      *lowTempLabel2, *highTempLabel2;
@property (nonatomic, strong) IBOutlet UIImageView  *conditionsImageView2;

//Day 3
@property (nonatomic, strong) IBOutlet UILabel      *dayLabel3, *conditionsLabel3;
@property (nonatomic, strong) IBOutlet UILabel      *lowTempLabel3, *highTempLabel3;
@property (nonatomic, strong) IBOutlet UIImageView  *conditionsImageView3;

//Day 4
@property (nonatomic, strong) IBOutlet UILabel      *dayLabel4, *conditionsLabel4;
@property (nonatomic, strong) IBOutlet UILabel      *lowTempLabel4, *highTempLabel4;
@property (nonatomic, strong) IBOutlet UIImageView  *conditionsImageView4;

@property (nonatomic, strong) CLLocationManager	    *locationManager;
@property (nonatomic, strong) NSArray               *arraysContent;
@property (nonatomic, strong) UIImageView           *tempBg;

@end