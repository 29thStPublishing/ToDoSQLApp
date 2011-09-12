//
//  Todo.h
//  ToDoSQLApp
//
//  Created by Natalie Podrazik on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <sqlite3.h>

#import <Foundation/Foundation.h>


@interface Todo : NSObject {
    sqlite3 * database;
    NSInteger primaryKey;
    NSString * text;
    
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (nonatomic, retain) NSString * text;

-(id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;

@end
