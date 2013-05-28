//
// Created by Daniela Postigo on 5/12/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UpdateTaskProcess.h"
#import "ASIFormDataRequest.h"


@implementation UpdateTaskProcess {
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

    self.urlString = [NSString stringWithFormat: @"%@/tasks/%@.json", STAGING_URL, task.id];
    self.url = [NSURL URLWithString: urlString];

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    request.requestMethod = @"PUT";
    [request addRequestHeader: @"Content-Type" value: @ "application/json"];

    NSMutableDictionary *taskDictionary = [[NSMutableDictionary alloc] init];
    [taskDictionary setObject: task.title forKey: @"task"];
    if (task.startDate) [taskDictionary setObject: [_model.defaultFormatter stringFromDate: task.startDate] forKey: @"start_date"];
    if (task.dueDate) [taskDictionary setObject: [_model.defaultFormatter stringFromDate: task.dueDate] forKey: @"due_date"];
    [taskDictionary setObject: task.job.id forKey: @"job_id"];
    [taskDictionary setObject: task.serviceItem.id forKey: @"service_item_id"];
    [taskDictionary setObject: task.assignee.id forKey: @"contact_id"];
    if (task.notes) [taskDictionary setObject: task.notes forKey: @"notes"];

    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject: taskDictionary forKey: @"task"];
    [jsonDict setObject: task.observerIds forKey: @"task_observers"];
    [jsonDict setObject: _model.currentUser.id forKey: @"contact_id"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: jsonDict options: kNilOptions error: nil];
    NSString *jsonString = [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
    NSString *postStr = [NSString stringWithFormat: @"%@", jsonString];
    [request appendPostData: [postStr dataUsingEncoding: NSUTF8StringEncoding]];
    [request startSynchronous];

    if (!request.error) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: request.responseData options: kNilOptions error: &error];
        if (dictionary == nil) {
            NSLog(@"%@ failed.", NSStringFromClass([self class]));
        } else {
            NSLog(@"%@ succeeded.", NSStringFromClass([self class]));
            NSLog(@"dictionary = %@", dictionary);
            [_model notifyDelegates: @selector(taskDidUpdate:) object: task];
        }
    }
}
@end