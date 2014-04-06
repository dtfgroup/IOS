//
//  RecentsViewController.m
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

#import "RecentsViewController.h"
#import "LocationSearchController.h"
#import "UIViewController+MMDrawerController.h"
#import "Recents.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@implementation RecentsViewController

@synthesize myTableView, editBtn;


- (void)didPostRemoteNotification {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"savedLocation" object:nil];
}

- (IBAction)edit:(id)sender {
	
    if ([editBtn.title isEqualToString:@"Edit"]) {
        
        editBtn.style = UIBarButtonItemStyleDone;
        editBtn.title = @"Done";
        
        [self setEditing:YES animated:YES];
        
    } else {
        
        editBtn.style = UIBarButtonItemStyleBordered;
        editBtn.title = @"Edit";
        
        [self setEditing:NO animated:YES];
    }
}

- (IBAction)showSearch:(id)sender {
    
    // NSLog(@"Search Called");
    
    LocationSearchController *recentsController = [[LocationSearchController alloc] initWithNibName:@"SearchView" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:recentsController];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        [navController.navigationBar setTintColor: [UIColor colorWithRed:0.0 / 255 green:0.0 / 255 blue:0.0 / 255 alpha:1.0]];
    }
    else
    {
        
    }
    
    [self.mm_drawerController presentModalViewController:navController animated:YES];
}

- (void)closeDrawerWithDelay:(NSNotification *)notification {
    
    [self performSelector:@selector(closeDrawer) withObject:nil afterDelay:0.1];
}

- (void)closeDrawer {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    else
    {
    }

    [myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeDrawerWithDelay:) name:@"searchedLocation" object:nil];

    appDelegate = (WxKitAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appDelegate.recentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"RecentCell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
    
    //Get the object from the array.
	Recents *recentsObj = [appDelegate.recentsArray objectAtIndex:indexPath.row];
    
    //Set the recentPlace
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@, %@", recentsObj.recentName, recentsObj.recentState, recentsObj.recentCountry];
    
    //Set the recentCoords.
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", recentsObj.recentLatitude, recentsObj.recentLongitude];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Recents *recentsObj = [appDelegate.recentsArray objectAtIndex:indexPath.row];
    NSDictionary* placeData = [NSDictionary dictionaryWithObjectsAndKeys:
							   recentsObj.recentName, @"name",
							   recentsObj.recentState, @"state",
							   recentsObj.recentCountry, @"country",
                               recentsObj.recentLatitude, @"latitude",
                               recentsObj.recentLongitude, @"longitude",
                               nil];
    
    //NSLog(@"Recents PlaceData %@", placeData);
	
    [[NSUserDefaults standardUserDefaults] setObject:placeData forKey:@"place"];
    
    [self didPostRemoteNotification];
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		//Get the object to delete from the array.
		Recents *recentsObj = [appDelegate.recentsArray objectAtIndex:indexPath.row];
		
		[appDelegate removeRecent:recentsObj];
		
		//Delete the object from the table.
		[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
    
    if(editing == YES) 
    {
        // NSLog(@"Editing Enabled");
        
        [myTableView setEditing:YES animated:YES];

    } else {
        
        // NSLog(@"Editing Done");
        
        [myTableView setEditing:NO animated:YES];
    }
}

@end