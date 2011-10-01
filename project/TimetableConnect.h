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
    NSMutableArray *timetablesArray;
    NSMutableArray *lectures;
    BOOL connIsFin;
    
    
}

-(id)initWithParams:(NSArray *)params;
-(void)dealloc;
-(NSString *)description;
-(void)makeRequest;
-(NSMutableArray *)getLectures;

@property (nonatomic,retain)NSArray *timeParams;
@property (nonatomic,retain)NSString *urlString;
@property (nonatomic,retain)NSURLConnection *connection;
@property (nonatomic,retain)NSMutableArray *timetablesArray;
@property (nonatomic,retain)NSMutableArray *lectures;
@property (nonatomic,assign)BOOL connIsFin;



@end
