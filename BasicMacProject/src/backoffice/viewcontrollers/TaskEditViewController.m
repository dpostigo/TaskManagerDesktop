//
// Created by Daniela Postigo on 5/12/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TaskEditViewController.h"
#import "UpdateTaskProcess.h"
#import "NSImage+Utils.h"
#import "BasicTokenCell.h"
#import "BasicTextFieldCellView.h"


@implementation TaskEditViewController {
}


- (void) loadView {
    [super loadView];

    submitButton.title = @"Update Task";
    [imageDictionary setObject: [NSImage newImageFromResource: @"invisible-icon.png"] forKey: @"Task"];
}
//
//- (void) setJobTokenField: (DPTokenTextField *) jobTokenField1 {
//    jobTokenField = jobTokenField1;
//    [jobTokenField didSelectObject: _model.selectedTask.job];
//}
//
//- (void) setServiceItemTokenField: (DPTokenTextField *) serviceItemTokenField1 {
//    serviceItemTokenField = serviceItemTokenField1;
//    [serviceItemTokenField didSelectObject: _model.selectedTask.serviceItem];
//}
//
//- (void) setAssigneeTokenField: (DPTokenTextField *) assigneeTokenField1 {
//    assigneeTokenField = assigneeTokenField1;
//    [assigneeTokenField didSelectObject: _model.selectedTask.assignee];
//}
//
//- (void) setObserversTokenField: (DPTokenTextField *) observersTokenField1 {
//    observersTokenField = observersTokenField1;
//    for (NSString *anId in _model.selectedTask.observerIds) {
//        User *user = [_model contactForId: anId];
//        [observersTokenField didSelectObject: user];
//    }
//}

- (void) prepareDataSource {
    [super prepareDataSource];

    Task *task = _model.selectedTask;
    //    selectedAssigneeId = task.assignee.id;

    //    TableSection *tableSection;
    //    tableSection = [[TableSection alloc] initWithTitle: @""];
    //    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Task" detailTextLabel: task.title cellIdentifier: @"TaskCell"]];
    //    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Service Item" detailTextLabel: task.serviceItem.title cellIdentifier: @"TokenCell"]];
    //    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Job" detailTextLabel: task.job.title cellIdentifier: @"TokenCell"]];
    //    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Notes" detailTextLabel: task.notes cellIdentifier: @"NotesCell"]];
    //    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Start Date" detailTextLabel: [_model.slugFormatter stringFromDate: task.startDate] cellIdentifier: @"DateCell"]];
    //    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Due Date" detailTextLabel: [_model.slugFormatter stringFromDate: task.dueDate] cellIdentifier: @"DateCell"]];
    //    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Assignee" detailTextLabel: task.assignee.title cellIdentifier: @"TokenCell"]];
    //    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Observers" cellIdentifier: @"TokenCell" content: task.observerIds]];
    //    [self.dataSource addObject: tableSection];

    [dataSource removeAllObjects];
    TableSection *tableSection;
    tableSection = [[TableSection alloc] initWithTitle: @""];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Task" detailTextLabel: task.title cellIdentifier: @"TaskCell"]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Service Item" detailTextLabel: task.serviceItem.title cellIdentifier: @"TokenCell" content: _model.serviceItems image: [NSImage imageNamed: @"service-item-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Job" detailTextLabel: task.job.title cellIdentifier: @"TokenCell" content: _model.jobs image: [NSImage imageNamed: @"job-icon-dark"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Notes" detailTextLabel: task.notes cellIdentifier: @"NotesCell" image: [NSImage imageNamed: @"notes-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Start Date" detailTextLabel: [_model.slugFormatter stringFromDate: task.startDate] cellIdentifier: @"DateCell" image: [NSImage imageNamed: @"today-icon-dark"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Due Date" detailTextLabel: [_model.slugFormatter stringFromDate: task.startDate] cellIdentifier: @"DateCell" image: [NSImage imageNamed: @"due-icon-dark"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Assignee" detailTextLabel: task.assignee.title cellIdentifier: @"TokenCell" image: [NSImage imageNamed: @"assignee-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Observers" cellIdentifier: @"TokenCell" content: task.observerIds image: [NSImage imageNamed: @"observers-icon"]]];
    [self.dataSource addObject: tableSection];

    //    [self activateFirstTextField];
}



#pragma mark UITableView

- (void) configureCell: (BasicTableCellView *) tableCell forRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    [super configureCell: tableCell forRowObject: rowObject tableSection: tableSection];
    if ([rowObject.cellIdentifier isEqualToString: @"TokenCell"]) {
        BasicTokenCell *tokenCell = (BasicTokenCell *) tableCell;


        if ([rowObject.textLabel isEqualToString: @"Job"]
                || [rowObject.textLabel isEqualToString: @"Service Item"]
                || [rowObject.textLabel isEqualToString: @"Assignee"]) {
            tokenCell.tokenField.objectValue = rowObject.detailTextLabel;


        } else if ([rowObject.textLabel isEqualToString: @"Observers"]) {
            //            tokenCell.tokenField.tokenLimit = 9999;

            NSMutableArray *observerIds = rowObject.content;
            if ([observerIds count] > 0) {
                for (NSString *observerId in observerIds) {
                    //                    NSLog(@"observerId = %@", observerId);

                    User *contact = [_model contactForId: observerId];
                    tokenCell.tokenField.objectValue = contact.title;
                }
            }
        }
    }

    else {
        BasicTextFieldCellView *cell = (BasicTextFieldCellView *) tableCell;
        [cell.textField.cell setPlaceholderString: rowObject.textLabel];

        cell.textField.stringValue = rowObject.textLabel;
        if (rowObject.detailTextLabel != nil) cell.textField.stringValue = rowObject.detailTextLabel;
        //        [self subscribeTextField: cell.textField];
    }

}




#pragma mark IBActions


- (IBAction) handleCreateButton: (id) sender {
    [self handleUpdateButton: sender];
}

- (IBAction) handleUpdateButton: (id) sender {

    //    [self returnAllTextFields];

    Task *task = _model.selectedTask;
    task.title = selectedTaskTitle;
    task.startDate = [_model.slugFormatter dateFromString: selectedStartDate];
    task.dueDate = [_model.slugFormatter dateFromString: selectedDueDate];
    task.job = [_model jobForId: selectedJobId];
    task.serviceItem = [_model serviceItemForId: selectedServiceItemId];
    task.assignee = [_model contactForId: selectedAssigneeId];
    task.notes = selectedNotes;
    [_queue addOperation: [[UpdateTaskProcess alloc] initWithTask: _model.selectedTask]];
}


- (NSString *) stringForTextField: (NSString *) string {
    NSTextField *textField = [textFieldDict objectForKey: string];
    return textField.stringValue;
}

#pragma mark Callbacks

- (void) taskDidUpdate: (Task *) task {
    if (task == _model.selectedTask) {
        [_model notifyDelegates: @selector(shouldPopViewController:) object: self];
        //        [self performSegueWithIdentifier: @"EditModalDismiss" sender: self];
    }
}


#pragma mark TextFields

@end