//
// Created by Daniela Postigo on 5/10/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GetServiceItemsOperation.h"
#import "ASIFormDataRequest.h"
#import "ServiceItem.h"


@implementation GetServiceItemsOperation {
}


- (void) main {
    [super main];

    self.urlString = [NSString stringWithFormat: @"%@/service_items.json", STAGING_URL];
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
            _model.serviceItems = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in dictionary) {
                ServiceItem *serviceItem = [[ServiceItem alloc] initWithDictionary: dict];
                [_model.serviceItems addObject: serviceItem];
            }

            [_model notifyDelegates: @selector(serviceItemsDidUpdate) object: nil];
        }
    }
}

@end