//
//  LocationViewController.h
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//
#import "projectAppDelegate.h"
#import <UIKit/UIKit.h>
#import <LRResty/LRResty.h>

@protocol LocationDelegate <NSObject>

-(void)performSearch:(NSDictionary *)params;

@end

@interface LocationViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,LRRestyClientResponseDelegate,LocationDelegate>{
}

@property (nonatomic,retain)IBOutlet UITextField *textfield;
@property (nonatomic,retain)IBOutlet UISegmentedControl *segment;
@property (nonatomic,retain)IBOutlet UITableView *tableView;


@property (nonatomic,retain)NSMutableArray *locations;
@property (nonatomic,assign)NSUInteger selecedIndex;
//@property (nonatomic ,retain)UINavigationController *locNaviController;


-(IBAction)search;
-(IBAction)textFieldDoneEditing:(id)sender;
-(void)performSearch;
-(void)parse:(NSDictionary *)dict;



@end
