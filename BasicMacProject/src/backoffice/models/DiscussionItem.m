//
// Created by Daniela Postigo on 5/12/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DiscussionItem.h"
#import "Model.h"


@implementation DiscussionItem {
}


@synthesize createdDate;
@synthesize text;
@synthesize attachments;
@synthesize contact;

@synthesize contactId;

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {

        self.id = [dictionary objectForKey: @"id"];
        self.text = [dictionary objectForKey: @"comment_text"];
        self.contactId = [NSString stringWithFormat: @"%@", [dictionary objectForKey: @"contact_id"]];
        self.contact = [[Model sharedModel] contactForId: contactId];

        self.createdDate = [[Model sharedModel].defaultFormatter dateFromString: [dictionary objectForKey: @"created_at"]];
        self.attachments = [[NSMutableArray alloc] init];
    }

    return self;
}

@end