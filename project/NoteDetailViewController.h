//
//  NoteDetailViewController.h
//  project
//
//  Created by Yeshu Liu on 5/10/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notes.h"

@interface NoteDetailViewController : UIViewController {
    
}
-(id)initWithNote:(NSManagedObject *)anote;
@property (nonatomic,retain)Notes *note;
@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UILabel *timeLabel;
@property (nonatomic,retain)IBOutlet UITextView *textLabel;

@end
