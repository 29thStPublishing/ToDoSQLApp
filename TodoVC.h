//
//  TodoVC.h
//  ToDoSQLApp
//
//  Created by Natalie Podrazik on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoSQLAppAppDelegate;

@interface TodoVC : UIViewController {
    ToDoSQLAppAppDelegate * parent;   
}

-(id)initialize:(ToDoSQLAppAppDelegate*)parentObj;
-(void)initializeView;

-(void) showList;



@end
