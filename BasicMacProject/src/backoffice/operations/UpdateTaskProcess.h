//
// Created by Daniela Postigo on 5/12/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicBackOfficeOperation.h"


@interface UpdateTaskProcess : BasicBackOfficeOperation {
    Task *task;
}


@property(nonatomic, strong) Task *task;
- (id) initWithTask: (Task *) aTask;

@end