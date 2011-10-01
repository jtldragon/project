//
//  LocationManager.m
//  project
//
//  Created by Yeshu Liu on 2/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "LocationManager.h"
#import <YAJLiOS/YAJL.h>


@implementation LocationManager

@synthesize locations;

+(LocationManager *)sharedLocationManager
{
    //More on singletons can be found in 'Cocoa Design Patterns' by Erik Buck & Donald Yacktman Chapter 13, page 148 of te 2010 edition.
    
    static LocationManager *singletonInstance = nil;
    
    if (!singletonInstance)
    {
        singletonInstance = [[[self class] alloc] init];
    }
    return singletonInstance;
}

- (NSArray *)performSearch:(NSDictionary *)params
{
    
    NSString *urlstring=[NSString stringWithFormat:@"https://announcements.mobile-test.its.rmit.edu.au/studentwebservices/rest/location/campus/%@/buildingNumber/%@",[params objectForKey:@"campus"],[params objectForKey:@"buildingNumber"]];
    NSLog(@"%@",urlstring);
    NSDictionary *requestHeaders = [NSDictionary 
                                    dictionaryWithObject:@"application/json" forKey:@"Accept"];
    
    [[LRResty client]get:urlstring parameters:nil headers:requestHeaders delegate:self];
    return self.locations;
}

#pragma mark - LRRestyClientResponseDelegate

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response
{
    NSLog(@"response==%@",response);
    if ([response status]==200) {
        NSData *data = [response responseData];
        NSDictionary *jsonDictionary = [data yajl_JSON];
        //NSLog(@"%@",jsonDictionary);
        NSArray *locationsArray = [jsonDictionary valueForKey:@"location"];
        self.locations = locationsArray;
       // NSLog(@"%@",locations);
        
    }
    else {
        //error message
    }
    
}




@end
