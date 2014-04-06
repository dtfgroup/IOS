//
//  DetailedWeatherController.m
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

#import "DetailedWeatherController.h"
#import "ForecastTableCell.h"
#import "UIImageView+WebCache.h"


@implementation DetailedWeatherController

@synthesize textForecastMonth;
@synthesize textForecastWeekday;
@synthesize textForecastDayOfMonth;

@synthesize textForecastIcon;
@synthesize textForecastSum;
@synthesize ftTableView;

@synthesize locationManager;

#define CELL_LABEL_WIDTH 320
#define CELL_LABEL_MIN_HEIGHT 115
#define CELL_LABEL_PADDING 10

#define kSectionHeight 22


// #define WEATHERUNDERGROUND_API_KEY @"Your API Key Here"

#ifndef WEATHERUNDERGROUND_API_KEY
#error "Must define WeatherUnderground API key. Please visit http://www.wunderground.com/weather/api/ to signup"
#endif


- (void)reloadWeather:(NSNotification *)notification {
    
    NSMutableDictionary* placeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
    
    NSString *forecast = [NSString stringWithFormat:@"%@,%@", [placeData objectForKey:@"latitude"], [placeData objectForKey:@"longitude"]];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/alerts/q/%@.json", WEATHERUNDERGROUND_API_KEY, forecast]]];
    
    // NSLog(@"The Request %@", theRequest);
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
    } else {
        
        // NSLog (@"failed");
    }
}

- (void)savedLocation:(NSNotification *)notification {
    
    NSMutableDictionary* placeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
    
    NSString *forecast = [NSString stringWithFormat:@"%@,%@", [placeData objectForKey:@"latitude"], [placeData objectForKey:@"longitude"]];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/alerts/q/%@.json", WEATHERUNDERGROUND_API_KEY, forecast]]];
    
    // NSLog(@"The Request %@", theRequest);
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
    } else {
        
        // NSLog (@"failed");
    }
}

- (void)searchedLocation:(NSNotification *)notification {
    
    NSMutableDictionary* placeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
    
    NSString *forecast = [NSString stringWithFormat:@"%@", [placeData objectForKey:@"name"]];
    
    NSString *result0 = [forecast stringByReplacingOccurrencesOfString:@" - " withString:@"_"];
    
    NSString *result1 = [result0 stringByReplacingOccurrencesOfString:@", " withString:@"_"];
    
    NSString *cleanForecast = [result1 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/alerts/q/%@.json", WEATHERUNDERGROUND_API_KEY, cleanForecast]]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
    } else {
        
        // NSLog (@"failed");
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
    // NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    
    CLLocation *currLocation;
    
    currLocation = [locationManager location];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/alerts/q/%f,%f.json", WEATHERUNDERGROUND_API_KEY, currLocation.coordinate.latitude, currLocation.coordinate.longitude]]];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
        
    } else {
        
        // NSLog (@"failed");
    }
    
    [locationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
    
	[super viewDidLoad];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savedLocation:) name:@"savedLocation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchedLocation:) name:@"searchedLocation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWeather:) name:UIApplicationWillEnterForegroundNotification object:nil];

    // set default location if doesn't exist yet
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"place"] == nil) {
        
        if (nil == locationManager)
            locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        [locationManager startUpdatingLocation];
    }
    else
    {
        NSMutableDictionary* placeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
        
        NSString *forecast = [NSString stringWithFormat:@"%@,%@", [placeData objectForKey:@"latitude"], [placeData objectForKey:@"longitude"]];
        
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/alerts/q/%@.json", WEATHERUNDERGROUND_API_KEY, forecast]]];
        
        // NSLog(@"The Request %@", theRequest);
        
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if(theConnection){
            responseData = [[NSMutableData alloc] init];
        } else {
            
            // NSLog (@"failed");
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // NSLog  NSString *msg = [NSString stringWithFormat:@"Failed: %@", [error description]];
    // NSLog (@"%@",msg);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLocale *locale = [NSLocale currentLocale];
    _isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];

    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves  error:&myError];
    
    //Forecasts
    NSArray *forecast = [res objectForKey:@"forecast"];
    NSArray *simpleForecast = [forecast valueForKey:@"simpleforecast"];
    NSArray *forecastDay = [simpleForecast valueForKey:@"forecastday"];
    NSArray *fcDate = [forecastDay valueForKey:@"date"];
    //Forecasts
    
    // Automactic switch For F or C based on locale
    if (!self.isMetric) {
        
        NSArray *forecast = [res objectForKey:@"forecast"];
        
        NSArray *textForecast = [forecast valueForKey:@"txt_forecast"];
        NSArray *tfcDay = [textForecast valueForKey:@"forecastday"];
        
        self.textForecastMonth = [fcDate valueForKey:@"month"];
        self.textForecastWeekday = [tfcDay valueForKey:@"title"];
        self.textForecastDayOfMonth = [fcDate valueForKey:@"day"];
        
        self.textForecastIcon = [tfcDay valueForKey:@"icon"];
        self.textForecastSum = [tfcDay valueForKey:@"fcttext"];
        
        [ftTableView reloadData];
    }
    else
    {
        // NSLog(@"Celcius ON");
        
        NSArray *forecast = [res objectForKey:@"forecast"];
        
        NSArray *textForecast = [forecast valueForKey:@"txt_forecast"];
        NSArray *tfcDay = [textForecast valueForKey:@"forecastday"];
        
        self.textForecastMonth = [fcDate valueForKey:@"month"];
        self.textForecastWeekday = [tfcDay valueForKey:@"title"];
        self.textForecastDayOfMonth = [fcDate valueForKey:@"day"];
        
        self.textForecastIcon = [tfcDay valueForKey:@"icon"];
        self.textForecastSum = [tfcDay valueForKey:@"fcttext_metric"];
        
        [ftTableView reloadData];
    }
}


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *customView = [[UIView alloc] init];
    forecastHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    forecastHeaderLabel.backgroundColor = [UIColor clearColor];
    forecastHeaderLabel.opaque = YES;
    forecastHeaderLabel.textColor = [UIColor blackColor];
    
    forecastHeaderLabel.font = [UIFont boldSystemFontOfSize:13];
    forecastHeaderLabel.frame = CGRectMake(6.0, 0.0, 300, 22.0);
    
    forecastHeaderLabel.text = [self.textForecastWeekday objectAtIndex:section];
    
    [customView setBackgroundColor:[UIColor colorWithRed:245.0 / 255 green:245.0 / 255 blue:245.0 / 255 alpha:1.0]];
    
    [customView addSubview:forecastHeaderLabel];
    
    return  customView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"customCell";
    
    ForecastTableCell *cell = (ForecastTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ForecastTableCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (ForecastTableCell *)currentObject;
                break;
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([indexPath section] == 0)
    {
        cell.forecastTextView.text = [self.textForecastSum objectAtIndex:0];
        cell.forecastDateView.text = [NSString stringWithFormat:@"%@ / %@", [self.textForecastMonth objectAtIndex:0], [self.textForecastDayOfMonth objectAtIndex:0]];
        cell.forecastTextView.lineBreakMode = UILineBreakModeWordWrap;
        cell.forecastTextView.numberOfLines = 10;
        
        NSString *imageURL = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/%@.gif", [self.textForecastIcon objectAtIndex:0]];
        
        [cell.forecastImageview setImageWithURL:[NSURL URLWithString:imageURL]
                               placeholderImage:[UIImage imageNamed:@""]];
    }
    else if([indexPath section] == 1)
    {
        cell.forecastTextView.text = [self.textForecastSum objectAtIndex:1];
        cell.forecastDateView.text = [NSString stringWithFormat:@"%@ / %@", [self.textForecastMonth objectAtIndex:0], [self.textForecastDayOfMonth objectAtIndex:0]];
        cell.forecastTextView.lineBreakMode = UILineBreakModeWordWrap;
        cell.forecastTextView.numberOfLines = 10;
        
        NSString *imageURL = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/nt_%@.gif", [self.textForecastIcon objectAtIndex:1]];
        
        [cell.forecastImageview setImageWithURL:[NSURL URLWithString:imageURL]
                               placeholderImage:[UIImage imageNamed:@""]];
    }
    else if([indexPath section] == 2)
    {
        cell.forecastTextView.text = [self.textForecastSum objectAtIndex:2];
        cell.forecastDateView.text = [NSString stringWithFormat:@"%@ / %@", [self.textForecastMonth objectAtIndex:1], [self.textForecastDayOfMonth objectAtIndex:1]];
        cell.forecastTextView.lineBreakMode = UILineBreakModeWordWrap;
        cell.forecastTextView.numberOfLines = 10;
        
        NSString *imageURL = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/%@.gif", [self.textForecastIcon objectAtIndex:2]];
        
        [cell.forecastImageview setImageWithURL:[NSURL URLWithString:imageURL]
                               placeholderImage:[UIImage imageNamed:@""]];
    }
    else if([indexPath section] == 3)
    {
        cell.forecastTextView.text = [self.textForecastSum objectAtIndex:3];
        cell.forecastDateView.text = [NSString stringWithFormat:@"%@ / %@", [self.textForecastMonth objectAtIndex:1], [self.textForecastDayOfMonth objectAtIndex:1]];
        cell.forecastTextView.lineBreakMode = UILineBreakModeWordWrap;
        cell.forecastTextView.numberOfLines = 10;
        
        NSString *imageURL = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/nt_%@.gif", [self.textForecastIcon objectAtIndex:3]];
        
        [cell.forecastImageview setImageWithURL:[NSURL URLWithString:imageURL]
                               placeholderImage:[UIImage imageNamed:@""]];
    }
    else if([indexPath section] == 4)
    {
        cell.forecastTextView.text = [self.textForecastSum objectAtIndex:4];
        cell.forecastDateView.text = [NSString stringWithFormat:@"%@ / %@", [self.textForecastMonth objectAtIndex:2], [self.textForecastDayOfMonth objectAtIndex:2]];
        cell.forecastTextView.lineBreakMode = UILineBreakModeWordWrap;
        cell.forecastTextView.numberOfLines = 10;
        
        NSString *imageURL = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/%@.gif", [self.textForecastIcon objectAtIndex:4]];
        
        [cell.forecastImageview setImageWithURL:[NSURL URLWithString:imageURL]
                               placeholderImage:[UIImage imageNamed:@""]];
    }
    else if([indexPath section] == 5)
    {
        cell.forecastTextView.text = [self.textForecastSum objectAtIndex:5];
        cell.forecastDateView.text = [NSString stringWithFormat:@"%@ / %@", [self.textForecastMonth objectAtIndex:2], [self.textForecastDayOfMonth objectAtIndex:2]];
        cell.forecastTextView.lineBreakMode = UILineBreakModeWordWrap;
        cell.forecastTextView.numberOfLines = 10;
        
        NSString *imageURL = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/nt_%@.gif", [self.textForecastIcon objectAtIndex:5]];
        
        [cell.forecastImageview setImageWithURL:[NSURL URLWithString:imageURL]
                               placeholderImage:[UIImage imageNamed:@""]];
    }
    else if([indexPath section] == 6)
    {
        cell.forecastTextView.text = [self.textForecastSum objectAtIndex:6];
        cell.forecastDateView.text = [NSString stringWithFormat:@"%@ / %@", [self.textForecastMonth objectAtIndex:3], [self.textForecastDayOfMonth objectAtIndex:3]];
        cell.forecastTextView.lineBreakMode = UILineBreakModeWordWrap;
        cell.forecastTextView.numberOfLines = 10;
        
        NSString *imageURL = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/%@.gif", [self.textForecastIcon objectAtIndex:6]];
        
        [cell.forecastImageview setImageWithURL:[NSURL URLWithString:imageURL]
                               placeholderImage:[UIImage imageNamed:@""]];
    }
    else if([indexPath section] == 7)
    {
        cell.forecastTextView.text = [self.textForecastSum objectAtIndex:7];
        cell.forecastDateView.text = [NSString stringWithFormat:@"%@ / %@", [self.textForecastMonth objectAtIndex:3], [self.textForecastDayOfMonth objectAtIndex:3]];
        cell.forecastTextView.lineBreakMode = UILineBreakModeWordWrap;
        cell.forecastTextView.numberOfLines = 10;
        
        NSString *imageURL = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/nt_%@.gif", [self.textForecastIcon objectAtIndex:7]];
        
        [cell.forecastImageview setImageWithURL:[NSURL URLWithString:imageURL]
                               placeholderImage:[UIImage imageNamed:@""]];
    }
    else if([indexPath section] == 8)
    {
        cell.forecastTextView.text = [self.textForecastSum objectAtIndex:8];
        cell.forecastDateView.text = [NSString stringWithFormat:@"%@ / %@", [self.textForecastMonth objectAtIndex:4], [self.textForecastDayOfMonth objectAtIndex:4]];
        cell.forecastTextView.lineBreakMode = UILineBreakModeWordWrap;
        cell.forecastTextView.numberOfLines = 10;
        
        NSString *imageURL = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/k/%@.gif", [self.textForecastIcon objectAtIndex:8]];
        
        [cell.forecastImageview setImageWithURL:[NSURL URLWithString:imageURL]
                               placeholderImage:[UIImage imageNamed:@""]];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // NSLog(@"Classic iPhone/iPod Support");
            
            return 131;
        }
        if(result.height == 568)
        {
            // NSLog(@"iPhone 5 Support");
            
            return CELL_LABEL_MIN_HEIGHT;
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end