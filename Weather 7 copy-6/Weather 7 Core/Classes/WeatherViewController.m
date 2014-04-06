//
//  WeatherViewController.m
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

#import "WeatherViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "SVProgressHUD.h"

@implementation WeatherViewController

//Current Weather
@synthesize cityLabel, conditionsLabel, windLabel, humidityLabel;
@synthesize currentTempLabel;
@synthesize conditionsImageView;

//Current Day
@synthesize dayLabel, conditionsLabel1;
@synthesize lowTempLabel, highTempLabel;
@synthesize conditionsImageView1;

//Day 2
@synthesize dayLabel2, conditionsLabel2;
@synthesize lowTempLabel2, highTempLabel2;
@synthesize conditionsImageView2;

//Day 3
@synthesize dayLabel3, conditionsLabel3;
@synthesize lowTempLabel3, highTempLabel3;
@synthesize conditionsImageView3;

//Day 4
@synthesize dayLabel4, conditionsLabel4;
@synthesize lowTempLabel4, highTempLabel4;
@synthesize conditionsImageView4;

@synthesize locationManager;
@synthesize arraysContent;
@synthesize tempBg;


// #define WEATHERUNDERGROUND_API_KEY @"Your API Key Here"

#ifndef WEATHERUNDERGROUND_API_KEY 
#error "Must define WeatherUnderground API key. Please visit http://www.wunderground.com/weather/api/ to signup"
#endif


- (void)reloadWeather:(NSNotification *)notification {
    
    NSMutableDictionary* placeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
    
    NSString *forecast = [NSString stringWithFormat:@"%@,%@", [placeData objectForKey:@"latitude"], [placeData objectForKey:@"longitude"]];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/q/%@.json", WEATHERUNDERGROUND_API_KEY, forecast]]];
    
    // NSLog(@"The Request %@", theRequest);
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
    } else {
        
        // NSLog (@"failed");
    }
    
    [SVProgressHUD showWithStatus:@"Updating Weather"];
    
    _isUpdating = YES;
}

- (void)savedLocation:(NSNotification *)notification {
    
    NSMutableDictionary* placeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
    
    NSString *forecast = [NSString stringWithFormat:@"%@,%@", [placeData objectForKey:@"latitude"], [placeData objectForKey:@"longitude"]];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/q/%@.json", WEATHERUNDERGROUND_API_KEY, forecast]]];
    
    // NSLog(@"The Request %@", theRequest);
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
    } else {
        
        // NSLog (@"failed");
    }
    
    [SVProgressHUD showWithStatus:@"Updating Weather"];
}

- (void)searchedLocation:(NSNotification *)notification {
    
    NSMutableDictionary* placeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
    
    NSString *forecast = [NSString stringWithFormat:@"%@", [placeData objectForKey:@"name"]];
    
    NSString *result0 = [forecast stringByReplacingOccurrencesOfString:@" - " withString:@"_"];
    
    NSString *result1 = [result0 stringByReplacingOccurrencesOfString:@", " withString:@"_"];
    
    NSString *cleanForecast = [result1 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/q/%@.json", WEATHERUNDERGROUND_API_KEY, cleanForecast]]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
    } else {
        
        // NSLog (@"failed");
    }
    
    [SVProgressHUD showWithStatus:@"Updating Weather"];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog (@"Location Did Fail With Error");
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
    // NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    
    CLLocation *currLocation;
    
    currLocation = [locationManager location];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/q/%f,%f.json", WEATHERUNDERGROUND_API_KEY, currLocation.coordinate.latitude, currLocation.coordinate.longitude]]];
        
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWeather:) name:@"reloadWeather" object:nil];
    
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
        
        [SVProgressHUD showWithStatus:@"Updating Weather"];
    }
    else
    {
        NSMutableDictionary* placeData = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
        
        NSString *forecast = [NSString stringWithFormat:@"%@,%@", [placeData objectForKey:@"latitude"], [placeData objectForKey:@"longitude"]];
        
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/conditions/forecast/q/%@.json", WEATHERUNDERGROUND_API_KEY, forecast]]];
        
        // NSLog(@"The Request %@", theRequest);
        
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if(theConnection){
            responseData = [[NSMutableData alloc] init];
        } else {
            
            // NSLog (@"failed");
        }
        
        [SVProgressHUD showWithStatus:@"Updating Weather"];
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    NSLocale *currentUsersLocale = [NSLocale currentLocale];
    _isMetric = [[currentUsersLocale objectForKey:NSLocaleUsesMetricSystem] boolValue];
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
    
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves  error:&myError];
    
    //Geo Lookup
    NSArray *geoLook = [res objectForKey:@"location"];
    NSArray *city = [geoLook valueForKey:@"city"];
    NSArray *state = [geoLook valueForKey:@"state"];
    NSArray *country = [geoLook valueForKey:@"country_name"];
    NSArray *latitude = [geoLook valueForKey:@"lat"];
    NSArray *longitude = [geoLook valueForKey:@"lon"];
    
    if([geoLook count] == 0)
    {
        // NSLog(@"geoLook Error Reported");
        
        [SVProgressHUD showErrorWithStatus:@"Error Getting Weather"];
    
        return;
    }
    
    NSDictionary* placeData = [NSDictionary dictionaryWithObjectsAndKeys:
                               city, @"name",
                               state, @"state",
                               country, @"country",
                               latitude, @"latitude",
                               longitude, @"longitude",
                               nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:placeData forKey:@"place"];

    //Forecasts
    NSArray *fc = [res objectForKey:@"forecast"];
    NSArray *sf = [fc valueForKey:@"simpleforecast"];
    NSArray *fcday = [sf valueForKey:@"forecastday"];
    
    NSArray *fcdate = [fcday valueForKey:@"date"];
    NSArray *day = [fcdate valueForKey:@"weekday_short"];
    NSArray *fcCond = [fcday valueForKey:@"conditions"];
    // NSArray *fcicon = [fcday valueForKey:@"icon_url"];
    
    self.dayLabel.text  = [day objectAtIndex:0];
    self.dayLabel2.text = [day objectAtIndex:1];
    self.dayLabel3.text = [day objectAtIndex:2];
    self.dayLabel4.text = [day objectAtIndex:3];
    
    self.conditionsLabel1.text = [fcCond objectAtIndex:0];
    self.conditionsLabel2.text = [fcCond objectAtIndex:1];
    self.conditionsLabel3.text = [fcCond objectAtIndex:2];
    self.conditionsLabel4.text = [fcCond objectAtIndex:3];
    
    // Uncomment To Use Icons From Weather Underground
    /*NSURL *currentCondImage = [NSURL URLWithString:[NSString stringWithFormat:@"%@", curObsIcon]];
    self.conditionsImageView.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:currentCondImage]] retain];

    NSURL *forecatCondImage1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [fcicon objectAtIndex:0]]];
    self.conditionsImageView1.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:forecatCondImage1]] retain];
    
    NSURL *forecatCondImage2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [fcicon objectAtIndex:1]]];
    self.conditionsImageView2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:forecatCondImage2]];
   
    NSURL *forecatCondImage3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [fcicon objectAtIndex:2]]];
    self.conditionsImageView3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:forecatCondImage3]];
    
    NSURL *forecatCondImage4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [fcicon objectAtIndex:3]]];
    self.conditionsImageView4.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:forecatCondImage4]] retain];*/
    
    //Forecasts
    
    //Current Conditions
    NSArray *curObs = [res objectForKey:@"current_observation"];
    NSArray *curLoc = [curObs valueForKey:@"display_location"];
    NSArray *location = [curLoc valueForKey:@"full"];
    NSArray *windDir = [curObs valueForKey:@"wind_dir"];
    NSArray *windMph = [curObs valueForKey:@"wind_mph"];
    NSArray *windGustMph = [curObs valueForKey:@"wind_gust_mph"];
    NSArray *windKph = [curObs valueForKey:@"wind_kph"];
    NSArray *windGustKph = [curObs valueForKey:@"wind_gust_kph"];
    NSArray *humidity = [curObs valueForKey:@"relative_humidity"];
    NSArray *conditions = [curObs valueForKey:@"weather"];
    NSArray *curObsIcon = [curObs valueForKey:@"icon_url"];
    
    NSString *obsIcon = [NSString stringWithFormat:@"%@", curObsIcon];
    
    self.cityLabel.text = [NSString stringWithFormat:@"%@", location];
    self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@", humidity];
    self.conditionsLabel.text = [NSString stringWithFormat:@"%@", conditions];
    //Current Conditions
    
    NSString *getFeelTempF = [NSString stringWithFormat:@"%@", [curObs valueForKey:@"feelslike_f"]];
    
    float feelTempF = [getFeelTempF doubleValue];
    
    
    if (feelTempF == -9999)
    {
        tempBg.image = [UIImage imageNamed:@"bgDf.png"];
        
        // NSLog(@"feelTempF is NULL");
    }
    else if(feelTempF <= 0)
    {
        tempBg.image = [UIImage imageNamed:@"bg1.png"];
        
        // NSLog(@"feelTempF is <= 0");
    }
    else if (feelTempF >= 1 && feelTempF <= 20)
    {
        tempBg.image = [UIImage imageNamed:@"bg2.png"];
        
        // NSLog(@"feelTempF is >= 1 && <= 20");
    }
    else if (feelTempF >= 21 && feelTempF <= 40)
    {
        tempBg.image = [UIImage imageNamed:@"bg3.png"];
        
        // NSLog(@"feelTempF is >= 21 && <= 40");
    }
    else if (feelTempF >= 41 && feelTempF <= 60)
    {
        tempBg.image = [UIImage imageNamed:@"bg4.png"];
        
        // NSLog(@"feelTempF is >= 41 && <= 60");
    }
    else if (feelTempF >= 61 && feelTempF <= 80)
    {
        tempBg.image = [UIImage imageNamed:@"bg5.png"];
        
        // NSLog(@"feelTempF is >= 61 && <= 80");
    }
    else if (feelTempF >= 81)
    {
        tempBg.image = [UIImage imageNamed:@"bg6.png"];
        
        // NSLog(@"feelTempF is >= 81");
    }

    // Automactic switch For F or C based on locale
    if (!self.isMetric) {
        
        NSString *getCurrentTempF = [NSString stringWithFormat:@"%@", [curObs valueForKey:@"temp_f"]];
        
        // NSLog(@"%@", getCurrentTempF);
        
        float currentTempF = [getCurrentTempF doubleValue];
        
        self.currentTempLabel.text = [NSString stringWithFormat:@"%1.f", currentTempF];
        
        NSArray *hTemp = [fcday valueForKey:@"high"];
        NSArray *hTempF = [hTemp valueForKey:@"fahrenheit"];
        
        NSArray *lTemp = [fcday valueForKey:@"low"];
        NSArray *lTempF = [lTemp valueForKey:@"fahrenheit"];
        
        self.highTempLabel.text  = [NSString stringWithFormat:@"%@°", [hTempF objectAtIndex:0]];
        self.highTempLabel2.text = [NSString stringWithFormat:@"%@°", [hTempF objectAtIndex:1]];
        self.highTempLabel3.text = [NSString stringWithFormat:@"%@°", [hTempF objectAtIndex:2]];
        self.highTempLabel4.text = [NSString stringWithFormat:@"%@°", [hTempF objectAtIndex:3]];
        
        self.lowTempLabel.text  = [NSString stringWithFormat:@"%@°", [lTempF objectAtIndex:0]];
        self.lowTempLabel2.text = [NSString stringWithFormat:@"%@°", [lTempF objectAtIndex:1]];
        self.lowTempLabel3.text = [NSString stringWithFormat:@"%@°", [lTempF objectAtIndex:2]];
        self.lowTempLabel4.text = [NSString stringWithFormat:@"%@°", [lTempF objectAtIndex:3]];
        
        NSString *windStrDir = [NSString stringWithFormat:@"%@", windDir];
        
        NSString *windStrMph = [NSString stringWithFormat:@"%@", windMph];
        
        NSString *windGustStrMph = [NSString stringWithFormat:@"%@", windGustMph];
        
        float windMph = [windStrMph doubleValue];
        
        float windGustMph = [windGustStrMph doubleValue];
        
        self.windLabel.text = [NSString stringWithFormat:@"Wind Speed: %@ %1.f G %1.f mph", windStrDir, windMph, windGustMph];
    }
    else
    {
        // NSLog(@"Celcius ON");
        
        NSString *getCurrentTempC = [NSString stringWithFormat:@"%@", [curObs valueForKey:@"temp_c"]];
        
        // NSLog(@"%@", getCurrentTempC);
        
        float currentTempC = [getCurrentTempC doubleValue];
        
        self.currentTempLabel.text = [NSString stringWithFormat:@"%1.f", currentTempC];
        
        NSArray *hTemp = [fcday valueForKey:@"high"];
        NSArray *hTempC = [hTemp valueForKey:@"celsius"];
        
        NSArray *lTemp = [fcday valueForKey:@"low"];
        NSArray *lTempC = [lTemp valueForKey:@"celsius"];
        
        self.highTempLabel.text  = [NSString stringWithFormat:@"%@°", [hTempC objectAtIndex:0]];
        self.highTempLabel2.text = [NSString stringWithFormat:@"%@°", [hTempC objectAtIndex:1]];
        self.highTempLabel3.text = [NSString stringWithFormat:@"%@°", [hTempC objectAtIndex:2]];
        self.highTempLabel4.text = [NSString stringWithFormat:@"%@°", [hTempC objectAtIndex:3]];
        
        self.lowTempLabel.text  = [NSString stringWithFormat:@"%@°", [lTempC objectAtIndex:0]];
        self.lowTempLabel2.text = [NSString stringWithFormat:@"%@°", [lTempC objectAtIndex:1]];
        self.lowTempLabel3.text = [NSString stringWithFormat:@"%@°", [lTempC objectAtIndex:2]];
        self.lowTempLabel4.text = [NSString stringWithFormat:@"%@°", [lTempC objectAtIndex:3]];
        
        NSString *windStrDir = [NSString stringWithFormat:@"%@", windDir];
        
        NSString *windStrKph = [NSString stringWithFormat:@"%@", windKph];
        
        NSString *windGustStrKph = [NSString stringWithFormat:@"%@", windGustKph];
        
        float windKph = [windStrKph doubleValue];
        
        float windGustKph = [windGustStrKph doubleValue];
        
        self.windLabel.text = [NSString stringWithFormat:@"Wind Speed: %@ %1.f G %1.f km/h", windStrDir, windKph, windGustKph];
    }

    
    // Mapping Conditions From Weather Underground To Our Custom Icons
    if ([self.conditionsLabel.text isEqualToString: @""])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"naXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Drizzle"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"lightrainXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Light Drizzle"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"lightrainXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Rain"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Light Rain"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"lightrainXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Heavy Rain"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Snow"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"snowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Snow Grains"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"snowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Ice Crystals"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Ice Pellets"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Hail"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Mist"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Fog"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"fogXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Fog Patches"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"fogXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Smoke"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Volcanic Ash"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Widespread Dust"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Sand"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Haze"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"hazeXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Spray"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"lightrainXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Dust Whirls"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Sandstorm"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Low Drifting Snow"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"snowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Low Drifting Widespread Dust"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Low Drifting Sand"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Blowing Snow"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"snowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Blowing Widespread Dust"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Blowing Sand"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Rain Mist"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"lightrainXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Rain Showers"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Snow Showers"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"snowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Light Snow"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"snowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Snow Blowing Snow Mist"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"snowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Ice Pellet Showers"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Hail Showers"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Small Hail Showers"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Thunderstorm"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"scatteredthunderXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Thunderstorms and Rain"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"scatteredthunderXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Heavy Thunderstorms and Rain"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"scatteredthunderXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Light Thunderstorms and Rain"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"scatteredthunderXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Thunderstorms and Snow"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"scatteredthunderXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Thunderstorms and Ice Pellets"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"scatteredthunderXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Thunderstorms with Hail"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"scatteredthunderXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Thunderstorms with Small Hail"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"scatteredthunderXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Freezing Drizzle"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Light Freezing Fog"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Freezing Rain"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Freezing Fog"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Patches of Fog"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"fogXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Shallow Fog"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"fogXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Partial Fog"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"fogXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Overcast"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Clear"])
    {
        NSString *timeOfDay = @"nt_";
        
        NSRange rangeTime = [obsIcon rangeOfString: timeOfDay];
        
        if (rangeTime.location != NSNotFound)
        {
            self.conditionsImageView.image = [UIImage imageNamed:@"ntclearXL.png"];
        }
        else
        {
            self.conditionsImageView.image = [UIImage imageNamed:@"sunXL.png"];
        }
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Partly Cloudy"])
    {
        NSString *timeOfDay = @"nt_";
        
        NSRange rangeTime = [obsIcon rangeOfString: timeOfDay];
        
        if (rangeTime.location != NSNotFound)
        {
            self.conditionsImageView.image = [UIImage imageNamed:@"ntpartlysunnyXL.png"];
        }
        else
        {
            self.conditionsImageView.image = [UIImage imageNamed:@"partlysunnyXL.png"];
        }
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Mostly Cloudy"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Scattered Clouds"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"cloudyXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Small Hail"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"rainsnowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Squals"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"snowXL.png"];
    }
    else if ([self.conditionsLabel.text isEqualToString: @"Funnel Cloud"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"tornadoXL.png"];
    }
    if ([self.conditionsLabel.text isEqualToString: @"Unknown Precipitation"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"naXL.png"];
    }
    if ([self.conditionsLabel.text isEqualToString: @"Unknown"])
    {
        self.conditionsImageView.image = [UIImage imageNamed:@"naXL.png"];
    }


    if ([self.conditionsLabel1.text isEqualToString: @""])
    {
         self.conditionsImageView1.image = [UIImage imageNamed:@"na.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Chance of Flurries"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Chance of Rain"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Chance Rain"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Chance of Freezing Rain"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Chance of Sleet"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Chance of Snow"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Chance of Thunderstorms"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Chance of a Thunderstorm"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Clear"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"sun.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Cloudy"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Flurries"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Fog"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"fog.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Haze"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"haze.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Mostly Cloudy"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Mostly Sunny"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Partly Cloudy"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Partly Sunny"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Freezing Rain"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Ice Pellets"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Rain"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Rain Showers"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Sleet"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Snow"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Snow Showers"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Sunny"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"sun.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Thunderstorms"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Thunderstorm"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    if ([self.conditionsLabel1.text isEqualToString: @"Unknown"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"na.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Overcast"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel1.text isEqualToString: @"Scattered Clouds"])
    {
        self.conditionsImageView1.image = [UIImage imageNamed:@"cloudy.png"];
    }



    if ([self.conditionsLabel2.text isEqualToString: @""])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"na.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Chance of Flurries"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Chance of Rain"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Chance Rain"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Chance of Freezing Rain"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Chance of Sleet"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Chance of Snow"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Chance of Thunderstorms"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Chance of a Thunderstorm"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Clear"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"sun.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Cloudy"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Flurries"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Fog"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"fog.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Haze"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"haze.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Mostly Cloudy"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Mostly Sunny"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Partly Cloudy"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Partly Sunny"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Freezing Rain"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Ice Pellets"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Rain"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Rain Showers"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Sleet"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Snow"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Snow Showers"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Sunny"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"sun.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Thunderstorms"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Thunderstorm"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    if ([self.conditionsLabel2.text isEqualToString: @"Unknown"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"na.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Overcast"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel2.text isEqualToString: @"Scattered Clouds"])
    {
        self.conditionsImageView2.image = [UIImage imageNamed:@"cloudy.png"];
    }



    if ([self.conditionsLabel3.text isEqualToString: @""])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"na.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Chance of Flurries"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Chance of Rain"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Chance Rain"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Chance of Freezing Rain"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Chance of Sleet"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Chance of Snow"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Chance of Thunderstorms"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Chance of a Thunderstorm"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Clear"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"sun.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Cloudy"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Flurries"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Fog"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"fog.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Haze"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"haze.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Mostly Cloudy"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Mostly Sunny"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Partly Cloudy"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Partly Sunny"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Freezing Rain"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Ice Pellets"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Rain"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Rain Showers"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Sleet"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Snow"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Snow Showers"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Sunny"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"sun.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Thunderstorms"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Thunderstorm"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    if ([self.conditionsLabel3.text isEqualToString: @"Unknown"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"na.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Overcast"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel3.text isEqualToString: @"Scattered Clouds"])
    {
        self.conditionsImageView3.image = [UIImage imageNamed:@"cloudy.png"];
    }



    if ([self.conditionsLabel4.text isEqualToString: @""])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"na.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Chance of Flurries"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Chance of Rain"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Chance Rain"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Chance of Freezing Rain"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Chance of Sleet"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Chance of Snow"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Chance of Thunderstorms"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Chance of a Thunderstorm"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Clear"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"sun.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Cloudy"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Flurries"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Fog"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"fog.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Haze"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"haze.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Mostly Cloudy"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Mostly Sunny"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Partly Cloudy"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Partly Sunny"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"partlysunny.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Freezing Rain"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Ice Pellets"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Rain"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Rain Showers"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"rain.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Sleet"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"rainsnow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Snow"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Snow Showers"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"snow.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Sunny"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"sun.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Thunderstorms"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Thunderstorm"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"scatteredthunder.png"];
    }
    if ([self.conditionsLabel4.text isEqualToString: @"Unknown"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"na.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Overcast"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"cloudy.png"];
    }
    else if ([self.conditionsLabel4.text isEqualToString: @"Scattered Clouds"])
    {
        self.conditionsImageView4.image = [UIImage imageNamed:@"cloudy.png"];
    }
    
    [SVProgressHUD dismiss];
    
    
    WxKitAppDelegate *appDelegate = (WxKitAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *array = appDelegate.recentsArray;
    NSEnumerator *enumerator = [array objectEnumerator];
    Recents *recentsObj;
    while ((recentsObj = [enumerator nextObject]) != nil) {
        
        arraysContent = [NSArray arrayWithObjects:recentsObj.recentName, recentsObj.recentState, nil];
        
        // NSLog(@"%@", arraysContent);
        
        NSString *city = [NSString stringWithFormat:@"%@", [placeData objectForKey:@"name"]];
        NSString *state = [NSString stringWithFormat:@"%@", [placeData objectForKey:@"state"]];
        
        if([arraysContent containsObject:city] && [arraysContent containsObject:state] == YES)
        {
            // NSLog(@"City, State Duplicate Found");
            
            if(_isUpdating)
            {
                // NSLog(@"isUpdating");
                
                _isUpdating = NO;
            }
            else
            {
                // NSLog(@"is NOT Updating");
            }
            
            return;
        }
    }
    
    // NSLog(@"Adding Location");
    
    //Create a Recent Object.
    recentsObj = [[Recents alloc] initWithPrimaryKey:0];
    recentsObj.recentName = [NSString stringWithFormat:@"%@", [placeData objectForKey:@"name"]];
    recentsObj.recentState = [NSString stringWithFormat:@"%@", [placeData objectForKey:@"state"]];
    recentsObj.recentCountry = [NSString stringWithFormat:@"%@", [placeData objectForKey:@"country"]];
    recentsObj.recentLatitude = [NSString stringWithFormat:@"%@", [placeData objectForKey:@"latitude"]];
    recentsObj.recentLongitude = [NSString stringWithFormat:@"%@", [placeData objectForKey:@"longitude"]];
    
    recentsObj.isDirty = NO;
    recentsObj.isDetailViewHydrated = YES;
    
    //Add the object
    [appDelegate addRecent:recentsObj];
    
    _isUpdating = NO;
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