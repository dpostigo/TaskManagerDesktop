//
// Created by Daniela Postigo on 5/12/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicTableArrayController.h"
#import "TaskInfoViewController.h"
#import "TaskDetailViewController.h"


@interface TaskDiscussionViewController : BasicTableViewController <BasicTextFieldDelegate> {
    __unsafe_unretained TaskDetailViewController *detailController;
}


@property(nonatomic, assign) TaskDetailViewController *detailController;
- (IBAction) handlePostButton: (id) sender;
@end