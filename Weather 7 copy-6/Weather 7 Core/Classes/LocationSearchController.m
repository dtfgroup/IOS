//
//  LocationSearchController.m
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

#import "LocationSearchController.h"
#import "RecentsViewController.h"
#import "SVProgressHUD.h"


@implementation LocationSearchController

@synthesize items;
@synthesize tableView;
@synthesize searchBar;
@synthesize locationManager;


// #define WEATHERUNDERGROUND_API_KEY @"Your API Key Here"

#ifndef WEATHERUNDERGROUND_API_KEY
#error "Must define WeatherUnderground API key. Please visit http://www.wunderground.com/weather/api/ to signup"
#endif


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = @"Location Search";
    }
	return self;
}

- (IBAction)getCurrentLocation:(id)sender {
    
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [locationManager startUpdatingLocation];
    
    [SVProgressHUD showWithStatus:@"Updating Location"];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [SVProgressHUD showErrorWithStatus:@"Location Failed"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Found" message:@"Your current location could not be determined. To get your current location you must allow Wx Kit Pro to access Location Services. To change this please go to: Settings / Privacy / Location Services and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	// NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    
    CLLocation *currLocation;
    
    currLocation = [locationManager location];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/q/%f,%f.json", WEATHERUNDERGROUND_API_KEY, currLocation.coordinate.latitude, currLocation.coordinate.longitude]]];
    
    // NSLog(@"%@", theRequest);
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
        
    } else {
        
        // NSLog (@"failed");
    }
    
    [locationManager stopUpdatingLocation];
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
    
    //Geo Lookup Current Location
    NSArray *geoLook = [res objectForKey:@"location"];
    
    // NSLog(@"%@", geoLook);
    
    //Geo Lookup With Search
    NSArray *autoAPI = [res objectForKey:@"RESULTS"];
    
    // NSLog(@"%@", autoAPI);
    
    if([geoLook count] > 0)
    {
        NSString* value = [NSString stringWithFormat:@"%@, %@",  [geoLook valueForKey:@"city"], [geoLook valueForKey:@"state"]];
        NSArray* parts = [value componentsSeparatedByString:@"/"];
        
        self.items = parts;
        
        // NSLog(@"%@", items);
        
        [tableView reloadData];
        
        [SVProgressHUD dismiss];
    }
    else if([autoAPI count] > 0)
    {
        self.items = [autoAPI valueForKey:@"name"];
        
        // NSLog(@"%@", items);
        
        [tableView reloadData];
        
        [SVProgressHUD dismiss];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"No Locations Found"];
    }
}

- (void)didPostRemoteNotification {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"searchedLocation" object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Locate"
                                              style:UIBarButtonItemStyleBordered
                                              target:self action:@selector(getCurrentLocation:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Close"
                                              style:UIBarButtonItemStyleBordered
                                              target:self action:@selector(dismissView)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [searchBar resignFirstResponder];
}

- (void)dismissView {
	
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* cellIdentifier = @"SearchCell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* placeData = [NSDictionary dictionaryWithObjectsAndKeys:
                              [self.items objectAtIndex:indexPath.row], @"name",
                              nil];
    
    // NSLog(@"Location Search %@", placeData);
    
    [[NSUserDefaults standardUserDefaults] setObject:placeData forKey:@"place"];
    
    [self didPostRemoteNotification];
    
    [self dismissView];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)asearchBar {
   searchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)asearchBar {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar {
    
    [searchBar resignFirstResponder];
    
    NSString *cleanSearch = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://autocomplete.wunderground.com/aq?query=%@&cities", cleanSearch]]];
    
    // NSLog(@"%@", theRequest);
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection){
        responseData = [[NSMutableData alloc] init];
    } else {
        
        // NSLog (@"failed");
    }
    
    [SVProgressHUD showWithStatus:@"Searching"];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)asearchBar {
}

@end