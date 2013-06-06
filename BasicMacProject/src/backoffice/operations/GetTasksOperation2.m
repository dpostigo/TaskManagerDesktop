//
//  GetTasksOperation2.m
//  TaskManager
//
//  Created by Daniela Postigo on 5/31/13.
//  Copyright 2013 Dani Postigo. All rights reserved.
//

#import "GetTasksOperation2.h"


@implementation GetTasksOperation2 {

}

- (id) initWithURL: (NSURL *) newURL {
    self = [super initWithURL: newURL];
    if (self) {

        self.requestMethod = @"GET";
        [self addRequestHeader: @"Content-Type" value: @ "application/json"];
        [self setCompletionBlock: ^{
            NSLog(@"Complete");
        }];

    }

    return self;
}


@end