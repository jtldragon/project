//
//  Location.m
//  project
//
//  Created by Yeshu Liu on 2/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "Location.h"


@implementation Location

@synthesize additionalInformation,campus,contactDetails,description,Id,latitude,longitude,name,rmitBuildingNumber;

- (id)initWithDictionary:(NSDictionary *)dict {
    {
        self=[super init];
        if(self!=nil)
        {
            [self setAdditionalInformation:[dict valueForKey:@"additionalInformation"]];
            [self setCampus:[dict valueForKey:@"campus"]];
            [self setContactDetails:[dict valueForKey:@"contactDetails"]];
            [self setDescription:[dict valueForKey:@"description"]];
            [self setId:[dict valueForKey:@"id"]];
            [self setName:[dict valueForKey:@"name"]];
            [self setLongitude:[dict valueForKey:@"longitude"]];
            [self setLatitude:[dict valueForKey:@"latitude"]];
            [self setRmitBuildingNumber:[dict valueForKey:@"rmitBuildingNumber"]];
        }
        return self;
        
    }
    
}


   

- (void)dealloc
{
    [additionalInformation release];
    [campus release];
    [contactDetails release];
    [description release];
    [Id release];
    [latitude release];
    [longitude release];
    [name release];
    [rmitBuildingNumber release];
    
    [super dealloc];
}


/*
#pragma mark -
#pragma mark MKAnnotation Protocol

//MKAnnotation is required to implement -title if you want to display a callout

-(NSString *)title
{
    return self.rmitBuildingNumber;
}
 */

@end

