//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TimeEntry.h"


@implementation TimeEntry {
}


@synthesize timeStarted;
@synthesize timeEnded;
@synthesize projectId;


- (id) initWithTimeStarted: (NSDate *) aTimeStarted {
    self = [super init];
    if (self) {
        timeStarted = aTimeStarted;
    }

    return self;
}

- (id) initWithTimeStarted: (NSDate *) aTimeStarted projectId: (NSString *) aProjectId {
    self = [super init];
    if (self) {
        timeStarted = aTimeStarted;
        projectId = aProjectId;
    }

    return self;
}


- (void) encodeWithCoder: (NSCoder *) aCoder {
    [aCoder encodeObject: self.timeStarted forKey: @"timeStarted"];
    [aCoder encodeObject: self.timeEnded forKey: @"timeEnded"];
    [aCoder encodeObject: self.projectId forKey: @"projectId"];
}


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super init];
    if (self) {
        self.timeStarted = [aDecoder decodeObjectForKey: @"timeStarted"];
        self.timeEnded = [aDecoder decodeObjectForKey: @"timeEnded"];
        self.projectId = [aDecoder decodeObjectForKey: @"projectId"];
    }

    return self;
}



@end