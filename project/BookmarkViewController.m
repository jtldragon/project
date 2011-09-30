//
//  BookmarkViewController.m
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "BookmarkViewController.h"
#import "Courses.h"
#import "NewCourseViewController.h"




@implementation BookmarkViewController

@synthesize coursesArray,selectedCellIndex,isInNewMode,addButton;

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
    [coursesArray release];
   // [tableView release];
    [delegate release];
    [addButton release];
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
    delegate=[[[UIApplication sharedApplication]delegate]retain];
    self.isInNewMode=NO;
    //self.navigationItem.rightBarButtonItem=self
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add)]autorelease];
}
-(void)add {
    //this is learnt from RMIT Property app
    NewCourseViewController *newCourse=[[NewCourseViewController alloc]initWithNibName:@"NewCourseViewController" bundle:nil];
    
    }


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.selectedCellIndex = NSUIntegerMax;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Action method

- (IBAction)search {
    
}



#pragma mark - 
#pragma mark Toggle result View
//when user click the 'result' button, the table view flip out.
-(IBAction)getNewCourseView:(id)sender {
       //this is learnt from RMIT Property app
    NewCourseViewController *newCourse=[[NewCourseViewController alloc]initWithNibName:@"NewCourseViewController" bundle:nil];
    
    UIView *fromView=self.view;
    UIView *toView=newCourse.view;
    
    if (self.isInNewMode) {
        fromView=newCourse.view;
        toView=self.view;
    }
    UIViewAnimationOptions animationOptions = self.isInNewMode ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    
    [sender setEnabled:NO];
    
    [UIView transitionFromView:fromView toView:toView duration:0.4 options:animationOptions completion:^(BOOL finished) {
        self.isInNewMode = !self.isInNewMode;
        [sender setTitle:self.isInNewMode ? @"Add":@"Course"];
        [sender setEnabled:YES];
    }];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.coursesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RMITCellIdentifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([coursesArray count]==0) cell.textLabel.text=@"No Course Data";
    else{
        Courses *course = [self.coursesArray objectAtIndex:indexPath.row];
        cell.textLabel.text = course.course_name;
        cell.detailTextLabel.text = course.course_description;
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    Courses *course = [self.coursesArray objectAtIndex:indexPath.row];
    self.selectedCellIndex = indexPath.row;
    /*
    [PropertyManager sharedPropertyManager].selectedProperty = property;
    
    DetailViewController *controller = [[[DetailViewController alloc]
                                         initWithProperty:property]
                                        autorelease];
    
    [self.navigationController pushViewController:controller 
                                         animated:YES];
     */
}


@end
