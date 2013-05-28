//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicModel.h"
#import "User.h"
#import "Job.h"
#import "Task.h"


typedef enum {
    TaskListModeDue = 0,
    TaskListModeToday = 1,
    TaskListModeObserving = 2,
    TaskListModeMyTasks = 3,
} TaskListMode;

#define TASKLISTMODE_DUE @"Due"
#define TASKLISTMODE_TODAY @"Today"
#define TASKLISTMODE_OBSERVING @"Observing"
#define TASKLISTMODE_MYTASKS @"My Tasks"
#define TASKLISTMODE_JOBS @"Jobs"
#define TASKLISTMODE_ARTISTS @"Artists"


@interface Model : BasicModel {
    BOOL loggedIn;
    User *currentUser;
    User *currentArtist;
    Job *currentJob;
    Task *currentNewTask;
    Task *selectedTask;

    NSMutableArray *tasks;
    NSMutableArray *jobs;
    NSMutableArray *serviceItems;
    NSMutableArray *contacts;

    NSDateFormatter *defaultFormatter;
    NSDateFormatter *slugFormatter;

    NSString *currentTaskMode;

    __unsafe_unretained NSViewController *homeController;
}


@property(nonatomic) BOOL loggedIn;
@property(nonatomic, strong) User *currentUser;
@property(nonatomic, strong) NSMutableArray *tasks;
@property(nonatomic, strong) NSMutableArray *jobs;
@property(nonatomic, strong) Job *currentJob;
@property(nonatomic, strong) User *currentArtist;
@property(nonatomic, strong) NSMutableArray *serviceItems;
@property(nonatomic, strong) NSMutableArray *contacts;
@property(nonatomic, assign) NSViewController *homeController;
@property(nonatomic, strong) NSDateFormatter *defaultFormatter;
@property(nonatomic, strong) Task *currentNewTask;
@property(nonatomic, strong) Task *selectedTask;
@property(nonatomic, strong) NSDateFormatter *slugFormatter;
@property(nonatomic, retain) NSString *currentTaskMode;
+ (Model *) sharedModel;

- (NSString *) jobIdForTitle: (NSString *) jobName;
- (Job *) jobForTitle: (NSString *) jobName;
- (Job *) jobForId: (NSString *) jobId;
- (NSArray *) potentialJobs;
- (NSArray *) quoteJobs;
- (NSArray *) activeJobs;
- (NSArray *) tasksForJobId: (NSString *) id1;
- (NSArray *) tasksForJobId: (NSString *) jobId fromArray: (NSArray *) taskArray;
- (NSArray *) jobsForTaskArray: (NSArray *) taskArray;
- (NSString *) titleForMode: (NSString *) mode;
- (NSArray *) tasksForMode: (NSString *) mode;
- (NSArray *) artists;
- (User *) contactForId: (NSString *) anId;
- (NSArray *) contactNames;
- (NSArray *) contactTitlesForContacts: (NSArray *) array;
- (NSArray *) contactTitlesForIds: (NSArray *) ids;
- (NSString *) contactIdForTitle: (NSString *) string;
- (NSArray *) contactIdsForTitles: (NSArray *) strings;
- (NSString *) serviceItemIdForTitle: (NSString *) string;
- (ServiceItem *) serviceItemForId: (NSString *) itemId;
- (NSArray *) serviceItemNames;
- (NSArray *) jobNames;
- (NSString *) emptyStringForTaskMode: (NSString *) mode;
@end