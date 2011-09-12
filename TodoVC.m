//
//  TodoVC.m
//  ToDoSQLApp
//
//  Created by Natalie Podrazik on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TodoVC.h"
#import "ToDoSQLAppAppDelegate.h"
#import "Todo.h"

@implementation TodoVC

-(id)initialize:(ToDoSQLAppAppDelegate*)parentObj {
    self = [super init];
    
    if (self) {
        parent = parentObj;
        
        [self initializeView];
        
        [self showList];
    }
    
    return self;
    
}

-(void)initializeView {
    NSLog(@"[initializeView] setting bg color and size.\n");
 
    [self.view setFrame:CGRectMake(0, 0, 350, 490)];
    [self.view setBackgroundColor:[UIColor purpleColor]];
     
}

-(void) showList {
    UITextView * textBox = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, 350, 490)];
    
    NSLog(@"[showList] number of todos = %d\n", [[parent todos] count]);
    // loop over every item in the list and display it.
    
    textBox.text = @"Here is a list of items from a sqlite database (from the ToDo app shown on http://www.icodeblog.com/2008/08/19/iphone-programming-tutorial-creating-a-todo-list-using-sqlite-part-1/).\n\n";
    for (int i = 0; i < [[parent todos] count]; i++) {
        NSLog(@"[%d] %@\n", i, [[[parent todos] objectAtIndex:i] text]);
        
        textBox.text = [textBox.text stringByAppendingFormat:@"- %@\n", [[[parent todos] objectAtIndex:i] text]];
        
    }
    
    [textBox setBackgroundColor:[UIColor clearColor]];
    [textBox setTextColor:[UIColor whiteColor]];
    [self.view addSubview:textBox];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
