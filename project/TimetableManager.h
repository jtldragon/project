//
//  TimetableManager.h
//  project
//
//  Created by Yeshu Liu on 26/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LRResty/LRResty.h>

#import "Timetable.h"

@interface TimetableManager : NSObject <LRRestyClientResponseDelegate> {
    NSArray *tablesArray;
}

+ (TimetableManager *)sharedPropertyManager;

@property (nonatomic, retain) NSArray *tablesArray;



@end