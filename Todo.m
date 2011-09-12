//
//  Todo.m
//  ToDoSQLApp
//
//  Created by Natalie Podrazik on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Todo.h"

/* 
 DECLARED STATIC FOR A REASON
 */
static sqlite3_stmt * init_statement = nil;



@implementation Todo

@synthesize primaryKey, text;


-(id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
    self = [super init];
    if (self) {
        primaryKey = pk;
        database = db;
        
        // compile the query for retrieving book data.  See: insertNewBookIntoDatabase: for more detail.
        
        if (init_statement == nil) {
            
            /*
             note the '?' at the end of the query. this is a parameter
             which can be replaced by a bound variable.  This is a great
             way to optimize because frequently-used queries can be 
             compiled once, then with each use, the new varaible
             values can be bound to placeholders.
             */
            
            const char * sql = "SELECT text FROM todo WHERE pk=?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert(0, @"ERROR: failed to prepare statement with messsage '%s'\n", sqlite3_errmsg(database));
            }
        }
        
        /*
         For this query, we bind the primary key to the first (and only)
         placeholder in the statement.  Note that the parameters are 
         numbered from 1, not from 0.
         */
        sqlite3_bind_int(init_statement, 1, primaryKey);
        if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.text = [NSString stringWithUTF8String:(char*)sqlite3_column_text(init_statement, 0)];
        }
        else {
            self.text = @"Nothing";
        }
        
        /* 
         Reset the statement for future usage.
         */
        sqlite3_reset(init_statement);
    }
    
    return self;
}


@end
