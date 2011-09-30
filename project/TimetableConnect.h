//
//  TimetableConnect.h
//  project
//
//  Created by Yeshu Liu on 30/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SAMPLE_URL @"https://announcements.mobile-test.its.rmit.edu.au/studentwebservices/rest/timetable/studentId"
@interface TimetableConnect : NSObject {
    NSArray *timeParams;
    NSString *urlString;
    NSURLConnection *connection;
    NSMutableData *jsonData;
    
}

-(id)initWithParams:(NSArray *)params;
-(void)dealloc;
-(NSString *)description;
-(void)makeRequest;

@property (nonatomic,retain)NSArray *timeParams;
@property (nonatomic,retain)NSString *urlString;
@property (nonatomic,retain)NSURLConnection *connection;
@property (nonatomic,retain)NSMutableData *jsonData;



@end
