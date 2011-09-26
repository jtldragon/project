//
//  Timetable.m
//  project
//
//  Created by Yeshu Liu on 26/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "Timetable.h"


@implementation Timetable

@synthesize classTitle,startTime,endTime,location,campus,type;

-(id)initWithClass:(NSString *)newClassTitle
         startTime:(NSString *)newStartTime 
           endTime:(NSString *)newEndTime 
          location:(NSString *)newLocation 
            campus:(NSString *)newCampus 
              type:(NSString *)newType {
    self=[super init];
    if(self!=nil)
    {
        [self setClassTitle:newClassTitle];
        [self setStartTime:newStartTime];
        [self setEndTime:newEndTime];
        [self setLocation:newLocation];
        [self setCampus:newCampus];
        [self setType:newType];
    }
    return self;
    
}

-(void)dealloc
{
    [super dealloc];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Class:%@\n Start From:%@\n To:%@ At:%@\n In:%@\n Type:%@\n",classTitle,startTime,endTime,location,campus,type];
}

@end