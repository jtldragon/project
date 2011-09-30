//
//  Notes.h
//  project
//
//  Created by Yeshu Liu on 27/09/11.
//  Copyright (c) 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notes : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * note_id;
@property (nonatomic, retain) NSString * note_text;
@property (nonatomic, retain) NSNumber * course_id;
@property (nonatomic, retain) NSSet* courses;

@end
