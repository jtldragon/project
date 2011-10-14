//
//  TimetableViewController.h
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectAppDelegate.h"
#import <LRResty/LRResty.h>
#import <SystemConfiguration/SystemConfiguration.h>

@protocol TimetableDelegate <NSObject>

-(void)performSearch:(NSDictionary *)params;

@end



@interface TimetableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,TimetableDelegate,LRRestyClientResponseDelegate> {
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIBarButtonItem *searchButton;
    IBOutlet UITableView *resultTable;
    projectAppDelegate *delegate;
    NSMutableArray *lectures;
    NSUInteger selectedIndex;
    IBOutlet UILabel *dateLabel;
    IBOutlet UIView *searchView;
    NSDate *date;
    BOOL availableNetwork;
    
    
}




@property(nonatomic,retain) IBOutlet UIDatePicker *datePicker;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *searchButton;
@property(nonatomic,retain) IBOutlet UITableView *resultTable;
@property(nonatomic,assign) BOOL isInSearchMode;
@property (nonatomic, retain) NSMutableArray *lectures;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic,retain)IBOutlet UILabel *dateLabel;
@property (nonatomic,retain)IBOutlet UIView *searchView;
@property (nonatomic,retain)NSDate *date;
@property (nonatomic ,retain)NSDateFormatter *outFormatter;
@property (nonatomic ,retain)NSDateFormatter *inFormatter;

-(void)search;
-(void)performSearch:(NSDictionary *)params;
-(void)parse:(NSDictionary *)dict;
-(IBAction)getNext:(id)sender;
-(IBAction)getPrevious:(id)sender;
//for internetconnectionstatus
- (void)reachabilityChanged:(NSNotification *)note;
- (BOOL)isDataSourceAvailable;

@end
