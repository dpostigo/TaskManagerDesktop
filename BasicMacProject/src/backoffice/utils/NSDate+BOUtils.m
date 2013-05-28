//
// Created by Daniela Postigo on 5/10/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDate+BOUtils.h"
#import "NSDate+JMSimpleDate.h"
#import "TTTTimeIntervalFormatter.h"
#import "NSString+Utils.h"


#define DATESLUG_TODAY @"Today"
#define DATESLUG_TOMORROW @"Tomorrow"
#define DATESLUG_YESTERDAY @"Yesterday"


@implementation NSDate (BOUtils)


- (NSString *) detailString {
    if (self == nil) return @" ";

    NSString *ret = @"";
    TTTTimeIntervalFormatter *formatter = [[TTTTimeIntervalFormatter alloc] init];
    NSDate *today = [NSDate date];

    NSInteger daysBeforeToday = [self daysBeforeDate: today];

    if (daysBeforeToday == 0) ret = DATESLUG_TODAY;
    else if (daysBeforeToday < 0) {
        if (daysBeforeToday == -1) {
            ret = DATESLUG_TOMORROW;
        } else {
            ret = [NSString stringWithFormat: @"%li days", daysBeforeToday * -1];
        }
    } else {
        if (daysBeforeToday == 1) {
            ret = DATESLUG_YESTERDAY;
        } else {
            ret = [NSString stringWithFormat: @"%li days ago", [self daysBeforeDate: today]];
        }
    }
    return ret;
}

- (BOOL) isOverdue {
    BOOL ret = NO;
    NSString *dateString = self.detailString;
    if ([dateString isEqualToString: DATESLUG_TODAY] || [dateString isEqualToString: DATESLUG_TOMORROW] || ![dateString containsString: @"ago"]) {
        ret = NO;
    } else {
        ret = YES;
    }
    return ret;
}

- (TaskDateType) taskDateType {
    TaskDateType ret = TaskDateTypeNone;
    NSString *dateString = self.detailString;

    if ([dateString isEqualToString: DATESLUG_TODAY]) {
        ret = TaskDateTypeToday;
    } else if ([dateString isEqualToString: DATESLUG_YESTERDAY] || [dateString containsString: @"ago"]) {
        ret = TaskDateTypeOverdue;
    }
    return ret;
}
@end