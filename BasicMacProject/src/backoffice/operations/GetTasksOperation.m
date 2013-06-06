//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GetTasksOperation.h"
#import "ASIFormDataRequest.h"
#import "Task.h"
#import "NSDate+JMSimpleDate.h"


@implementation GetTasksOperation {
}


- (BOOL) isConcurrent {
    return YES;
}


- (void) main {
    [super main];

    if (!_model.loggedIn) return;

    self.urlString = [NSString stringWithFormat: @"%@/tasks.json?contact_id=%@", STAGING_URL, _model.currentUser.id];
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


            [self handleTasks: dictionary];
            [self handleJobs];


            [_model notifyDelegates: @selector(getTasksSucceeded) object: nil];
        }
    }
}


- (void) handleJobs {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableArray *jobs = [[NSMutableArray alloc] init];
    NSMutableArray *jobIds = [[NSMutableArray alloc] init];
    for (Task *task in _model.tasks) {
        Job *job = task.job;
        if (![jobIds containsObject: job.id]) {
            [jobIds addObject: job.id];
            [jobs addObject: job];
        }
    }
    _model.jobs = [[NSMutableArray alloc] initWithArray: jobs];

}

- (void) handleTasks: (NSDictionary *) dictionary {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSMutableArray *tasks = [[NSMutableArray alloc] init];
    for (NSDictionary *taskDict in dictionary) {
        Task *task = [[Task alloc] initWithDictionary: taskDict];
        [tasks addObject: task];
    }

    [tasks sortUsingComparator:
            ^NSComparisonResult(id obj1, id obj2) {
                Task *task1 = obj1;
                Task *task2 = obj2;

                NSDate *date1 = task1.dueDate;
                NSDate *date2 = task2.dueDate;

                NSComparisonResult result = NSOrderedSame;
                if (task1.dueDate == nil || task2.dueDate == nil) {

                    if (date1 == nil && date2 == nil) {
                        result = NSOrderedSame;
                    }
                    else if (task1.dueDate == nil && task2.dueDate != nil) {
                        result = NSOrderedDescending;
                    } else if (task1.dueDate != nil && task2.dueDate == nil) {
                        result = NSOrderedAscending;
                    }
                } else {

                    if ([date1 isOnSameDate: date2 ignoringTimeOfDay: YES]) result = NSOrderedSame;

                    else if ([date1 isLaterThanDate: date2]) {
                        result = NSOrderedDescending;
                    } else if ([date1 isEarlierThanDate: date2]) {
                        result = NSOrderedAscending;
                    }
                }
                return result;
            }
    ];


    _model.tasks = [[NSMutableArray alloc] initWithArray: tasks];


}

@end