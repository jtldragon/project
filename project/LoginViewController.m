//
//  LoginViewController.m
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "LoginViewController.h"
#import "Student.h"

@implementation LoginViewController

@synthesize studentNumber,textfield,button,resultArray;

@synthesize context=_context;

@synthesize fetchedResultsController=_fetchResultsController;


-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchResultsController!=nil) {
        return _fetchResultsController;
    }
    _context=delegate.managedObjectContext;
    // Create the fetch request, entity and sort descriptors
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Student" inManagedObjectContext:_context];    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"studentno" ascending:NO];
    
    // Set properties on the fetch
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    NSError *error;
    resultArray=[[NSArray alloc]initWithArray:[_context executeFetchRequest:fetchRequest error:&error]];
    
  //  NSLog(@"%@ records found.",[resultSet count]);
   /* for(NSManagedObject *a in resultSet){
        NSLog(@"%@",a);}
    
    if (resultSet==nil) {
        NSLog(@"0 record");
    }
    */
    
    
    // Create a fresh fetched results controller
    NSFetchedResultsController *fetched = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
        managedObjectContext:_context 
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
    [studentNumber release];
    [textfield release];
    [button release];
    [delegate release];
    [_fetchResultsController release];
    [resultArray release];
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
    // Do any additional setup after loading the view from its nib.
    
    //preform the fetch,load the latest student no in the database
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    else{
        if ([resultArray count]==0) {
            studentNumber=@"";
        }
        else{
        //resultArray=[_fetchResultsController fetchedObjects];
       // NSLog(@"feted rusult=%@",[resultArray count]);
        Student *student= [resultArray objectAtIndex:0];
        textfield.text=student.studentno;}
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fetchedResultsController=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//add the student entity to sqlite if the student no. is not existed
-(IBAction)done:(id)sender{
    [textfield resignFirstResponder];
    studentNumber=textfield.text;
    NSLog(@"sudent no==%@",studentNumber);
    
    //delete sudentnumber stored in the database
    if ([resultArray count]>0) {
        
        [_context deleteObject:[resultArray objectAtIndex:0]];
        
    }
        
        //create the student model
       
        NSManagedObjectID *student;
        student=[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_context];
        [student setValue:studentNumber forKey:@"studentno"];
        //[student setValue:now forKey:@"date"];
        
        NSError *error;
        [_context save:&error];
        NSLog(@"student entity saved");

    
    
    //set the studentnumber in delegate
    delegate.studentNumber=studentNumber;
    NSLog(@"delegate. studentno=%@",delegate.studentNumber);
    //remove the loginview from main window
    for (UIView *view in [delegate.window subviews]) { [view removeFromSuperview]; }
    //add the timetable view to main window
    [delegate.window addSubview:delegate.tabBarController.view];
}
- (IBAction)textFieldDoneEditing:(id)sender
{
    [textfield resignFirstResponder];
        
}
- (IBAction)backgroundTouched:(id)sender
{
    [textfield resignFirstResponder];
}



@end
