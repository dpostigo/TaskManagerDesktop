//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Job.h"


@implementation Job {
}


@synthesize status;

@synthesize jobNumber;

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.id = [NSString stringWithFormat: @"%@", [dictionary objectForKey: @"id"]];
        self.title = [dictionary objectForKey: @"job_name"];
        self.status = [[dictionary objectForKey: @"job_status"] objectForKey: @"status_name"];
        self.jobNumber = [dictionary objectForKey: @"job_number"];
    }

    return self;
}

@end