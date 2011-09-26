//
//  Timetable.h
//  project
//
//  Created by Yeshu Liu on 26/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Timetable : NSObject {
    
    NSString *classTitle;
    NSString *startTime;
    NSString *endTime;
    NSString *location;
    NSString *campus;
    NSString *type;
    
}

-(id)initWithClass:(NSString *)newClassTitle 
         startTime:(NSString *)newStartTime
           endTime:(NSString *)newEndTime
          location:(NSString *)newLocation
            campus:(NSString *)newCampus
              type:(NSString *)newType;




-(void)dealloc;
-(NSString *)description;

@property(nonatomic,retain)NSString *classTitle;
@property(nonatomic,assign)NSString *startTime;
@property(nonatomic,retain)NSString *endTime;
@property(nonatomic,retain)NSString *location;
@property(nonatomic,retain)NSString *campus;
@property(nonatomic,retain)NSString *type;



@end
