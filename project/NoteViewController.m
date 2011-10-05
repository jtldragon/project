//
//  NoteViewController.m
//  project
//
//  Created by Yeshu Liu on 5/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "NoteViewController.h"
#import "NewNoteViewController"
#import "Notes.h"


@implementation NoteViewController

@synthesize fetchedResultsController=_fetchResultsController;
@synthesize selectedIndex,notesArray;


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
    notesArray=[[NSArray alloc]initWithArray:[delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    NSLog(@"%@",notesArray);
    
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
    [_fetchResultsController release];
    [notesArray release];
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
     self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add)]autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)]autorelease];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)fetch{
    //preform the fetch,
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if([notesArray count]==0){
        return 1;
    }
    else {
        return [notesArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    // Configure the cell...
    else{
        if ([notesArray count]==0) {
            cell.textLabel.text=@"No notes";
            cell.detailTextLabel.text=@"";
        }
        else{
        Notes *note = [self.notesArray objectAtIndex:indexPath.row];
            NSLog(@"row=%i",indexPath.row);
        NSLog(@"count=%i",[coursesArray count]);
        cell.textLabel.text = [Notes ];
        cell.detailTextLabel.text =[course course_id];
        }
    }
    
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
