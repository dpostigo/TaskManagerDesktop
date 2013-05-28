//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ServiceItem.h"


@implementation ServiceItem {
}


- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {

        self.id = [NSString stringWithFormat: @"%@", [dictionary objectForKey: @"id"]];
        self.title = [NSString stringWithFormat: @"%@", [dictionary objectForKey: @"name"]];
        self.hourlyRate = [[dictionary objectForKey: @"base_hourly_rate"] floatValue];
    }

    return self;
}

@end