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
#import "NewNoteViewController.h"
@class Timetable;


@implementation NotesViewController

@synthesize lectures,selectedIndex,coursesArray;

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
    coursesArray=[[NSArray alloc]initWithArray:[delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    NSLog(@"%@",coursesArray);
    
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
    [coursesArray release];
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
       delegate=[[[UIApplication sharedApplication]delegate]retain];
    self.title=@"Notes";
  
    [self fetch];
    
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   //  self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.navigationItem.rightBarButtonItem=self
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add)]autorelease];
    
    
}

-(void)fetch{
    //preform the fetch,
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    else{
        if ([coursesArray count]==0) {
            //check the network
            availableNetwork = NO;
            BOOL returnVal = [self isDataSourceAvailable];
            availableNetwork = returnVal;
            if (!availableNetwork) {
                NSLog(@"unable");
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Network loss"
                                      message:@"Unable to connect to internet"
                                      delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"Ok", nil];
                alert.tag=1;
                [alert show];

            }
            else{

            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"courses not found!"
                                  message:@"Do you like to get courses from web?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Ok", nil];
            alert.tag=1;
            [alert show];
            [self.navigationItem.leftBarButtonItem setEnabled:NO];
        }
        }
        
        else{
            [self.tableView reloadData];
        }
    }

    
}
//connect the web service to get the lectures
-(void)connectWebOnce {
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
    
    [[[LRResty client]get:urlString parameters:nil headers:requestHeaders delegate:self]timeoutAfter:10 handleWithBlock:^(LRRestyRequest *req){NSLog(@"timeout");}];
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
        lectures=[[NSMutableArray alloc]initWithArray:[self parse:jsonDictionary]];
        NSLog(@"%@",lectures);
        if ([lectures count]>0) {
            [self addLectures:lectures];
        }
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
        alert.tag=3;
        [alert show];
    }
    
}
- (void)restyRequest:(LRRestyRequest *)request didFailWithError:(NSError *)error {
    // issue visual alert
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Cannot connect to server!"
                          message:@"pls try later!"
                          delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    alert.tag=2;
    [alert show];
    
}
-(NSMutableArray *)parse:(NSDictionary *)dict {
    NSMutableArray *lecturesArray=[[NSMutableArray alloc]init];
    NSString *key=[[dict allKeys]objectAtIndex:0];
    NSLog( @"key==%@",key);
    
    if ([key isEqualToString:@"timetables"]) {
        NSArray *timetablesAray=[dict valueForKey:key];
        
        //denerate the lecturesArray
        for (NSDictionary *dict in timetablesAray) {
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

        
        
    }
    for (NSString *s in lecturesArray) {
        NSLog(@"%@\n",s);
    }
    return lecturesArray;
    
    
}
//at the lectures to the database
-(void)addLectures:(NSMutableArray *)lectureArray {
    //create the course model
    NSManagedObjectID *course;
    for (NSInteger i=1; i<lectureArray.count+1; i++) {
        course=[NSEntityDescription insertNewObjectForEntityForName:@"Courses" inManagedObjectContext:delegate.managedObjectContext];
        [course setValue:[[NSNumber alloc]initWithInt:i] forKey:@"course_id"];
        [course setValue:[lectureArray objectAtIndex:i-1] forKey:@"course_name"];
        [course setValue:@"" forKey:@"course_description"];
        NSError *error;
        [delegate.managedObjectContext save:&error];
        NSLog(@"lectures saved");
        [self fetch];
    }
    
    
}

-(IBAction)add {
    //this is learnt from RMIT Property app
    NewNoteViewController *newNote=[[NewNoteViewController alloc]initWithNibName:@"NewNoteViewController" bundle:nil];

    [newNote setTitle:@"New Note"];
    [self.navigationController pushViewController:newNote animated:YES];
    
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
    return  [coursesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"array count=%i",[coursesArray count]);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (lectures==nil) cell.textLabel.text=@"No Course Data";
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    else{
        Courses *course = [self.coursesArray objectAtIndex:indexPath.row];
        NSLog(@"count=%i",[coursesArray count]);
        cell.textLabel.text = [course course_name];
        cell.detailTextLabel.text =[course course_id];
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
#pragma mark- UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        if (buttonIndex!=[alertView cancelButtonIndex]) {
            [self connectWebOnce];
        }

    }
}
#pragma mark- reachibility
- (void)reachabilityChanged:(NSNotification *)note {
    [self updateStatus];
}
- (BOOL)isDataSourceAvailable {
    
    static BOOL checkNetwork = YES;
    static BOOL _isDataSourceAvailable = NO;
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
        checkNetwork = NO;
        Boolean success;
        const char *host_name = "google.com"; //pretty reliable :)
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    return _isDataSourceAvailable;
}

/*
- (void)updateStatus
{
    // Query the SystemConfiguration framework for the state of the device's network connections.
    self.internetConnectionStatus    = [[Reachability sharedReachability] internetConnectionStatus];
    if (self.internetConnectionStatus == NotReachable) {
        //show an alert to let the user know that they can't connect...
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" message:@"Sorry, our network guro determined that the network is not available. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }  else {
        // If the network is reachable, make sure the login button is enabled.
       // _loginButton.enabled = YES;
    }
}
 */

@end
