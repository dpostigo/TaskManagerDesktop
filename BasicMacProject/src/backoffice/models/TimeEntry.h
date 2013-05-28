//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface TimeEntry : NSObject <NSCoding> {

    NSDate *timeStarted;
    NSDate *timeEnded;
    NSString *projectId;

}


@property(nonatomic, strong) NSDate *timeStarted;
@property(nonatomic, strong) NSDate *timeEnded;
@property(nonatomic, strong) NSString *projectId;

- (id) initWithTimeStarted: (NSDate *) aTimeStarted;
- (id) initWithTimeStarted: (NSDate *) aTimeStarted projectId: (NSString *) aProjectId;

@end