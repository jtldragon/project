//
//  NotesViewController.h
//  project
//
//  Created by Yeshu Liu on 27/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//
#import "projectAppDelegate.h"
#import <UIKit/UIKit.h>
#import <LRResty/LRResty.h>

@protocol TimetableDelegate <NSObject>

-(void)performSearch:(NSDictionary *)params;

@end


@interface NotesViewController : UITableViewController <NSFetchedResultsControllerDelegate,LRRestyClientResponseDelegate,TimetableDelegate> {
    NSMutableArray *lectures;
    NSUInteger selectedIndex;
    projectAppDelegate *delegate;
    NSFetchedResultsController *_fetchResultsController;
}

@property (nonatomic, retain) NSMutableArray *lectures;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic ,retain)UINavigationController *notesNaviController;

- (IBAction)search;
-(IBAction)add;
-(void)performSearch;
-(void)parse:(NSDictionary *)dict;

@end
