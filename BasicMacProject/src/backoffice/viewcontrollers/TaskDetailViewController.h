//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "BasicSplitViewController.h"
#import "SplitViewContainer.h"


@interface TaskDetailViewController : BasicSplitViewController <NSSplitViewDelegate> {
    IBOutlet SplitViewContainer *infoContainer;
    IBOutlet SplitViewContainer *discussionContainer;
    BOOL isOpen;
}


@property(nonatomic) BOOL isOpen;
- (void) toggleTaskDetails: (id) sender;
- (void) openTaskDetails: (id) sender;
- (void) closeTaskDetails: (id) sender;
@end