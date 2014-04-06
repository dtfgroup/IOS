//
//  Recents.m
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

#import "Recents.h"
#import "WxKitAppDelegate.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;

@implementation Recents

@synthesize recentsID, recentName, recentState, recentCountry, recentLatitude, recentLongitude, isDirty, isDetailViewHydrated;


+ (void)getInitialDataToDisplay:(NSString *)dbPath {
	WxKitAppDelegate *appDelegate = (WxKitAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql = "select recentsID, recentName, recentState, recentCountry, recentLatitude, recentLongitude from recents";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				Recents *recentsObj = [[Recents alloc] initWithPrimaryKey:primaryKey];
				recentsObj.recentName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                recentsObj.recentState = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                recentsObj.recentCountry = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                recentsObj.recentLatitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
                recentsObj.recentLongitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
				
				recentsObj.isDirty = NO;
				
				[appDelegate.recentsArray addObject:recentsObj];
			}
		}
	}
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
}

+ (void)finalizeStatements {
	if(database) sqlite3_close(database);
	if(deleteStmt) sqlite3_finalize(deleteStmt);
	if(addStmt) sqlite3_finalize(addStmt);
}

- (id)initWithPrimaryKey:(NSInteger) pk {
	if (!(self = [super init])) return nil;
	recentsID = pk;
	
	isDetailViewHydrated = NO;
	
	return self;
}

- (void)deleteRecent {
	if(deleteStmt == nil) {
		const char *sql = "delete from recents where recentsID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, recentsID);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}

- (void)addRecent {
	if(addStmt == nil) {
		const char *sql = "insert into recents(recentName, recentState, recentCountry, recentLatitude, recentLongitude) Values(?, ?, ?, ?, ?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_text(addStmt, 1, [recentName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 2, [recentState UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 3, [recentCountry UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 4, [recentLatitude UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 5, [recentLongitude UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		recentsID = sqlite3_last_insert_rowid(database);
	
	//Reset the add statement.
	sqlite3_reset(addStmt);
}


@end