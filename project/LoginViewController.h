//
//  LoginViewController.h
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectAppDelegate.h"


@interface LoginViewController : UIViewController <NSFetchedResultsControllerDelegate>{
    IBOutlet UIButton *button;
    IBOutlet UITextField *textfield;
    NSString *studentNumber;
    projectAppDelegate *delegate;
    NSFetchedResultsController *_fetchResultsController;
    NSManagedObjectContext *_context;
    NSArray *resultArray;
    
    
}
- (IBAction)done:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender; 
- (IBAction)backgroundTouched:(id)sender;

@property(nonatomic,retain)IBOutlet UIButton *button;
@property(nonatomic,retain)IBOutlet UITextField *textfield;
@property(nonatomic,retain)NSString *studentNumber;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *context;
@property(nonatomic,retain)NSArray *resultArray;


@end
