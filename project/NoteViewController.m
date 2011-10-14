//
//  NoteViewController.m
//  project
//
//  Created by Yeshu Liu on 5/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteDetailViewController.h"
#import "Notes.h"


@implementation NoteViewController

@synthesize fetchedResultsController=_fetchResultsController;
@synthesize notes;
@synthesize newNote,isInAddMode,isInEditMode, editButton,addButton,textview,titleField,mytableView;


#pragma fetchresulcontroller
-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchResultsController!=nil) {
        return _fetchResultsController;
    }
    
    // Create the fetch request, entity and sort descriptors
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Notes" inManagedObjectContext:delegate.managedObjectContext];    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"note_id" ascending:NO];
    
    // Set properties on the fetch
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    NSError *error;
    
    NSArray *notesArray=[[NSMutableArray alloc]initWithArray:[delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    [notes removeAllObjects];
    [notes addObjectsFromArray:notesArray];
    NSLog(@"%@",notesArray);
       
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
    [notesArray release];
    
    //NSLog(@"fected count=%@",[_fetchResultsController.fetchedObjects count]);
    
    //[_fetchResultsController performFetch:&error];
    return _fetchResultsController;
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    if (!self.mytableView.editing) 
        [self.mytableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //Add observers to the location manager 
        // locations=[[NSMutableArray alloc]init];
        
        //[tableView init];
    }
    return self;
}

- (void)dealloc
{
    [addButton release];
    [_fetchResultsController release];
    [editButton release];
    //[notesArray release];
    [notes release];
    [newNote release];
    [textview release];
    [titleField release];
    [mytableView release];
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
    self.isInAddMode=NO;
    self.isInEditMode=YES;
    notes=[[NSMutableArray alloc]init];
    delegate=[[[UIApplication sharedApplication]delegate]retain];
    self.title=@"Notes";
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    NSLog(@"note scount=%i",[notes count]);
    [self.mytableView reloadData];
    addButton=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonSystemItemAction target:self action:@selector(toggleView)];
    editButton=[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonSystemItemAction target:self action:@selector(editAction)];
    self.navigationItem.leftBarButtonItem=addButton;
    self.navigationItem.rightBarButtonItem=editButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)fetch{
    //preform the fetch,
    
}
-(IBAction)editAction {
    //if is in add mode
    if (isInAddMode) {
        NSString *title=titleField.text;
        NSString *text=textview.text;
        if ([title isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"No Title input"
                                  message:@"Please input the title"
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"Ok", nil];
            [alert show];
            [alert release];
        }
        else{
            NSDate *date=[NSDate date];
            NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *stringFromDate = [formatter stringFromDate:date];
            NSManagedObjectID *note;
            note=[NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:delegate.managedObjectContext];
            [note setValue:[[[NSNumber alloc]initWithInt:[notes count]+1]autorelease] forKey:@"note_id"];
            [note setValue:stringFromDate forKey:@"note_time"];
            [note setValue:title forKey:@"note_title"];
            [note setValue:text forKey:@"note_text"];
            NSError *error;
            [delegate.managedObjectContext save:&error];
            NSLog(@"notes saved");
            textview.text=@"";
            titleField.text=@"";
            [self toggleView];
            [self.mytableView reloadData];
        }
    }
    else{
        if (isInEditMode) {
          
                
            
            editButton.title=@"Done";
            isInEditMode=NO;
            if (notes.count>0) {
                [self.mytableView setEditing:YES animated:YES];
            }
            else{
                [self.mytableView setEditing:NO animated:YES];
            }
            
            

        }
        else{
            editButton.title=@"Edit";
            isInEditMode=YES;
            [self.mytableView setEditing:NO animated:YES];
            
        }
    }
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    self.newNote=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mytableView=nil;
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
#pragma mark - 
#pragma mark Toggle add View
-(void)toggleView{
    [addButton setTitle:self.isInAddMode ? @"Add":@"Cancel"];
    [editButton setTitle:self.isInAddMode ? @"Edit":@"Save"];
    UIView *fromView=self.view;
    UIView *toView=self.newNote;
    
    if (self.isInAddMode) {
        fromView=self.newNote;
        toView=self.view;
    }
    UIViewAnimationOptions animationOptions = self.isInAddMode? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    
    //[sender setEnabled:NO];
    /*
    if (isInAddMode) {
        [self search];
    }
     */
    
    [UIView transitionFromView:fromView toView:toView duration:0.4 options:animationOptions completion:^(BOOL finished) {
        self.isInAddMode = !self.isInAddMode;
        
        
    }];
    
    //[searchButton setTitle:self.isInSearchMode ? @"Result":@"Search"];
    
    
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Create the fetch request, entity and sort descriptors
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Notes" inManagedObjectContext:delegate.managedObjectContext];    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"note_id" ascending:NO];
    
    // Set properties on the fetch
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    NSError *error;
    
    NSArray *notesArray=[[NSMutableArray alloc]initWithArray:[delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    [notes removeAllObjects];
    [notes addObjectsFromArray:notesArray];
    // Return the number of rows in the section.
    [fetchRequest release];
    //[entity release];
    [descriptor release];
    [notesArray release];
        
    if([notes count]==0){
        return 1;
    }
    else {
        NSLog(@"not in table %i",[notes count]);
        return [notes count];
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
    
    if ([notes count]==0) {
        cell.textLabel.text=@"";
        cell.detailTextLabel.text=@"";
        [tableView setEditing:NO animated:YES];
    }
    else{
        Notes *note = [self.notes objectAtIndex:indexPath.row];
        NSLog(@"row=%i",indexPath.row);
        NSLog(@"time=%@",[note note_time]);
        cell.textLabel.text = note.note_title;
        cell.detailTextLabel.text =note.note_time;
       
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (notes.count>0) {
            // Delete the row from the data source
            NSManagedObject *note;
            note = [notes objectAtIndex:indexPath.row];
            [delegate.managedObjectContext deleteObject:note];
            NSError *error; 
            
            if (![delegate.managedObjectContext save:&error]) {
                // Handle error
                NSLog(@"Unresolved error series %@, %@", error, [error userInfo]);
                
            }
            NSLog(@"delete sussculfl");
            
            [notes removeObjectAtIndex:indexPath.row];
            //[self.tableView setEditing:NO animated:YES];
            if (notes.count==0) {
                [self.mytableView setEditing:NO animated:YES];
            }
            [self.mytableView reloadData];
            
        }
        else {
            [self.mytableView setEditing:NO animated:YES];
        }
        
        
        //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    NSManagedObject *note = [notes objectAtIndex:indexPath.row];
    NoteDetailViewController *detailViewController = [[NoteDetailViewController alloc]initWithNote:note];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
    //[note release];
     
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
    //[titleField resignFirstResponder];
    
}
@end
