//
//  Notes.h
//  project
//
//  Created by Yeshu Liu on 5/10/11.
//  Copyright (c) 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notes : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * note_title;
@property (nonatomic, retain) NSString * note_text;
@property (nonatomic, retain) NSNumber * note_id;
@property (nonatomic, retain) NSString * note_time;

@end
