//
// Created by Daniela Postigo on 5/11/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicBackOfficeOperation.h"
#import "Task.h"


@interface CompleteTaskProcess : BasicBackOfficeOperation {

    NSString *taskId;
    NSDate *completedDate;
    CGFloat taskTime;
    Task *task;
}


@property(nonatomic, retain) NSString *taskId;
@property(nonatomic, strong) NSDate *completedDate;
@property(nonatomic) CGFloat taskTime;
@property(nonatomic, strong) Task *task;
- (id) initWithTask: (Task *) aTask completedDate: (NSDate *) aCompletedDate;

@end