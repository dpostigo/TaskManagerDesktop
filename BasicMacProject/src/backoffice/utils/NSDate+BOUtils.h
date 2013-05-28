//
// Created by Daniela Postigo on 5/10/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


typedef enum {
    TaskDateTypeNone = 0,
    TaskDateTypeOverdue = 1,
    TaskDateTypeToday = 2
} TaskDateType;


@interface NSDate (BOUtils)


- (NSString *) detailString;
- (BOOL) isOverdue;
- (TaskDateType) taskDateType;
@end