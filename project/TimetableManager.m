//
//  TimetableManager.m
//  project
//
//  Created by Yeshu Liu on 1/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "TimetableManager.h"
#import <YAJLiOS/YAJL.h>


@implementation TimetableManager

@synthesize timetables;

+(TimetableManager *)sharedTimetableManager
{
//More on singletons can be found in 'Cocoa Design Patterns' by Erik Buck & Donald Yacktman Chapter 13, page 148 of te 2010 edition.

static TimetableManager *singletonInstance = nil;

if (!singletonInstance)
{
singletonInstance = [[[self class] alloc] init];
}
return singletonInstance;
}

- (void)performSearch:(NSDictionary *)params
{
    
    NSString *urlstring=[NSString stringWithFormat:@"https://announcements.mobile-test.its.rmit.edu.au/studentwebservices/rest/timetable/studentId/%@/date/%@/additionalDays/%@",[params objectForKey:@"studentId"],[params objectForKey:@"date"],[params objectForKey:@"additionalDays"]];
    NSLog(@"%@",urlstring);
    NSDictionary *requestHeaders = [NSDictionary 
                                    dictionaryWithObject:@"application/json" forKey:@"Accept"];
    
    [[LRResty client]get:urlstring parameters:nil headers:requestHeaders delegate:self];
   // [[LRResty client] get:urlstring
     //          parameters:params
       //          delegate:self];
}

#pragma mark - LRRestyClientResponseDelegate

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response
{
    NSLog(@"response==%@",response);
    if ([response status]==200) {
        NSData *data = [response responseData];
        NSLog(@"%@",data);
        NSDictionary *jsonDictionary = [data yajl_JSON];
        NSArray *timesArray = [jsonDictionary valueForKey:@"timetables"];
        
        // NSMutableArray *newTimes = [NSMutableArray array];
        //for (NSDictionary *dict in timesArray)
        //{
        //  Property *property = [Property propertyWithDictionary:dict];
        //[newProperties addObject:property];
        //}
        
        self.timetables = timesArray;
        
    }
    else {}
    
}




@end
