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

@protocol TimetableDelegate <NSObject>

-(void)performSearch:(NSDictionary *)params;

@end



@interface TimetableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,TimetableDelegate,LRRestyClientResponseDelegate> {
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIBarButtonItem *resultButton;
    IBOutlet UITableView *resultTable;
    projectAppDelegate *delegate;
    NSMutableArray *lectures;
    NSUInteger selectedIndex;
    
    
}




@property(nonatomic,retain) IBOutlet UIDatePicker *datePicker;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *resultButton;
@property(nonatomic,retain) IBOutlet UITableView *resultTable;
@property(nonatomic,assign) BOOL isInResultMode;
@property (nonatomic, retain) NSMutableArray *lectures;
@property (nonatomic, assign) NSUInteger selectedIndex;

-(void)getResultView;
-(void)search;
-(IBAction)add;
-(void)performSearch;
-(void)parse:(NSDictionary *)dict;

@end
