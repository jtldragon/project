//
//  TimetableViewController.m
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "TimetableViewController.h"
#import "TimetableResultViewController.h"
#import <YAJLiOS/YAJL.h>
#import "MBProgressHUD.h"
#import "Timetable.h"

@implementation TimetableViewController


@synthesize resultButton,datePicker,isInResultMode,lectures,selectedIndex,resultTable;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [resultButton release];
    [delegate release];
    [lectures release];
    [resultTable release];
    [datePicker release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isInResultMode=NO;
    self.title=@"Timetable";
    datePicker.date =[NSDate date];
    delegate=[[[UIApplication sharedApplication]delegate]retain];
    lectures=[[NSMutableArray alloc]init];
    self.resultTable.delegate=self;
    [self.resultTable setRowHeight:90];
    resultButton=[[UIBarButtonItem alloc]initWithTitle:@"Result" style:UIBarButtonSystemItemAction target:self action:@selector(search)];
    
    self.navigationItem.leftBarButtonItem=resultButton;
    
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.resultTable=nil;
    self.selectedIndex=NSUIntegerMax;
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - 
#pragma mark Toggle result View
//when user click the 'result' button, the table view flip out.
-(void)getResultView{
    UIView *fromView=self.view;
    UIView *toView=resultTable;
    
    if (self.isInResultMode) {
        fromView=resultTable;
        toView=self.view;
    }
    UIViewAnimationOptions animationOptions = self.isInResultMode ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    
    //[sender setEnabled:NO];
    
    [UIView transitionFromView:fromView toView:toView duration:0.4 options:animationOptions completion:^(BOOL finished) {
        self.isInResultMode = !self.isInResultMode;
        
        
    }];
    
    

}
-(void)search{
    if (isInResultMode) {
        [self getResultView];
    }
    else{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading lectures...";
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *selectDate = datePicker.date;
    NSString *dateString = [format stringFromDate:selectDate];
    NSLog( @"picks %@",dateString);
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setObject:delegate.studentNumber forKey:@"studentNumber"];
    [params setObject:dateString forKey:@"date"];
    [self performSearch:params];
    }
}
- (void)performSearch:(NSDictionary *)params
{
    NSString *urlString=@"";
    urlString=[NSString stringWithFormat:@"https://announcements.mobile-test.its.rmit.edu.au/studentwebservices/rest/timetable/studentId/%@/date/%@/",[params objectForKey:@"studentNumber"],[params objectForKey:@"date"]];
    
    
    
    NSLog(@"%@",urlString);
    NSDictionary *requestHeaders = [NSDictionary 
                                    dictionaryWithObject:@"application/json" forKey:@"Accept"];
    
    [[LRResty client]get:urlString parameters:nil headers:requestHeaders delegate:self];
    //return self.locations;
}

#pragma mark - LRRestyClientResponseDelegate

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response
{
    NSLog(@"response==%@",response);
    if ([response status]==200) {
        NSData *data = [response responseData];
        NSLog(@"%@",data);
        NSDictionary *jsonDictionary = [data yajl_JSON];
        NSLog(@"%@",jsonDictionary);
        [self parse:jsonDictionary];
    }
    else {
        //error message
        // issue visual alert
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Cannot connect to server!"
                              message:@"pls try later!"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}
-(void)parse:(NSDictionary *)dict {
    NSString *key=[[dict allKeys]objectAtIndex:0];
    NSLog( @"key==%@",key);
    
    if ([key isEqualToString:@"timetables"]) {
        NSArray *timetablesAray=[dict valueForKey:key];
        //NSLog( @"one lo==%@",locationsAray);
        [lectures removeAllObjects];
        [lectures addObjectsFromArray:timetablesAray]; 
        // NSLog(@"locations will be:%@",locations);
        
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.resultTable reloadData];
    [resultButton setTitle:self.isInResultMode ? @"Result":@"Search"];
    [self getResultView];
    
    
    
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([lectures count]==0) {
        NSLog(@"cell:%@",lectures);
        return 1;
    }
    else {
        return [lectures count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    selectedIndex=indexPath.row;
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    if ([lectures count]==0) {
        cell.textLabel.text=@"No course today";
        
    }
    else {
        NSDictionary *dict=[lectures objectAtIndex:selectedIndex];
        Timetable *timetable=[[Timetable alloc]initWithClass:[dict valueForKey:@"title"] startTime:[dict valueForKey:@"startTime"] endTime:[dict valueForKey:@"endTime"] location:[dict valueForKey:@"location"] campus:[dict valueForKey:@"campusCode"] type:[dict valueForKey:@"activityType"]];
        cell.textLabel.numberOfLines=2;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ \n                 %@",timetable.getTime,timetable.classTitle];
        cell.detailTextLabel.text=[timetable description];
        
    }
    
   
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  //  Location *location=[[Location alloc]initWithDictionary:[locations objectAtIndex:indexPath.row]];
    self.selectedIndex = indexPath.row;
    
    //[PropertyManager sharedPropertyManager].selectedProperty = property;
    // _locNaviController=delegate.locationNaviController;
    
   // LocationDetailViewController *detail = [[[LocationDetailViewController alloc]initWithLocation:location]autorelease];
   // [self.navigationController pushViewController:detail animated:YES];
    
    //[self.navigationController pushViewController:controller 
    //  animated:YES];
}


@end
