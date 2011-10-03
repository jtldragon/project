//
//  NotesViewController.m
//  project
//
//  Created by Yeshu Liu on 27/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "NotesViewController.h"
#import <YAJLiOS/YAJL.h>
#import "MBProgressHUD.h"
#import "Courses.h"
#import "NewCourseViewController.h"
@class Timetable;


@implementation NotesViewController

@synthesize lectures,selectedIndex;

@synthesize fetchedResultsController=_fetchResultsController;

#pragma fetchresulcontroller
-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchResultsController!=nil) {
        return _fetchResultsController;
    }
    
    // Create the fetch request, entity and sort descriptors
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Courses" inManagedObjectContext:delegate.managedObjectContext];    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"course_id" ascending:NO];
    
    // Set properties on the fetch
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    NSError *error;
    //coursesArray=[[NSArray alloc]initWithArray:[delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    //  NSLog(@"%@ records found.",[resultSet count]);
    /* for(NSManagedObject *a in resultSet){
     NSLog(@"%@",a);}
     
     if (resultSet==nil) {
     NSLog(@"0 record");
     }
     */
    
    
    // Create a fresh fetched results controller
    NSFetchedResultsController *fetched = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
        managedObjectContext:delegate.managedObjectContext 
          sectionNameKeyPath:nil
                   cacheName:nil];
    
    // NSLog(@"fetctede cout =%@",[fetched.fetchedObjects count] );
    self.fetchedResultsController = fetched;
    _fetchResultsController.delegate=self;
    
    // Release objects and return our controller
    [fetched release];
    [fetchRequest release];
    
    
    [descriptor release];
    
    //NSLog(@"fected count=%@",[_fetchResultsController.fetchedObjects count]);
    
    //[_fetchResultsController performFetch:&error];
    return _fetchResultsController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)dealloc
{
    [lectures release];
    [delegate release];
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
    self.title=@"Notes";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    delegate=[[[UIApplication sharedApplication]delegate]retain];
    //self.navigationItem.rightBarButtonItem=self
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add)]autorelease];
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading lectures...";
    [self search];
    /*
    TimetableConnect *conn=[[TimetableConnect alloc]initWithParams:array];
    [conn makeRequest];
    NSMutableArray *timesArray=[[NSMutableArray alloc]initWithArray:conn.timetablesArray];
    NSLog(@"times count=%i",[timesArray count]);
    NSMutableArray *lecturesArray=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in timesArray) {
        NSLog(@"%@\n ",dict);
        if ([[dict valueForKey:@"activityType"] isEqualToString:@"Lecture"]) {
            NSString *title=[dict valueForKey:@"title"];
            //check whether there is a duplicate
            if ([lecturesArray count]==0) {
                [lecturesArray addObject:title];
            }
            else {
                BOOL addflag=YES;
                //check whether there is a duplicate
                for (int i=0; i<[lecturesArray count];i++ ) {
                    NSString *a=[lecturesArray objectAtIndex:i];
                    if ([a isEqualToString:title]) {
                        addflag=NO;
                    }
                }
                if (addflag) {
                    [lecturesArray addObject:title];
                }
                
            }
            
        }
    }
    
    for (NSString *s in lecturesArray) {
        NSLog(@"%@\n",s);
    }
    NSLog(@"count=%i",[conn.lectures count]);
    coursesArray=[[NSMutableArray alloc]initWithArray:lecturesArray];
     */
    
   // NSLog(@"array count in view did load=%i",[coursesArray count]);
    
    
}
-(void)search {
    //generate date string
    NSString *dateString = @"2010-03-02";
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setObject:delegate.studentNumber forKey:@"studentNumber"];
    [params setObject:dateString forKey:@"date"];
    [self performSearch:params];
}

- (void)performSearch:(NSDictionary *)params
{
    NSString *urlString=@"";
    urlString=[NSString stringWithFormat:@"https://announcements.mobile-test.its.rmit.edu.au/studentwebservices/rest/timetable/studentId/%@/date/%@/additionalDays/7",[params objectForKey:@"studentNumber"],[params objectForKey:@"date"]];
    
        
    
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
        NSDictionary *jsonDictionary = [data yajl_JSON];
       NSLog(@"%@",jsonDictionary);
        [self parse:jsonDictionary];
        // NSArray *locationsArray = [jsonDictionary valueForKey:@"location"];
        // for (NSDictionary *dict in locationsArray) {
        //    NSLog(@"dict %@\n",dict);
        //    [self.locations addObject:[[NSDictionary alloc]initWithDictionary:dict//]];
        //  }
        // [self.locations addObjectsFromArray:locationsArray];
        //  NSLog(@"locationarray :%@",locationsArray);
       // NSLog(@"%@",self.locations);
        
        // [tableView reloadData];
        // NSLog(@"%@",locations);
        
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
    [self.tableView reloadData];
    
    
    
}

-(void)add {
    //this is learnt from RMIT Property app
    NewCourseViewController *newCourse=[[NewCourseViewController alloc]initWithNibName:@"NewCourseViewController" bundle:nil];

    [newCourse setTitle:@"New Course"];
    [self.navigationController pushViewController:newCourse animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
   // NSLog(@"array count in number of section=%i",[coursesArray count]);
    //return self.coursesArray.count;
    return  5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"array count=%i",[coursesArray count]);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (lectures==nil) cell.textLabel.text=@"No Course Data";
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    else{
        Courses *course = [self.lectures objectAtIndex:indexPath.row];
        cell.textLabel.text = course.course_name;
        cell.detailTextLabel.text = course.course_description;
    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
