//
//  LoginViewController.m
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController

@synthesize studentNumber,textfield,button;

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
    studentNumber=@"";
    delegate=[[[UIApplication sharedApplication]delegate]retain];
    // Do any additional setup after loading the view from its nib.
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

-(IBAction)done:(id)sender{
    studentNumber=textfield.text;
    NSLog(@"sudent no==%@",studentNumber);
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
