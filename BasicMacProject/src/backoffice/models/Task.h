//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicObject.h"
#import "User.h"
#import "ServiceItem.h"
#import "Job.h"


@interface Task : BasicObject {

    User *assignee;
    Job *job;
    NSMutableArray *observerIds;
    NSString *addedById;
    NSString *notes;
    NSString *dueDateString;
    NSString *startDateString;
    NSString *completedDateString;
    ServiceItem *serviceItem;

    NSDate *dueDate;
    NSDate *startDate;
    NSDate *completedDate;

    NSMutableArray *discussion;
}


@property(nonatomic, strong) Job *job;
@property(nonatomic, strong) User *assignee;
@property(nonatomic, strong) ServiceItem *serviceItem;
@property(nonatomic, retain) NSString *addedById;
@property(nonatomic, retain) NSString *notes;
@property(nonatomic, strong) NSMutableArray *observerIds;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *dueDate;
@property(nonatomic, strong) NSDate *completedDate;
@property(nonatomic, strong) NSMutableArray *discussion;
- (id) initWithDictionary: (NSDictionary *) dictionary;
@end