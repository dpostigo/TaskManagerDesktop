//
// Created by Daniela Postigo on 5/10/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicBackOfficeOperation.h"


@interface GetAssigneeProcess : BasicBackOfficeOperation {
    NSString *jobId;
}


@property(nonatomic, retain) NSString *jobId;
- (id) initWithJobId: (NSString *) jobId;

@end