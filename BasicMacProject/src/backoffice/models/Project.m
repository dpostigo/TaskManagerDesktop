//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Project.h"
#import "TimeEntry.h"


@implementation Project {
}


@synthesize title;
@synthesize dateAdded;
@synthesize timeEntries;
@synthesize projectId;


- (id) initWithTitle: (NSString *) aTitle {
    self = [super init];
    if (self) {
        title = aTitle;
        dateAdded = [NSDate date];

        self.timeEntries = [[NSMutableArray alloc] init];
    }

    return self;
}


- (void) encodeWithCoder: (NSCoder *) aCoder {
    [aCoder encodeObject: self.title forKey: @"title"];
    [aCoder encodeObject: self.dateAdded forKey: @"dateAdded"];



    for (TimeEntry *timeEntry in self.timeEntries) {
        timeEntry.projectId = self.projectId;
    }


    [aCoder encodeObject: self.timeEntries forKey:@"timeEntries"];
    [aCoder encodeObject: self.projectId forKey:@"projectId"];
}


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey: @"title"];
        self.dateAdded = [aDecoder decodeObjectForKey: @"dateAdded"];
        self.timeEntries = [[NSMutableArray alloc] init];
        [self.timeEntries addObjectsFromArray: [aDecoder decodeObjectForKey: @"timeEntries"]];
        self.projectId = [aDecoder decodeObjectForKey: @"projectId"];
    }

    return self;
}


- (TimeEntry *) currentTimeEntry {
    return [timeEntries lastObject];
}

@end