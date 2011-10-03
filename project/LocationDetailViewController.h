//
//  LocationDetailViewController.h
//  project
//
//  Created by Yeshu Liu on 2/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>



@interface LocationDetailViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate> {
    
}

-(id)initWithLocation:(Location *)loc;
    

@property (nonatomic, retain)Location *location;
@property (nonatomic, retain) IBOutlet UILabel *label_campus;
@property (nonatomic, retain) IBOutlet UILabel *label_bNo;
@property (nonatomic, retain) IBOutlet UILabel *label_contact;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) BOOL isInMapMode;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mapButton;
//@property (nonatomic, retain) CLLocationManager *locationManager;
- (IBAction)toggleMapView:(id)sender;





@end
