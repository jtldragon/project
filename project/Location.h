//
//  Location.h
//  project
//
//  Created by Yeshu Liu on 2/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject  <MKAnnotation>

-(id)initWithDictionary:(NSDictionary *)dict;



@property(nonatomic,copy)NSString *additionalInformation;
@property(nonatomic,copy)NSString *campus;
@property(nonatomic,copy)NSString *contactDetails;
@property(nonatomic,copy)NSString *description;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *rmitBuildingNumber;



#pragma mark - MKAnnotation Protocol

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;







@end
