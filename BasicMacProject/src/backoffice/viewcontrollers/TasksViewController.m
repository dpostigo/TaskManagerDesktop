//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TasksViewController.h"
#import "NSImage+Utils.h"
#import "NSColor+Utils.h"
#import "NSDate+BOUtils.h"
#import "CompleteTaskProcess.h"
#import "GetTasksOperation.h"
#import "TaskDetailViewController.h"
#import "SaveDataOperation.h"
#import "BOModalTableRowView.h"
//#import "BOWhitePopoverBackgroundView.h"


#define ROW_HEIGHT 32
#define LAST_ROW_HEIGHT 40

@implementation TasksViewController {
    //    UIPopoverController *popover;
    TaskDetailViewController *taskDetailController;
}


@synthesize createdTask;
@synthesize taskMode;

- (void) setTaskMode: (NSString *) taskMode1 {
    taskMode = taskMode1;
    [Model sharedModel].currentTaskMode = taskMode;
}

- (void) loadView {
    //    self.rowSpacing = 1;
    self.taskMode = TASKLISTMODE_MYTASKS;
    [super loadView];
    self.title = @"My Tasks";
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
    self.allowsSelection = YES;
    [self expand];


    taskDetailController = [[TaskDetailViewController alloc] initWithDefaultNib];
}

- (void) viewDidAppear {
    [super viewDidAppear];

    [outline deselectAll: self];
}


- (void) prepareDataSource {
    [super prepareDataSource];

    [dataSource removeAllObjects];
    self.title = [_model titleForMode: taskMode];

    NSArray *tasks = [_model tasksForMode: taskMode];
    NSArray *jobs = [_model jobsForTaskArray: tasks];

    if ([jobs count] == 0) {
        OutlineSection *tableSection = [[OutlineSection alloc] initWithTitle: @"EmptySection"];
        [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: [_model emptyStringForTaskMode: taskMode] cellIdentifier: @"EmptyCell"]];
        [dataSource addObject: tableSection];
    } else {

        for (Job *job in jobs) {
            OutlineSection *tableSection = [[OutlineSection alloc] initWithTitle: [NSString stringWithFormat: @"%@ - %@", job.jobNumber, job.title] content: job];
            NSArray *jobTasks = [_model tasksForJobId: job.id fromArray: tasks];
            for (int j = 0; j < [jobTasks count]; j++) {
                Task *task = [jobTasks objectAtIndex: j];
                [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: task.title content: task]];
            }
            [dataSource addObject: tableSection];
        }
    }
}



#pragma mark UITableView



- (BasicTableRowView *) rowViewForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection {

    BOModalTableRowView *rowView = [[BOModalTableRowView alloc] init];
    if ([rowObject.textLabel isEqualToString: @"Task"]) {
        rowView.cornerOptions = JSUpperLeftCorner | JSUpperRightCorner;
        rowView.cornerRadius = MODAL_CORNER_RADIUS * 0.5;
    } else if ([rowObject.textLabel isEqualToString: @"Observers"]) {
        rowView.cornerOptions = JSLowerLeftCorner | JSLowerRightCorner;
        rowView.cornerRadius = MODAL_CORNER_RADIUS * 0.5;
    }
    //
    //    NSUInteger index = [outlineSection.rows indexOfObject: rowObject];
    //    if (index == [outlineSection.rows count] - 1) {
    //        rowView.insetRect = NSMakeRect(0, 0, 0, ROW_HEIGHT - LAST_ROW_HEIGHT);
    //    } else {
    //        rowView.insetRect = NSMakeRect(0, 0, 0, -0.5);
    //
    //    }
    return rowView;
}


- (void) configureCell: (BasicTableCellView *) tableCell forRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection {
    [super configureCell: tableCell forRowObject: rowObject outlineSection: outlineSection];

    if ([rowObject.cellIdentifier isEqualToString: @"EmptyCell"]) {
        BasicTableCellView *cell = (BasicTableCellView *) tableCell;
        cell.textLabel.text = rowObject.textLabel;
        return;
    }

    BasicTableCellView *cell = (BasicTableCellView *) tableCell;
    cell.textLabel.stringValue = rowObject.textLabel;
    Task *task = rowObject.content;

    NSString *detailString = task.dueDate.detailString;
    if (detailString == nil) {
        detailString = @"null";
        //        NSLog(@"task.dueDate = %@", task.dueDate);
        [cell.detailTextLabel setHidden: YES];
    }

    cell.detailTextLabel.stringValue = detailString;
    //    cell.detailTextLabel.shadowColor = [NSColor whiteColor];
    //    cell.detailTextLabel.shadowOffset = CGSizeMake(0, -1);

    switch (task.dueDate.taskDateType) {
        case TaskDateTypeOverdue :
            cell.detailTextLabel.textColor = [NSColor colorWithString: RED_COLOR];
            //            cell.backgroundView.backgroundColor = [NSColor colorWithString: RED_FADED];
            //            cell.backgroundView.layer.borderColor = [NSColor colorWithString: RED_FADED].CGColor;
            //            cell.selectedBackgroundView.backgroundColor = [[NSColor colorWithString: RED_FADED] colorWithAlphaComponent: 0.5];
            cell.detailTextLabel.shadowColor = [NSColor colorWithWhite: 1.0 alpha: 0.7];
            [cell.button setImage: [NSImage newImageFromResource: @"red-checkbox.png"]];

        case TaskDateTypeToday :
            cell.detailTextLabel.textColor = [NSColor colorWithString: YELLOW_COLOR];
            [cell.button setImage: [NSImage newImageFromResource: @"yellow-checkbox.png"]];
            break;

        case TaskDateTypeNone :
        default :
            cell.detailTextLabel.textColor = [NSColor darkGrayColor];
            [cell.button setImage: [NSImage newImageFromResource: @"silver-checkbox.png"]];
            break;
    }

    cell.captionLabel.stringValue = task.assignee.displayName;

    [cell.textLabel sizeToFit];
    cell.textLabel.height += 2;
    cell.textLabel.top = ((cell.height - cell.textLabel.height) / 2) + 2;
    cell.captionLabel.left = cell.textLabel.right + 5;

    //    cell.textLabel.shadowColor = cell.detailTextLabel.shadowColor;
    //    cell.textLabel.shadowOffset = cell.detailTextLabel.shadowOffset;
    //    cell.captionLabel.shadowColor = cell.detailTextLabel.shadowColor;
    //    cell.captionLabel.shadowOffset = cell.detailTextLabel.shadowOffset;

    [cell.button setTarget: self];
    cell.button.action = @selector(handleCheckbox:);
}

- (CGFloat) heightForHeaderSection: (OutlineSection *) outlineSection {
    if ([outlineSection.title isEqualToString: @"EmptySection"]) return 0;
    return outline.rowHeight;
}

- (CGFloat) heightForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection {
    NSUInteger index = [outlineSection.rows indexOfObject: rowObject];

    if ([outlineSection.title isEqualToString: @"EmptyString"]) {
        return 100;
    }

    //    else if (index == [outlineSection.rows count] - 1) {
    //        return LAST_ROW_HEIGHT;
    //    }
    return ROW_HEIGHT;
    return [super heightForRowObject: rowObject outlineSection: outlineSection];
}

- (BasicTableCellView *) headerCellForOutlineSection: (OutlineSection *) outlineSection {
    BasicTableCellView *headerCell = [outline makeViewWithIdentifier: @"HeaderCell" owner: self];
    headerCell.textLabel.stringValue = outlineSection.title;
    //    headerCell.backgroundView = [[OldWhiteView alloc] init];
    //    headerCell.backgroundView.alpha = 0.9;
    return headerCell;
    return [super headerCellForOutlineSection: outlineSection];
}

- (void) cellSelectedForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) tableSection {
    [super cellSelectedForRowObject: rowObject outlineSection: tableSection];

    Task *task = rowObject.content;
    _model.selectedTask = task;

//    if (taskDetailController.isOpen) {
//        [taskDetailController closeTaskDetails: self];
//    }

    [self.navigationController pushViewController: taskDetailController animated: YES completion: ^{
        //        [_queue addOperation: [[GetDiscussionProcess alloc] initWithTask: _model.selectedTask]];
    }];
    //    [_model notifyDelegates: @selector(segueWithViewController:) object: [[TaskDetailViewController alloc] initWithDefaultNib]];
    //        [self performSegueWithIdentifier: @"TaskDetailSegue" sender: self];
}



#pragma mark IBActions

- (IBAction) handleAddTask: (id) sender {
    //    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier: @"AddTaskViewController"];
    //    [self presentModal: viewController withSize: CGSizeMake(400, 300)];
}

- (IBAction) handleSettingsButton: (NSButton *) sender {
    //    _model.tasks = nil;
    //    _model.jobs = nil;
    //    [self prepareDataSource];
    //    [_model notifyDelegates: @selector(shouldSignOut) object: nil];

    //    SettingsMenuViewController *settingsController = [self.storyboard instantiateViewControllerWithIdentifier: @"SettingsMenuViewController"];
    //    settingsController.contentSizeForViewInPopover = CGSizeMake(200, 200);
    //    popover = [[UIPopoverController alloc] initWithContentViewController: settingsController];
    //    popover.popoverBackgroundViewClass = [BOWhitePopoverBackgroundView class];
    //    [popover presentPopoverFromRect: sender.frame inView: self.view permittedArrowDirections: UIPopoverArrowDirectionDown animated: YES];
    //    //    [popover presentPopoverFromBarButtonItem: sender.frame permittedArrowDirections: UIPopoverArrowDirectionUp animated: YES];
}

- (IBAction) handleCheckbox: (id) sender {

    NSButton *button = sender;
    NSTableCellView *cell = (NSTableCellView *) button.superview.superview;
    NSLog(@"cell = %@", cell);

    //
    NSInteger row = [outline rowForView: cell] - 1;
    //    NSLog(@"row = %li", row);

    TableRowObject *rowObject = [outline itemAtRow: row];
    TableSection *tableSection = [outline parentForItem: rowObject];

    NSLog(@"rowObject = %@", rowObject);

    Task *task = rowObject.content;
    if (task == nil) {
        NSLog(@"No task.");
        return;
    }

    NSLog(@"task.title = %@", task.title);
    [_model.tasks removeObject: task];

    [outline removeItemsAtIndexes: [NSIndexSet indexSetWithIndex: row] inParent: tableSection withAnimation: NSTableViewAnimationSlideUp];
    //    [outline removeRowsAtIndexes: [NSIndexSet indexSetWithIndex: row] withAnimation: NSTableViewAnimationSlideUp];
    //    [outline removeRowsAtIndexes: <#(NSIndexSet *)indexes#> withAnimation: <#(NSTableViewAnimationOptions)animationOptions#>]

    [_queue addOperation: [[CompleteTaskProcess alloc] initWithTask: task completedDate: [NSDate date]]];
}

#pragma mark Callbacks
- (void) loginSucceeded: (NSDictionary *) dictionary {
    [_queue addOperation: [[GetTasksOperation alloc] init]];
}

- (void) getTasksSucceeded {
    [self prepareDataSource];
    [outline reloadData];
    [self expand];

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, [dataSource count])];
    //    [outline reloadSections: indexSet withRowAnimation: UITableViewRowAnimationBottom];
    [outline reloadData];
}

- (void) taskListModeDidChange: (NSString *) mode {
    self.taskMode = mode;
    [self prepareDataSource];
    [outline reloadData];
    [self expand];

    //    if (self.navigationController.visibleViewController != self) {
    //        [self.navigationController popToViewController: self animated: YES];
    //    }
}

- (void) taskDidComplete: (Task *) task {
    TableRowObject *rowObject = [self tableRowObjectForTask: task];
    //    TableSection *tableSection = [self tableSectionForRowObject: rowObject];


    //    [self deleteRowObject: rowObject inSection: tableSection animation: UITableViewRowAnimationLeft];
}

- (void) taskDidUpdate: (Task *) task {
    [self prepareDataSource];
    [outline reloadData];
    [self expand];
}

- (void) didCreateTask: (Task *) task {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [_queue addOperation: [[SaveDataOperation alloc] init]];

    _model.currentNewTask = task;
    NSLog(@"_model.currentNewTask = %@", _model.currentNewTask);
    [self performSelector: @selector(handleNewTask) withObject: nil afterDelay: 1.0];
}

- (void) fakeModalDidDismiss {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) handleNewTask {
    if (_model.currentNewTask != nil) {

        Task *task = _model.currentNewTask;
        TableSection *tableSection = [self tableSectionForJobId: task.job.id];
        if (tableSection == nil) return;
        TableRowObject *rowObject = [[TableRowObject alloc] initWithTextLabel: task.title content: task];
        [tableSection.rows addObject: rowObject];

        //        NSArray *indexPaths = [self indexPathsForRowObject: rowObject inSection: tableSection];
        //        [table insertRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationLeft];
        _model.currentNewTask = nil;
    }
}


#pragma mark Helpers

- (TableRowObject *) tableRowObjectForTask: (Task *) aTask {
    for (TableSection *tableSection in dataSource) {
        for (TableRowObject *rowObject in tableSection.rows) {
            Task *task = rowObject.content;
            NSLog(@"task = %@", task);
            if ([task.id isEqualToString: aTask.id]) {
                return rowObject;
            }
        }
    }
    return nil;
}

- (TableSection *) tableSectionForJobId: (NSString *) jobId {
    for (TableSection *tableSection in dataSource) {
        Job *job = tableSection.content;
        if ([job.id isEqualToString: jobId]) {
            return tableSection;
        }
    }
    return nil;
}

@end