//
//  TimetableResultViewController.h
//  project
//
//  Created by Yeshu Liu on 26/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectAppDelegate.h"

@interface TimetableResultViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    NSString *date;
    NSArray *tablesArray;
    NSUInteger selectedCellIndex;
    projectAppDelegate *appDelegate;
    
}

- (id)initCustomWithNibName:(NSString *)nibNameOrNil 
                     bundle:(NSBundle *)nibBundleOrNil
                       date:(NSString *)seletedDate;

-(void)search;

@property(nonatomic,retain)NSString *date;
@property(nonatomic,retain)NSArray *tablesArray;

@end
