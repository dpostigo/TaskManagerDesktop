//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Task.h"


@implementation Task {
}


@synthesize assignee;
@synthesize serviceItem;
@synthesize addedById;
@synthesize notes;
@synthesize job;
@synthesize observerIds;
@synthesize startDate;
@synthesize dueDate;
@synthesize completedDate;

@synthesize discussion;

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {

        self.addedById = [dictionary objectForKey: @"added_by"];
        self.assignee = [[User alloc] initWithDictionary: [dictionary objectForKey: @"contact"]];
        dueDateString = [dictionary objectForKey: @"due_date"];
        self.id = [NSString stringWithFormat: @"%@", [dictionary objectForKey: @"id"]];
        self.job = [[Job alloc] initWithDictionary: [dictionary objectForKey: @"job"]];
        self.notes = [dictionary objectForKey: @"notes"];
        self.serviceItem = [[ServiceItem alloc] initWithDictionary: [dictionary objectForKey: @"service_item"]];
        startDateString = [dictionary objectForKey: @"start_date"];
        self.title = [dictionary objectForKey: @"task"];
        self.observerIds = [self safeArrayForKey: @"task_observers" inDictionary: dictionary];

        dueDateString = [dueDateString isEqual: [NSNull null]] ? nil : dueDateString;
        startDateString = [startDateString isEqual: [NSNull null]] ? nil : startDateString;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";

        if (dueDateString) self.dueDate = [formatter dateFromString: dueDateString];
        if (startDateString) self.startDate = [formatter dateFromString: startDateString];
    }

    return self;
}

- (NSMutableArray *) safeArrayForKey: (NSString *) key inDictionary: (NSDictionary *) dictionary {
    NSArray *array = [dictionary objectForKey: @"task_observers"];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (int j = 0; j < [array count]; j++) {
        id object = [array objectAtIndex: j];
        NSString *stringValue = [object stringValue];
        [ret addObject: stringValue];
    }

    return ret;
}
@end