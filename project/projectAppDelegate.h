//
//  projectAppDelegate.h
//  project
//
//  Created by Yeshu Liu on 22/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface projectAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
