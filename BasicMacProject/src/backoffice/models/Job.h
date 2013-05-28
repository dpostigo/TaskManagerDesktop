//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicObject.h"


#define JOBTYPE_POTENTIAL @"Potential"
#define JOBTYPE_QUOTE @"Quote"
#define JOBTYPE_ACTIVE @"Active"


@interface Job : BasicObject {
    NSString *jobNumber;
    NSString *status;
}


@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSString *jobNumber;
- (id) initWithDictionary: (NSDictionary *) dictionary;
@end