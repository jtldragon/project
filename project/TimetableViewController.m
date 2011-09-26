//
//  TimetableViewController.m
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "TimetableViewController.h"
#import "TimetableResultViewController.h"

@implementation TimetableViewController


@synthesize resultButton,datePicker,isInResultMode;



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
    [resultButton release];
    [datePicker release];
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
    self.isInResultMode=NO;
    
    
    
   
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


#pragma mark - 
#pragma mark Toggle result View
//when user click the 'result' button, the table view flip out.
-(IBAction)getResultView:(id)sender{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-mm-dd"];
    
    NSDate *selectDate = datePicker.date;
    
    NSString *dateString = [format stringFromDate:selectDate];
    NSLog( @"picks %@",dateString);
    
    //this is learnt from RMIT Property app
    TimetableResultViewController *resultViewController=[[TimetableResultViewController alloc]initCustomWithNibName:@"TimetableResultViewController" bundle:nil date:dateString];
    
    UIView *fromView=self.view;
    UIView *toView=resultViewController.view;
    
    if (self.isInResultMode) {
        fromView=resultViewController.view;
        toView=self.view;
    }
    UIViewAnimationOptions animationOptions = self.isInResultMode ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    
    [sender setEnabled:NO];
    
    [UIView transitionFromView:fromView toView:toView duration:0.4 options:animationOptions completion:^(BOOL finished) {
        self.isInResultMode = !self.isInResultMode;
        [sender setTitle:self.isInResultMode ? @"Search":@"Result"];
        [sender setEnabled:YES];
    }];
}

@end
