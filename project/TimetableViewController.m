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


@synthesize searchButton,datePicker,isInSearchMode,lectures,selectedIndex,resultTable,dateLabel,searchView,date,outFormatter,inFormatter;



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
    [searchButton release];
    [delegate release];
    [lectures release];
    [resultTable release];
    [dateLabel release];
    [searchView release];
    [datePicker release];
    [date release];
    [outFormatter release];
    [inFormatter release];
    [super dealloc];
    
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
    //set the date formatter
    inFormatter = [[NSDateFormatter alloc] init];
    outFormatter = [[NSDateFormatter alloc] init];
    [inFormatter setDateFormat:@"yyyy-MM-dd"];
    [outFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    //hard code the date to 2010/03/02 
    //date=[NSDate date];
    date= [inFormatter dateFromString:@"2010-03-02"];

    self.isInSearchMode=NO;
    self.title=@"Timetable";
    datePicker.date =[NSDate date];
    
    dateLabel.text=[outFormatter stringFromDate:date];
    delegate=[[[UIApplication sharedApplication]delegate]retain];
    lectures=[[NSMutableArray alloc]init];

    self.resultTable.delegate=self;
    [self.resultTable setRowHeight:80];
    searchButton=[[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonSystemItemAction target:self action:@selector(toggleView)];
    
    self.navigationItem.leftBarButtonItem=searchButton;
    NSDictionary *params=[[NSDictionary alloc]initWithObjects:[[NSArray alloc]initWithObjects:delegate.studentNumber,@"2010-03-02", nil] forKeys:[[NSArray alloc]initWithObjects:@"studentNumber",@"date", nil]]; 
    [self performSearch:params];
    
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.resultTable=nil;
    self.selectedIndex=NSUIntegerMax;
    self.searchView=nil;
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark Action
-(IBAction)getNext:(id)sender{
    NSDate *dateFromString = [outFormatter dateFromString:dateLabel.text];
    
    // start by retrieving day, weekday, month and year components for yourDate
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: dateFromString options:0];
    [offsetComponents release];
    [gregorian release];
    
    dateLabel.text=[outFormatter stringFromDate:nextDate];
    

    
    
    
    NSDictionary *params=[[NSDictionary alloc]initWithObjects:[[NSArray alloc]initWithObjects:delegate.studentNumber,[inFormatter stringFromDate:nextDate], nil] forKeys:[[NSArray alloc]initWithObjects:@"studentNumber",@"date", nil]]; 
    [self performSearch:params];
    
}
-(IBAction)getPrevious:(id)sender{
    NSDate *dateFromString = [outFormatter dateFromString:dateLabel.text];
    // start by retrieving day, weekday, month and year components for yourDate
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-1];
    NSDate *preDate = [gregorian dateByAddingComponents:offsetComponents toDate: dateFromString options:0];
    [offsetComponents release];
    [gregorian release];
    dateLabel.text=[outFormatter stringFromDate:preDate];

    
    
    NSDictionary *params=[[NSDictionary alloc]initWithObjects:[[NSArray alloc]initWithObjects:delegate.studentNumber,[inFormatter stringFromDate:preDate], nil] forKeys:[[NSArray alloc]initWithObjects:@"studentNumber",@"date", nil]]; 
    [self performSearch:params];
    
}


#pragma mark - 
#pragma mark Toggle result View
-(void)toggleView{
    [searchButton setTitle:self.isInSearchMode ? @"Search":@"Result"];
    UIView *fromView=self.view;
    UIView *toView=self.searchView;
    
    if (self.isInSearchMode) {
        fromView=self.searchView;
        toView=self.view;
    }
    UIViewAnimationOptions animationOptions = self.isInSearchMode? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    
    //[sender setEnabled:NO];
    if (isInSearchMode) {
        [self search];
    }
    
    [UIView transitionFromView:fromView toView:toView duration:0.4 options:animationOptions completion:^(BOOL finished) {
        self.isInSearchMode = !self.isInSearchMode;
        
        
    }];
    
    //[searchButton setTitle:self.isInSearchMode ? @"Result":@"Search"];
    
    
    
    

}
-(void)search{
        
        NSDate *selectDate = datePicker.date;
        NSString *dateString = [inFormatter stringFromDate:selectDate];
        NSLog( @"picks %@",dateString);
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        [params setObject:delegate.studentNumber forKey:@"studentNumber"];
        [params setObject:dateString forKey:@"date"];
    dateLabel.text=[outFormatter stringFromDate:selectDate];
        [self performSearch:params];
    
}
- (void)performSearch:(NSDictionary *)params
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading timetables...";
    
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    if (isInSearchMode) {
        [self toggleView];
    }
    
    
    
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
        cell.detailTextLabel.text=@"";
        
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
