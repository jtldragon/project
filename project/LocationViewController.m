//
//  LocationViewController.m
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "LocationViewController.h"
#import <YAJLiOS/YAJL.h>
#import "Location.h"



@implementation LocationViewController

@synthesize textfield,segment,selecedIndex,tableView,locations;

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
    
    [textfield release];
    [segment release];
    [locations release];
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
    locations=[[NSMutableArray alloc]init];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.selecedIndex=NSUIntegerMax;
    self.tableView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([locations count]==0) {
        return 0;
    }
    else{
    return [locations count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:cellIdentifier] autorelease];
    }
    
    
    Location *location=[[Location alloc]initWithDictionary:[locations objectAtIndex:indexPath.row]];
   
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",location.campus,location.name];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@, %@",location.latitude,location.longitude];
    [location release];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    Location *location=[[Location alloc]initWithDictionary:[locations objectAtIndex:indexPath.row]];
    self.selecedIndex = indexPath.row;
    
    //[PropertyManager sharedPropertyManager].selectedProperty = property;
    
    LocationDetailViewController *controller = [[[DetailViewController alloc]initWithLocation:location]autorelease];
    
    //[self.navigationController pushViewController:controller 
                                       //  animated:YES];
}

#pragma mark -
#pragma mark Search

- (IBAction)search
{
    [textfield resignFirstResponder];
    //[locations release];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *bldgNo= textfield.text;
    NSString *campus=@"";
    if(segment.selectedSegmentIndex==0){
        campus=@"AUSCY";
    }
    //currently only city campus work
    else {
        campus=@"AUSBR";
    }
    if ([bldgNo isEqualToString:@""]) {
        [params setObject:campus forKey:@"campus"];
    }
    else{
    [params setObject:bldgNo forKey:@"buildingNumber"];
    [params setObject:campus forKey:@"campus"];
    }
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText = @"Loading properties...";
    
    //[self.mapView removeAnnotations:[self.mapView annotations]];
    
    [self performSearch:params];
    //[self.delegate=self];
    //NSLog(@"location=%@",locations);
   
    //[self.tableView reloadData];
}

- (void)performSearch:(NSDictionary *)params
{
    NSString *urlString=@"";
    if ([textfield.text isEqualToString:@""]) {
        urlString=[NSString stringWithFormat:@"https://announcements.mobile-test.its.rmit.edu.au/studentwebservices/rest/location/campus/%@",[params objectForKey:@"campus"]];
        
    }
    else{
        urlString=[NSString stringWithFormat:@"https://announcements.mobile-test.its.rmit.edu.au/studentwebservices/rest/location/campus/%@/buildingNumber/%@",[params objectForKey:@"campus"],[params objectForKey:@"buildingNumber"]];
    }
    NSLog(@"%@",urlString);
    NSDictionary *requestHeaders = [NSDictionary 
                                    dictionaryWithObject:@"application/json" forKey:@"Accept"];
    
    [[LRResty client]get:urlString parameters:nil headers:requestHeaders delegate:self];
    //return self.locations;
}

#pragma mark - LRRestyClientResponseDelegate

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response
{
    NSLog(@"response==%@",response);
    if ([response status]==200) {
        NSData *data = [response responseData];
        NSDictionary *jsonDictionary = [data yajl_JSON];
        //NSLog(@"%@",jsonDictionary);
        [self parse:jsonDictionary];
       // NSArray *locationsArray = [jsonDictionary valueForKey:@"location"];
       // for (NSDictionary *dict in locationsArray) {
        //    NSLog(@"dict %@\n",dict);
        //    [self.locations addObject:[[NSDictionary alloc]initWithDictionary:dict//]];
      //  }
       // [self.locations addObjectsFromArray:locationsArray];
      //  NSLog(@"locationarray :%@",locationsArray);
      //  NSLog(@"%@",self.locations);
        
       // [tableView reloadData];
        // NSLog(@"%@",locations);
        
    }
    else {
        //error message
    }
    
}
-(void)parse:(NSDictionary *)dict {
    NSString *key=[[dict allKeys]objectAtIndex:0];
    NSLog( @"key==%@",key);
    
    if ([key isEqualToString:@"locations"]) {
        NSArray *locationsAray=[dict valueForKey:key];
        //NSLog( @"one lo==%@",locationsAray);
        [locations removeAllObjects];
        [locations addObjectsFromArray:locationsAray]; 
       // NSLog(@"locations will be:%@",locations);
        
    }
    else {
        NSDictionary *locationsAray=[dict valueForKey:key];
        [locations removeAllObjects];
        [locations addObject:locationsAray];
        
    }
    [tableView reloadData];
     
    
    
}


#pragma mark -
#pragma mark hidekeyboard

- (IBAction)textFieldDoneEditing:(id)sender
{
    [textfield resignFirstResponder];
        
}


@end
