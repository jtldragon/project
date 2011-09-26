//
//  TimetableManager.m
//  project
//
//  Created by Yeshu Liu on 26/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "TimetableManager.h"
#import "YAJLios/YAJL.h"


@implementation TimetableManager

@synthesize tablesArray;

//most is learn from RMIT Property app
+(TimetableManager *)sharedTimetableManager {
    
    static TimetableManager *singletonInstance = nil;
    
    if (!singletonInstance)
    {
        singletonInstance = [[[self class] alloc] init];
    }
    return singletonInstance;
}

- (void)performTimetableSearch:(NSDictionary *)params {
   // [LRResty client] get:@"" parameters:<#(NSDictionary *)#> headers://
    //<#(NSDictionary *)#> delegate:<#(id<LRRestyClientResponseDelegate>)#>
    
}

#pragma mark - LRRestyClientResponseDelegate

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response
{
    NSData *data = [response responseData];
    
    NSDictionary *jsonDictionary = [data yajl_JSON];
    NSArray *propertiesArray = [jsonDictionary valueForKey:@"properties"];
    
    NSMutableArray *newProperties = [NSMutableArray array];
    for (NSDictionary *dict in propertiesArray)
    {
        Property *property = [Property propertyWithDictionary:dict];
        [newProperties addObject:property];
    }
    
    self.properties = newProperties;
}


@end
