//
// Created by Daniela Postigo on 5/10/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GetAssigneeProcess.h"
#import "ASIFormDataRequest.h"
#import "ServiceItem.h"


@implementation GetAssigneeProcess {
}


@synthesize jobId;

- (id) initWithJobId: (NSString *) ajobId {
    self = [super init];
    if (self) {
        self.jobId = ajobId;
    }

    return self;
}

- (void) main {
    [super main];

    NSLog(@"%s", __PRETTY_FUNCTION__);

    self.urlString = [NSString stringWithFormat: @"%@/jobs/%@/jobs_people.json", STAGING_URL, jobId];
    self.url = [NSURL URLWithString: urlString];

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    request.requestMethod = @"GET";
    [request addRequestHeader: @"Content-Type" value: @ "application/json"];
    NSLog(@"%@ initialized.", NSStringFromClass([self class]));
    [request startSynchronous];

    if (!request.error) {

        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: request.responseData options: kNilOptions error: &error];

        if (dictionary == nil) {
            NSLog(@"%@ failed.", NSStringFromClass([self class]));
        } else {

            NSLog(@"%@ succeeded.", NSStringFromClass([self class]));
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in dictionary) {
                User *user = [[User alloc] initWithDictionary: [dict objectForKey: @"contact"]];
                [array addObject: user];
            }

            [_model notifyDelegates: @selector(fetchedAssignees:forJobId:) object: array andObject: jobId];
        }
    }
}

@end