//
//  TimetableResultViewController.m
//  project
//
//  Created by Yeshu Liu on 26/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "TimetableResultViewController.h"
#import "Timetable.h"



@implementation TimetableResultViewController

@synthesize date,tablesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initCustomWithNibName:(NSString *)nibNameOrNil 
          bundle:(NSBundle *)nibBundleOrNil
            date:(NSString *)seletedDate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setDate:seletedDate];
        appDelegate =[[[UIApplication sharedApplication]delegate]retain];
    }
    return self;
}

- (void)dealloc
{
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

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tablesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RMITIdentifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:cellIdentifier] autorelease];
    }
    
    Timetable  *time = [self.tablesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = time.classTitle;
    cell.detailTextLabel.text = [time description];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    Timetable *timetable = [self.tablesArray objectAtIndex:indexPath.row];
    
    
    //[TimetableManager sharedPropertyManager].selectedProperty = property;
    
    
}

#pragma mark -
#pragma mark Search

- (void)search
{    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /*if (self.searchBar.text)
    {
        [params setValue:self.searchBar.text forKey:@"q"];
    }*/
    [params setValue:[appDelegate studentNumber]  forKey:@"studentId"];
    [params setValue:date forKey:@"date"];
    
    
    //[[TimetableManager sharedPropertyManager] performTimetableSearch:params];
}



@end
