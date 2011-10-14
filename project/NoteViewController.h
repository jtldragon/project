//
//  NoteViewController.h
//  project
//
//  Created by Yeshu Liu on 5/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectAppDelegate.h"


@interface NoteViewController : UIViewController <NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource> {
    projectAppDelegate *delegate;
    IBOutlet UIView *newNote;
}



//@property (nonatomic, retain) NSArray *notesArray;
@property (nonatomic, retain) NSMutableArray *notes;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,retain) IBOutlet UIView *newNote;
@property(nonatomic,assign) BOOL isInAddMode;
@property(nonatomic,assign) BOOL isInEditMode;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *addButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *editButton;
@property(nonatomic,retain) IBOutlet UITextView *textview;
@property(nonatomic,retain) IBOutlet UITextField *titleField;
@property (nonatomic,retain)IBOutlet UITableView *mytableView;



-(void)toggleView;
- (IBAction)textFieldDoneEditing:(id)sender;

@end