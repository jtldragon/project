//
//  LocationDetailViewController.m
//  project
//
//  Created by Yeshu Liu on 2/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "MKMapView+Zoom.h"


@implementation LocationDetailViewController

@synthesize location,label_bNo,label_campus,label_contact,mapView,isInMapMode,mapButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithLocation:(Location *)loc {
    self = [super initWithNibName:@"LocationDetailViewController" bundle:nil];
    if (self) {
        // Custom initialization
        [self setLocation:loc];
        self.title=@"Location";
        self.isInMapMode=NO;
    }
    return self;
}

- (void)dealloc
{
    [label_campus release];
    [label_bNo release];
    [label_contact release];
    [location release];
    [mapView release];
    [mapButton release];
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
    self.label_bNo.text=location.rmitBuildingNumber;
    self.label_campus.text=location.description;
    self.label_contact.text=location.contactDetails;
    self.mapView.delegate = self;
    //add annotation to building
    [self.mapView addAnnotation:location];
    [self.mapView zoomToFitAnnotations];
    self.mapView.showsUserLocation=YES;
    

    //create map button
    mapButton = [[UIBarButtonItem alloc] initWithTitle: @"Map"
                                                                      style: UIBarButtonItemStyleBordered
                                                                     target: nil action: nil];
    
     
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.label_bNo=nil;
    self.label_campus=nil;
    self.label_contact=nil;
    self.mapView=nil;
    self.mapButton=nil;
    //[self.location release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)senderMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSString *AnnotationViewReuseIdentifier = @"PinReuseIdentifier";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[[senderMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewReuseIdentifier] retain];
    
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewReuseIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else
    {
        annotationView.annotation = annotation;
    }
    
    return [annotationView autorelease];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    
   // [self.navigationController pushViewController:self animated:YES];
}
/*
- (void)mapView:(MKMapView *)theMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [theMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}
 */
#pragma action method
-(IBAction)toggleMapView:(id)sender {
    UIView *fromView = self.view;
    UIView *toView = self.mapView;
    
    if (self.isInMapMode)
    {
        fromView = self.mapView;
        toView = self.view;
    }
    
    UIViewAnimationOptions animationOptions = self.isInMapMode ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    
    [sender setEnabled:NO];
    
    [UIView transitionFromView:fromView toView:toView duration:0.4 options:animationOptions completion:^(BOOL finished) {
        self.isInMapMode = !self.isInMapMode;
        [sender setTitle:self.isInMapMode ? @"Detail":@"Map"];
        [sender setEnabled:YES];
    }];

    
}
 

#pragma mark - 
#pragma mark CLLocationManagerDelegate
/*
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    //CLLocationCoordinate2D userCoordinate = locationManager.location.coordinate;
    //[mapView setCenterCoordinate:userCoordinate animated:YES];
    //[mapView setShowsUserLocation:YES]; 
}
 */

@end
