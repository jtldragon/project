//
//  NotesViewController.h
//  project
//
//  Created by Yeshu Liu on 27/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//
#import "projectAppDelegate.h"
#import <UIKit/UIKit.h>


@interface NotesViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSMutableArray *coursesArray;
    NSUInteger selectedCellIndex;
    projectAppDelegate *delegate;
    NSFetchedResultsController *_fetchResultsController;
}

@property (nonatomic, retain) NSMutableArray *coursesArray;
@property (nonatomic, assign) NSUInteger selectedCellIndex;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (IBAction)search;
-(IBAction)add;

@end
