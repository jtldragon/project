//
//  NoteDetailViewController.m
//  project
//
//  Created by Yeshu Liu on 5/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "Notes.h"

@implementation NoteDetailViewController
@synthesize textLabel,titleLabel,timeLabel,note;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithNote:(NSManagedObject *)anote {
    self = [super initWithNibName:@"NoteDetailViewController" bundle:nil];
    if (self) {
        // Custom initialization
        [self setNote:(Notes *)anote];
        self.title=@"Notes";
    }
    return self;
}

- (void)dealloc
{
    [textLabel release];
    [timeLabel release];
    [titleLabel release];
    [note release];
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
    textLabel.editable=NO;
    textLabel.text=note.note_text;
    titleLabel.text=note.note_title;
    timeLabel.text=note.note_time;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    textLabel=nil;
    titleLabel=nil;
    timeLabel=nil;    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
