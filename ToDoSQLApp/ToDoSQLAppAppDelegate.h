//
//  ToDoSQLAppAppDelegate.h
//  ToDoSQLApp
//
//  Created by Natalie Podrazik on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ToDoSQLAppAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow * window;
    IBOutlet UINavigationController * navigationController;
    
    sqlite3 * database;
    NSMutableArray * todos;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray * todos;



@end
