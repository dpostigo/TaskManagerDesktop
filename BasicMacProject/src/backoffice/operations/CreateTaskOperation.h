//
// Created by Daniela Postigo on 5/10/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicBackOfficeOperation.h"


@interface CreateTaskOperation : BasicBackOfficeOperation {
    NSDictionary *taskDictionary;
    NSMutableArray *taskObservers;
}


@property(nonatomic, strong) NSDictionary *taskDictionary;
@property(nonatomic, strong) NSMutableArray *taskObservers;
- (id) initWithTaskDictionary: (NSDictionary *) aTaskDictionary taskObservers: (NSMutableArray *) aTaskObservers;

@end