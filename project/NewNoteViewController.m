//
//  NewCourseViewController.m
//  project
//
//  Created by Yeshu Liu on 27/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "NewNoteViewController.h"
#import "Courses.h"
#import "NotesViewController.h"


@implementation NewNoteViewController

@synthesize textfield_name,textview_descrip,button_save,button_cancel;

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
    [button_cancel release];
    [button_save release];
    [textfield_name release];
    [textview_descrip release];
    [delegate release];
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
    NotesViewController *noteViewController=[[NotesViewController alloc]init];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Action method

-(IBAction) save:(id)sender {
    [textfield_name resignFirstResponder];
    [textview_descrip resignFirstResponder];
    if ([textfield_name.text isEqualToString:@""]) {
        // issue visual alert
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No input!"
                              message:@"pls input something!"
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
     
    
    
    //create the student model
    
    NSManagedObjectID *course;
    course=[NSEntityDescription insertNewObjectForEntityForName:@"Courses" inManagedObjectContext:delegate.managedObjectContext];
    [course setValue:textfield_name.text forKey:@"course_name"];
    [course setValue:textview_descrip.text forKey:@"course_description"];
    static int tempID = 0;
    [course setValue:[NSNumber numberWithInt:++tempID]  forKey:@"course_id"];
    
    NSError *error;
    [delegate.managedObjectContext save:&error];
    NSLog(@"course entity saved");
    
    [delegate.navigationController popViewControllerAnimated:YES];
   // UITableView *table=NotesViewController.view;
    
    
    
    
    
    
}

-(IBAction) cancel:(id)sender {
    
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [textfield_name resignFirstResponder];
    [textview_descrip resignFirstResponder];
    
}
- (IBAction)backgroundTouched:(id)sender
{
    [textfield_name resignFirstResponder];
    [textview_descrip resignFirstResponder];
}




@end
