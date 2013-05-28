//
// Created by Daniela Postigo on 5/10/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CreateTaskOperation.h"
#import "ASIFormDataRequest.h"
#import "Task.h"


@implementation CreateTaskOperation {
}


@synthesize taskDictionary;
@synthesize taskObservers;

- (id) initWithTaskDictionary: (NSDictionary *) aTaskDictionary taskObservers: (NSMutableArray *) aTaskObservers {
    self = [super init];
    if (self) {
        self.taskDictionary = aTaskDictionary;
        self.taskObservers = aTaskObservers;
    }
    return self;
}

- (void) main {
    [super main];

    self.urlString = [NSString stringWithFormat: @"%@/tasks.json", STAGING_URL];
    self.url = [NSURL URLWithString: urlString];

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    request.requestMethod = @"POST";
    [request addRequestHeader: @"Content-Type" value: @ "application/json"];

    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject: taskDictionary forKey: @"task"];
    [jsonDict setObject: _model.currentUser.id forKey: @"contact_id"];
    if (taskObservers) [jsonDict setObject: taskObservers forKey: @"task_observers"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: jsonDict options: kNilOptions error: nil];
    NSString *jsonString = [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
    NSLog(@"JSON String: %@", jsonString);

    NSString *postStr = [NSString stringWithFormat: @"%@", jsonString];

    [request appendPostData: [postStr dataUsingEncoding: NSUTF8StringEncoding]];

    //    [request setPostValue: taskDictionary forKey: @"task"];
    //    [request setPostValue: _model.currentUser.id forKey: @"contact_id"];
    //    if (taskObservers != nil) [request setPostValue: taskObservers forKey: @"task_observers"];

    [request startSynchronous];

    if (!request.error) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: request.responseData options: kNilOptions error: &error];
        if (dictionary == nil) {
            NSLog(@"%@ failed.", NSStringFromClass([self class]));
        } else {
            NSLog(@"%@ succeeded.", NSStringFromClass([self class]));
            Task *task = [[Task alloc] initWithDictionary: dictionary];
            [_model.tasks addObject: task];
            _model.currentNewTask = task;
            [_model notifyDelegates: @selector(didCreateTask:) object: task];
        }
    }
}

@end