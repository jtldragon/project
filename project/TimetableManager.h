//
//  TimetableManager.h
//  project
//
//  Created by Yeshu Liu on 1/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LRResty/LRResty.h>



@interface TimetableManager : NSObject <LRRestyClientResponseDelegate>

+ (TimetableManager *)sharedTimetableManager;

//@property (nonatomic, retain) Property *selectedProperty;
@property (nonatomic, retain) NSArray *timetables;

- (void)performSearch:(NSDictionary *)params;

@end
