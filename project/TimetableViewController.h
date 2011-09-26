//
//  TimetableViewController.h
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TimetableViewController : UIViewController {
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIBarButtonItem *resultButton;
    
}

-(IBAction)getTimetable:(id)sender;


@property(nonatomic,retain) IBOutlet UIDatePicker *datePicker;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *resultButton;


@end
