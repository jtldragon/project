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
#import <SystemConfiguration/SystemConfiguration.h>
//#import "Reachability.h"

@protocol TimetableDelegate <NSObject>

-(void)performSearch:(NSDictionary *)params;

@end


@interface NotesViewController : UITableViewController <NSFetchedResultsControllerDelegate,LRRestyClientResponseDelegate,TimetableDelegate,UIAlertViewDelegate,LRRestyRequestDelegate> {
    NSMutableArray *lectures;
    NSUInteger selectedIndex;
    projectAppDelegate *delegate;
    //NSFetchedResultsController *_fetchResultsController;
    BOOL availableNetwork;
    //NetworkStatus internetConnectionStatus;
}
//@property NetworkStatus internetConnectionStatus;
@property (nonatomic, retain) NSArray *coursesArray;
@property (nonatomic, retain) NSMutableArray *lectures;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic ,retain)UINavigationController *notesNaviController;


-(IBAction)add;
-(void)performSearch;
-(NSMutableArray *)parse:(NSDictionary *)dict;
-(void)addLectures:(NSMutableArray *)lectureArray;
-(void)fetch;
-(BOOL)isDataSourceAvailable;
//for internetconnectionstatus
- (void)reachabilityChanged:(NSNotification *)note;
- (void)updateStatus;

@end
