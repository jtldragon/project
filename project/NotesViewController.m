//
//  NotesViewController.m
//  project
//
//  Created by Yeshu Liu on 27/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "NotesViewController.h"
#import "Courses.h"
#import "NewCourseViewController.h"
#import "TimetableConnect.h"
#import "TimetableManager.h"

@implementation NotesViewController

@synthesize coursesArray,selectedCellIndex;

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
        //Add observers to the property manager 
        [[TimetableManager sharedTimetableManager] addObserver:self 
                                                  forKeyPath:@"timetables" 
                                                     options:(NSKeyValueObservingOptionNew) 
                                                     context:nil];

    }
    return self;
}

- (void)dealloc
{
    [[TimetableManager sharedTimetableManager]removeObserver:self forKeyPath:@"timetables"];
    [coursesArray release];
    // [tableView release];
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
    NSLog(@"array count in view did load=%i",[coursesArray count]);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    delegate=[[[UIApplication sharedApplication]delegate]retain];
    //self.navigationItem.rightBarButtonItem=self
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add)]autorelease];
    
    //generate date string
    NSString *dateString = @"2010-03-02";
    NSArray *array=[[NSArray alloc]initWithObjects:delegate.studentNumber,dateString,@"7", nil];
    [[TimetableManager sharedTimetableManager]performSearch:[[NSDictionary alloc]initWithObjects:array forKeys:[[NSArray alloc]initWithObjects:@"studentId",@"date",@"additionalDays", nil]]];
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
    
    NSLog(@"array count in view did load=%i",[coursesArray count]);
    
    
}
-(void)add {
    //this is learnt from RMIT Property app
    NewCourseViewController *newCourse=[[NewCourseViewController alloc]initWithNibName:@"NewCourseViewController" bundle:nil];

    [newCourse setTitle:@"New Course"];
    [delegate.navigationController pushViewController:newCourse animated:YES];
    
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
    NSLog(@"array count in number of section=%i",[coursesArray count]);
    //return self.coursesArray.count;
    return  5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"array count=%i",[coursesArray count]);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (coursesArray==nil) cell.textLabel.text=@"No Course Data";
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    else{
        Courses *course = [self.coursesArray objectAtIndex:indexPath.row];
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
