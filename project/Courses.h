//
//  Courses.h
//  project
//
//  Created by Yeshu Liu on 27/09/11.
//  Copyright (c) 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notes;

@interface Courses : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * course_id;
@property (nonatomic, retain) NSString * course_name;
@property (nonatomic, retain) NSString * course_description;
@property (nonatomic, retain) Notes * notes;

@end
