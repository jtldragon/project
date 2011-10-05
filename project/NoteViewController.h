//
//  NoteViewController.h
//  project
//
//  Created by Yeshu Liu on 5/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectAppDelegate.h"


@interface NoteViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    projectAppDelegate *delegate;
}



@property (nonatomic, retain) NSArray *notesArray;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

-(void)fetch;
-(void)add;

@end