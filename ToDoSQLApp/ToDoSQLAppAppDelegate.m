//
//  ToDoSQLAppAppDelegate.m
//  ToDoSQLApp
//
//  Created by Natalie Podrazik on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ToDoSQLAppAppDelegate.h"
#import "RootViewController.h"
#import "Todo.h"
#import "TodoVC.h"

#define DATABASE_NAME @"todo2.sqlite"



/* This is private and declared in the .M for a reason -- 
 "We declared it here because it's specific to this object so
 it does not need to be declared in the .h file" -- hmmm
 */
@interface ToDoSQLAppAppDelegate (Private)
-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)initializeDatabase;
@end





@implementation ToDoSQLAppAppDelegate


/*
    Creates a writeable copy of the bundled default database in the
    application Documents directory.
 */
-(void)createEditableCopyOfDatabaseIfNeeded {
   // test for existence...
    BOOL success;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * error;
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    
    NSString * writeableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
    success = [fileManager fileExistsAtPath:writeableDBPath];
    
    if (success) {
        return;
    }
    
    /* 
     The writeable database does not exist, so copy the default
     to the appropriate location
     */
    NSString * defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writeableDBPath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Failed to create writeable database file with message '%@'.\n", [error localizedDescription]);
    }
}

/*
    Open the database connection and retrieve the minimal information
    for all of its objects.
 */
-(void)initializeDatabase {
    NSMutableArray * todoArray = [[NSMutableArray alloc] init];
    self.todos = todoArray;
    [todoArray release];
    
    /* database is stored in app bundle */
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                        
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
    
    /* 
        open the database.  db was prepared outside this app!
     */
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // get the primary key for all books.
        const char * sql = "SELECT pk FROM todo";
        
        sqlite3_stmt * statement;
        
        /*
          preparing a statement compiles the SQL query into a byte-code
          program in the SQLite library.  The third parameter is either
         the length of the SQL string, or -1 to read up to the first
         null terminator.
         */
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // "step" through the results - once for each row
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // second parameter indicates the colum index onto the result set.
                int primaryKey = sqlite3_column_int(statement, 0);
                
                /*
                 Avoid the alloc-init-autorelease pattern here because
                 we are in a tight loop and autorelease is slightly more
                 expensive than release.  This design choice has nothing
                 to do with actual memory management -- at the end of 
                 this block of code, all the book objects allocated here
                 will be in memory regardless of whether we use auto-
                 release or release, because they are retained by the
                 books array.
                 */
                
                Todo * td = [[Todo alloc] initWithPrimaryKey:primaryKey database:database];
                [todos addObject:td];
                [td release];
            }
        } 
        
        /*
            "Finalize" the statement - release the resources
            associated with the statement.
         */
        sqlite3_finalize(statement);
    }
    else {
        /*
            Even though the open failed, call close to properly
            clean up the references.
         */
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        
        /*
            ** MORE ERROR HANDLING GOES HERE 
         */
                  
    }


}



/*
 @synthesize window=_window;
 @synthesize navigationController=_navigationController;
*/

@synthesize window, navigationController, todos;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    /* Here is where we set up the sql. */
    
    [self createEditableCopyOfDatabaseIfNeeded];
    [self initializeDatabase];
    
    // configure and show the window.
    //[window addSubview:[navigationController view]];
    TodoVC * todoVC = [[TodoVC alloc] initialize:self];
    [window addSubview:todoVC.view];
    [todoVC release];

    [window makeKeyAndVisible];
    
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    /*
     self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
     */
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    /*
     [_window release];
     [_navigationController release];
     */
    [window release];
    [navigationController release];
    [super dealloc];
}

@end
