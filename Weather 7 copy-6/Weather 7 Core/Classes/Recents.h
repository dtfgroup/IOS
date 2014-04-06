//
//  Recents.h
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

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface Recents : NSObject {
	
    NSInteger recentsID;
	NSString  *recentName;
    NSString  *recentState;
    NSString  *recentCountry;
    NSString  *recentLatitude;
    NSString  *recentLongitude;
    
	//Internal variables to keep track of the state of the object.
	BOOL isDirty;
	BOOL isDetailViewHydrated;
}

@property (nonatomic, readonly) NSInteger recentsID;
@property (nonatomic, copy) NSString      *recentName;
@property (nonatomic, copy) NSString      *recentState;
@property (nonatomic, copy) NSString      *recentCountry;
@property (nonatomic, copy) NSString      *recentLatitude;
@property (nonatomic, copy) NSString      *recentLongitude;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) deleteRecent;
- (void) addRecent;

@end