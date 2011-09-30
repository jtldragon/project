//
//  BookmarkViewController.h
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectAppDelegate.h"

@interface BookmarkViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    //IBOutlet UITableView *tableView;
    NSArray *coursesArray;
    NSUInteger selectedCellIndex;
    projectAppDelegate *delegate;
    NSFetchedResultsController *_fetchResultsController;
    IBOutlet UIBarButtonItem *addButton;

}


//@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray *coursesArray;
@property (nonatomic, assign) NSUInteger selectedCellIndex;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,assign) BOOL isInNewMode;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *addButton;

- (IBAction)search;
-(IBAction)getNewCourseView:(id)sender;

@end
