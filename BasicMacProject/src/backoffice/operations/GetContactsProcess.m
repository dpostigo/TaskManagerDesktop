//
// Created by Daniela Postigo on 5/10/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GetContactsProcess.h"
#import "ASIFormDataRequest.h"


@implementation GetContactsProcess {
}


- (void) main {
    [super main];

    self.urlString = [NSString stringWithFormat: @"%@/contacts.json", STAGING_URL];
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
            _model.contacts = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in dictionary) {
                User *user = [[User alloc] initWithDictionary: dict];
                [_model.contacts addObject: user];
            }

            [_model notifyDelegates: @selector(contactsDidUpdate) object: nil];
        }
    }
}

@end