//
//  Student.h
//  project
//
//  Created by Yeshu Liu on 23/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Student : NSManagedObject {
    NSString *studentno;
   //NSDate *date;
    
}
@property(nonatomic,retain)NSString *studentno;
//@property(nonatomic,retain)NSDate *date;

@end
