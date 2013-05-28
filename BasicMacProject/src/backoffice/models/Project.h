//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@class TimeEntry;


@interface Project : NSObject <NSCoding> {

    NSString *projectId;
    NSString *title;
    NSDate *dateAdded;
    NSMutableArray *timeEntries;
}


@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSDate *dateAdded;
@property(nonatomic, strong) NSMutableArray *timeEntries;
@property(nonatomic, strong) NSString *projectId;
- (id) initWithTitle: (NSString *) aTitle;
- (TimeEntry *) currentTimeEntry;

@end