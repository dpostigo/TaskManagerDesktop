//
// Created by Daniela Postigo on 5/12/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicObject.h"
#import "User.h"


@interface DiscussionItem : BasicObject {

NSDate *createdDate;
NSString *text;
NSMutableArray *attachments;
User *contact;
NSString *contactId;


}


@property(nonatomic, strong) NSDate *createdDate;
@property(nonatomic, retain) NSString *text;
@property(nonatomic, strong) NSMutableArray *attachments;
@property(nonatomic, strong) User *contact;
@property(nonatomic, retain) NSString *contactId;
- (id) initWithDictionary: (NSDictionary *) dictionary;
@end