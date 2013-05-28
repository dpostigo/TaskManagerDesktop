//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "User.h"


@implementation User {
}


@synthesize userType;

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {

        self.id = [NSString stringWithFormat: @"%@", [dictionary objectForKey: @"id"]];
        self.firstName = [dictionary objectForKey: @"first_name"];
        self.lastName = [dictionary objectForKey: @"last_name"];
        self.username = [dictionary objectForKey: @"primary_email"];
        self.thumbnailURL = [dictionary objectForKey: @"avatar_url"];

        self.userType = [[dictionary objectForKey: @"contact_type"] objectForKey: @"name"];
        self.displayName = [NSString stringWithFormat: @"%@ %@", firstName, lastName];
        self.title = self.displayName;
    }
    return self;
}

@end