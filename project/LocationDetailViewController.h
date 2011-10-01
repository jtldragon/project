//
//  LocationDetailViewController.h
//  project
//
//  Created by Yeshu Liu on 2/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"


@interface LocationDetailViewController : UIViewController

-(id)initWithLocation:(Location *)loc;
    

@property (nonatomic, retain)Location *location;
@property (nonatomic, retain) IBOutlet UILabel *label_;
@property (nonatomic, retain) IBOutlet UILabel *location;
@property (nonatomic, retain) IBOutlet UIImageView *photo;
@property (nonatomic, retain) IBOutlet UILabel *summary;
@property (nonatomic, retain) IBOutlet UILabel *description;




@end
