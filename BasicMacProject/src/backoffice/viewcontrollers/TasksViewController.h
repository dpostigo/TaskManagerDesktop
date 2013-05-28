//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicTableArrayController.h"
#import "Task.h"
#import "BasicOutlineViewController.h"


@interface TasksViewController : BasicOutlineViewController {
    Task *createdTask;
    NSString *taskMode;
}


@property(nonatomic, strong) Task *createdTask;
@property(nonatomic, retain) NSString *taskMode;
- (IBAction) handleAddTask: (id) sender;
- (IBAction) handleSettingsButton: (id) sender;
@end