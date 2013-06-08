//
// Created by Daniela Postigo on 5/13/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PostCommentOperation.h"
#import "ASIFormDataRequest.h"
#import "DiscussionItem.h"


@implementation PostCommentOperation {
}


@synthesize task;
@synthesize discussionItem;

- (id) initWithTask: (Task *) aTask discussionItem: (DiscussionItem *) anItem {
    self = [super init];
    if (self) {
        self.task = aTask;
        self.discussionItem = anItem;
    }

    return self;
}

- (void) main {
    [super main];

    [_model notifyDelegates: @selector(progressStatusBegan:) object: @"Posting comment..."];

    self.urlString = [NSString stringWithFormat: @"%@/task_comments.json", STAGING_URL];
    self.url = [NSURL URLWithString: urlString];

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    request.requestMethod = @"POST";
    [request addRequestHeader: @"Content-Type" value: @ "application/json"];

    NSMutableDictionary *commentDict = [[NSMutableDictionary alloc] init];
    [commentDict setObject: task.id forKey: @"task_id"];
    [commentDict setObject: _model.currentUser.id forKey: @"contact_id"];
    [commentDict setObject: discussionItem.text forKey: @"comment_text"];
    //    [commentDict setObject: attachments forKey: @"task_comment_attachments"];

    if (discussionItem.attachments && discussionItem.attachments.count > 0) {
        for (int j = 0; j < [discussionItem.attachments count]; j++) {
        }
    }

    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject: commentDict forKey: @"task_comment"];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: jsonDict options: kNilOptions error: nil];
    NSString *jsonString = [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];


    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *postStr = [NSString stringWithFormat: @"%@", jsonString];
    [request appendPostData: [postStr dataUsingEncoding: NSUTF8StringEncoding]];
    [request startSynchronous];

    if (!request.error) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: request.responseData options: kNilOptions error: &error];
        if (dictionary == nil) {
            NSLog(@"%@ failed.", NSStringFromClass([self class]));
            [self operationSucceededWithString: @"Post comment failed."];
        } else {
            NSLog(@"%@ succeeded.", NSStringFromClass([self class]));
            [self operationSucceededWithString: @"Post comment succeeded."];


            DiscussionItem *item = [[DiscussionItem alloc] initWithDictionary: dictionary];
            [_model notifyDelegates: @selector(taskUpdated:discussionItem:) object: task andObject: item];
        }
    }
}

@end