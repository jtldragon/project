//
//  LocationManager.h
//  project
//
//  Created by Yeshu Liu on 2/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <LRResty/LRResty.h>



@interface LocationManager : NSObject <LRRestyClientResponseDelegate>

+ (LocationManager *)sharedLocationManager;

//@property (nonatomic, retain) Property *selectedProperty;
@property (nonatomic, retain) NSArray *locations;

- (NSArray *)performSearch:(NSDictionary *)params;


@end
