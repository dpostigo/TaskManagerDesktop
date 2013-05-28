//
// Created by Daniela Postigo on 5/13/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicBackOfficeOperation.h"
#import "DiscussionItem.h"


@interface PostCommentOperation : BasicBackOfficeOperation {
    Task *task;
    DiscussionItem *discussionItem;
}


@property(nonatomic, strong) Task *task;
@property(nonatomic, strong) DiscussionItem *discussionItem;
- (id) initWithTask: (Task *) aTask discussionItem: (DiscussionItem *) anItem;
@end