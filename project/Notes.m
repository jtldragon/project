//
//  Notes.m
//  project
//
//  Created by Yeshu Liu on 27/09/11.
//  Copyright (c) 2011 RMIT. All rights reserved.
//

#import "Notes.h"


@implementation Notes
@dynamic note_id;
@dynamic note_text;
@dynamic course_id;
@dynamic courses;

- (void)addCoursesObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"courses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"courses"] addObject:value];
    [self didChangeValueForKey:@"courses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeCoursesObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"courses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"courses"] removeObject:value];
    [self didChangeValueForKey:@"courses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addCourses:(NSSet *)value {    
    [self willChangeValueForKey:@"courses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"courses"] unionSet:value];
    [self didChangeValueForKey:@"courses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeCourses:(NSSet *)value {
    [self willChangeValueForKey:@"courses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"courses"] minusSet:value];
    [self didChangeValueForKey:@"courses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
