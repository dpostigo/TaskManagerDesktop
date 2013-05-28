//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Model.h"
#import "Archiver.h"
#import "Job.h"
#import "Task.h"
#import "NSDate+JMSimpleDate.h"


@implementation Model {
}


@synthesize loggedIn;
@synthesize currentUser;
@synthesize tasks;
@synthesize jobs;
@synthesize currentJob;
@synthesize currentArtist;
@synthesize serviceItems;
@synthesize contacts;
@synthesize homeController;
@synthesize defaultFormatter;
@synthesize currentNewTask;
@synthesize selectedTask;
@synthesize slugFormatter;

@synthesize currentTaskMode;

+ (Model *) sharedModel {
    static Model *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (id) init {
    self = [super init];
    if (self) {
        self.loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey: @"loggedIn"];
        //        self.loggedIn = NO;
        self.currentUser = [Archiver retrieve: @"currentUser"];
        self.tasks = [Archiver retrieve: @"tasks"];
        self.jobs = [Archiver retrieve: @"jobs"];
        self.contacts = [Archiver retrieve: @"contacts"];
        self.serviceItems = [Archiver retrieve: @"serviceItems"];
        self.currentTaskMode = TASKLISTMODE_MYTASKS;
        if (self.currentUser == nil) self.loggedIn = NO;

        self.defaultFormatter = [[NSDateFormatter alloc] init];
        defaultFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
        self.slugFormatter = [[NSDateFormatter alloc] init];
        slugFormatter.dateFormat = @"MM/dd/yyyy";
    }

    return self;
}



#pragma mark Override setters

- (void) setSelectedTask: (Task *) selectedTask1 {
    selectedTask = selectedTask1;
    [self notifyDelegates: @selector(selectedTaskDidUpdate) object: nil];
}



#pragma mark Jobs



- (NSString *) jobIdForTitle: (NSString *) jobName {
    Job *job = [self jobForTitle: jobName];
    return job.id;
}

- (Job *) jobForTitle: (NSString *) jobName {
    for (Job *job in jobs) {
        if ([job.title isEqualToString: jobName]) {
            return job;
        }
    }
    return nil;
}

- (Job *) jobForId: (NSString *) jobId {
    for (Job *job in jobs) {
        if ([job.id isEqualToString: jobId]) {
            return job;
        }
    }
    return nil;
}

- (NSArray *) jobsWithStatus: (NSString *) status {
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"status MATCHES %@", status];
    NSArray *array = [jobs filteredArrayUsingPredicate: predicate];
    return array;
}

- (NSArray *) potentialJobs {
    return [self jobsWithStatus: JOBTYPE_POTENTIAL];
}

- (NSArray *) quoteJobs {
    return [self jobsWithStatus: JOBTYPE_QUOTE];
}

- (NSArray *) activeJobs {
    return [self jobsWithStatus: JOBTYPE_ACTIVE];
}

- (NSArray *) jobsForTaskArray: (NSArray *) taskArray {
    NSMutableArray *jobIds = [[NSMutableArray alloc] init];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (Task *task in taskArray) {

        if (![jobIds containsObject: task.job.id]) {
            [jobIds addObject: task.job.id];
            [ret addObject: task.job];
        }
    }
    return ret;
}

#pragma mark Tasks sorting


- (NSArray *) tasksForJobId: (NSString *) jobId {
    return [self tasksForJobId: jobId fromArray: tasks];
}

- (NSArray *) tasksForJobId: (NSString *) jobId fromArray: (NSArray *) taskArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Task *task in taskArray) {
        if ([task.job.id isEqualToString: jobId]) {
            [array addObject: task];
        }
    }
    return array;
}

- (NSString *) titleForMode: (NSString *) mode {
    if ([mode isEqualToString: TASKLISTMODE_JOBS]) {
        return self.currentJob.title;
    } else if ([mode isEqualToString: TASKLISTMODE_ARTISTS]) {
        return [NSString stringWithFormat: @"%@'s Tasks", self.currentArtist.title];
    }
    else return mode;
}

- (NSArray *) tasksForMode: (NSString *) mode {
    NSArray *array;
    NSPredicate *predicate;

    if ([mode isEqualToString: TASKLISTMODE_DUE]) {
        predicate = [NSPredicate predicateWithBlock: ^BOOL(id object, NSDictionary *bindings) {
            Task *task = object;
            return task.dueDate != nil && [task.dueDate isEarlierThanDate: [NSDate date]];
        }];
    } else if ([mode isEqualToString: TASKLISTMODE_TODAY]) {
        predicate = [NSPredicate predicateWithBlock: ^BOOL(id object, NSDictionary *bindings) {
            Task *task = object;
            return task.startDate != nil && task.startDate.isToday;
        }];
    } else if ([mode isEqualToString: TASKLISTMODE_OBSERVING]) {
        predicate = [NSPredicate predicateWithBlock: ^BOOL(id object, NSDictionary *bindings) {
            Task *task = object;
            return [task.observerIds containsObject: self.currentUser.id];
        }];
    } else if ([mode isEqualToString: TASKLISTMODE_MYTASKS]) {
        predicate = [NSPredicate predicateWithBlock: ^BOOL(id object, NSDictionary *bindings) {
            Task *task = object;
            return [task.assignee.id isEqualToString: self.currentUser.id];
        }];
    } else if ([mode isEqualToString: TASKLISTMODE_JOBS]) {
        predicate = [NSPredicate predicateWithBlock: ^BOOL(id object, NSDictionary *bindings) {
            Task *task = object;
            return [task.job.id isEqualToString: self.currentJob.id];
        }];
    } else if ([mode isEqualToString: TASKLISTMODE_ARTISTS]) {
        predicate = [NSPredicate predicateWithBlock: ^BOOL(id object, NSDictionary *bindings) {
            Task *task = object;
            return [task.assignee.id isEqualToString: self.currentArtist.id];
        }];
    }

    array = [tasks filteredArrayUsingPredicate: predicate];
    return array;
}



#pragma mark Users


- (NSArray *) artists {
    NSMutableArray *userIds = [[NSMutableArray alloc] init];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (Task *task in tasks) {
        if (![userIds containsObject: task.assignee.id]) {
            [userIds addObject: task.assignee.id];
            [ret addObject: task.assignee];
        }
    }
    return ret;
}

- (User *) contactForId: (NSString *) anId {
    if ([self.currentUser.id isEqualToString: anId]) {
        return currentUser;
    }
    for (User *user in contacts) {
        if ([user.id isEqualToString: anId]) {
            return user;
        }
    }
    return nil;
}

- (NSArray *) contactNames {
    return [self contactTitlesForContacts: self.contacts];
}

- (NSArray *) contactTitlesForContacts: (NSArray *) array {
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    for (User *user in array) {
        [ids addObject: user.id];
    }
    return [self contactTitlesForIds: ids];
}

- (NSArray *) contactTitlesForIds: (NSArray *) ids {
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    for (NSString *userId in ids) {
        User *user = [self contactForId: userId];
        [strings addObject: user.title];
    }
    return strings;
}

- (NSString *) contactIdForTitle: (NSString *) string {
    for (User *user in self.contacts) {
        if ([user.title isEqualToString: string]) {
            return user.id;
        }
    }
    return nil;
}

- (NSArray *) contactIdsForTitles: (NSArray *) strings {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (NSString *aTitle in strings) {
        [ret addObject: [self contactIdForTitle: aTitle]];
    }
    return ret;
}


#pragma mark ServiceItems

- (NSString *) serviceItemIdForTitle: (NSString *) string {
    for (ServiceItem *serviceItem in serviceItems) {
        if ([serviceItem.title isEqualToString: string]) {
            return serviceItem.id;
        }
    }
    return nil;
}

- (ServiceItem *) serviceItemForId: (NSString *) itemId {
    for (ServiceItem *serviceItem in serviceItems) {
        if ([serviceItem.id isEqualToString: itemId]) {
            return serviceItem;
        }
    }
    return nil;
}

- (NSArray *) serviceItemNames {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (ServiceItem *serviceItem in serviceItems) {
        [ret addObject: serviceItem.title];
    }
    return ret;
}

- (NSArray *) jobNames {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (Job *job in self.jobs) {
        [ret addObject: job.title];
    }
    return ret;
}


#pragma mark Empty Strings

- (NSString *) emptyStringForTaskMode: (NSString *) mode {
    NSString *string;
    if ([mode isEqualToString: TASKLISTMODE_DUE]) {
        string = @"You don't have any due tasks.";
    } else if ([mode isEqualToString: TASKLISTMODE_TODAY]) {
        string = @"You don't have any tasks for today.";
    } else if ([mode isEqualToString: TASKLISTMODE_OBSERVING]) {
        string = @"You are not observing any current tasks.";
    } else if ([mode isEqualToString: TASKLISTMODE_MYTASKS]) {

        string = @"You don't have any tasks assigned to you.";
    } else if ([mode isEqualToString: TASKLISTMODE_JOBS]) {
        string = @"There are no tasks for this job.";
    } else if ([mode isEqualToString: TASKLISTMODE_ARTISTS]) {

        string = @"This artist doesn't have any tasks.";
    }
    return string;
}

@end