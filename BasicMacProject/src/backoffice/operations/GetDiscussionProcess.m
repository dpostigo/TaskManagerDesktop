//
// Created by Daniela Postigo on 5/12/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GetDiscussionProcess.h"
#import "ASIFormDataRequest.h"
#import "DiscussionItem.h"


@implementation GetDiscussionProcess {
}


@synthesize task;

- (id) initWithTask: (Task *) aTask {
    self = [super init];
    if (self) {
        self.task = aTask;
    }

    return self;
}

- (void) main {
    [super main];

    self.urlString = [NSString stringWithFormat: @"%@/tasks/%@/comments.json", STAGING_URL, task.id];
    self.url = [NSURL URLWithString: urlString];

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    request.requestMethod = @"GET";
    [request addRequestHeader: @"Content-Type" value: @ "application/json"];
    [request startSynchronous];

    if (!request.error) {

        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: request.responseData options: kNilOptions error: &error];

        if (dictionary == nil) {
            NSLog(@"%@ failed.", NSStringFromClass([self class]));
        } else {
            NSLog(@"%@ succeeded.", NSStringFromClass([self class]));
            task.discussion = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in dictionary) {
                DiscussionItem *item = [[DiscussionItem alloc] initWithDictionary: dict];
                [task.discussion addObject: item];
            }
            [_model notifyDelegates: @selector(discussionDidUpdateForTask:) object: task];
        }
    }
}

@end