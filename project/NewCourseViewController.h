//
//  NewCourseViewController.h
//  project
//
//  Created by Yeshu Liu on 27/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectAppDelegate.h"


@interface NewCourseViewController : UIViewController {
    IBOutlet UIButton *button_cancel;
    IBOutlet UIButton *button_save;
    IBOutlet UITextView *textview_descrip;
    IBOutlet UITextField *textfield_name;
    projectAppDelegate *delegate;
    
    
    
}
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender; 
- (IBAction)backgroundTouched:(id)sender;

@property(nonatomic,retain)IBOutlet UIButton *button_cancel;
@property(nonatomic,retain)IBOutlet UIButton *button_save;
@property(nonatomic,retain)IBOutlet UITextView *textview_descrip;
@property(nonatomic, retain)IBOutlet UITextField *textfield_name;


@end