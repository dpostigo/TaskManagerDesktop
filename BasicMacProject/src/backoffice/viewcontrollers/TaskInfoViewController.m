//
// Created by Daniela Postigo on 5/9/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TaskInfoViewController.h"
//#import "BOWhiteView.h"
#import "BasicTokenCell.h"
#import "BasicTextFieldCellView.h"
#import "BasicWhiteView.h"
#import "BasicCustomRowView.h"
#import "NSButton+DPUtils.h"
#import "BOModalTableRowView.h"
#import "TaskEditViewController.h"


@implementation TaskInfoViewController {
    NSMutableDictionary *imageDictionary;
}


@synthesize firstHeight;
@synthesize detailController;

//- (void) viewDidAppear: (BOOL) animated {
//    [super viewDidAppear: animated];
//    firstHeight = self.view.height;
//}

- (void) loadView {
    [super loadView];

    imageDictionary = [[NSMutableDictionary alloc] init];
    [imageDictionary setObject: [NSImage imageNamed: @"invisible-icon"] forKey: @"Task"];
    [imageDictionary setObject: [NSImage imageNamed: @"service-item-icon"] forKey: @"Service Item"];
    [imageDictionary setObject: [NSImage imageNamed: @"job-icon-dark"] forKey: @"Job"];
    [imageDictionary setObject: [NSImage imageNamed: @"notes-icon"] forKey: @"Notes"];
    [imageDictionary setObject: [NSImage imageNamed: @"today-icon-dark"] forKey: @"Start Date"];
    [imageDictionary setObject: [NSImage imageNamed: @"due-icon-dark"] forKey: @"Due Date"];
    [imageDictionary setObject: [NSImage imageNamed: @"assignee-icon"] forKey: @"Assignee"];
    [imageDictionary setObject: [NSImage imageNamed: @"observers-icon"] forKey: @"Observers"];

    self.allowsSelection = NO;


    //    self.backgroundView = [[BasicWhiteView alloc] initWithFrame: table.enclosingScrollView.frame];
    //    backgroundView.autoresizingMask = table.enclosingScrollView.autoresizingMask;
    //    backgroundView.cornerRadius = 5.0;
    //    backgroundView.shadow.shadowColor = [NSColor blackColor];
    //    backgroundView.borderColor = [NSColor blackColor];
    //    [self.view addSubview: backgroundView];
    //    [self.view addSubview: table.enclosingScrollView];
}

- (void) prepareDataSource {
    [super prepareDataSource];
    [dataSource removeAllObjects];

    Task *task = _model.selectedTask;

    TableSection *tableSection;
    tableSection = [[TableSection alloc] initWithTitle: @""];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Task" detailTextLabel: task.title cellIdentifier: @"TaskCell" image: [NSImage imageNamed: @"service-item-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Service Item" detailTextLabel: task.serviceItem.title cellIdentifier: @"TokenCell" image: [NSImage imageNamed: @"service-item-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Job" detailTextLabel: task.job.title cellIdentifier: @"TokenCell" image: [NSImage imageNamed: @"job-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Notes" detailTextLabel: task.notes cellIdentifier: @"NotesCell" image: [NSImage imageNamed: @"notes-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Start Date" detailTextLabel: [_model.slugFormatter stringFromDate: task.startDate] cellIdentifier: @"DateCell" image: [NSImage imageNamed: @"today-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Due Date" detailTextLabel: [_model.slugFormatter stringFromDate: task.dueDate] cellIdentifier: @"DateCell" image: [NSImage imageNamed: @"due-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Assignee" detailTextLabel: task.assignee.title cellIdentifier: @"TokenCell" image: [NSImage imageNamed: @"assignee-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Observers" cellIdentifier: @"TokenCell" content: task.observerIds image: [NSImage imageNamed: @"observers-icon"]]];
    [self.dataSource addObject: tableSection];

    [table reloadData];

    //    [self activateFirstTextField];
}


#pragma mark IBActions

- (void) handleCheckboxClick: (id) sender {
}

- (void) handleEditButton: (id) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);


    //    [_model notifyDelegates: @selector(shouldAddTask) object: nil];
    //TaskEdit

    TaskEditViewController *controller = [[TaskEditViewController alloc] initWithNibName: @"AddTaskViewController" bundle: nil];
    [_model notifyDelegates: @selector(presentModalWindow:) object: controller];
}


- (void) handleToggle: (id) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [detailController toggleTaskDetails: self];
}

#pragma mark BasicTableViewController



- (NSTableRowView *) tableRowView: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    BOModalTableRowView *rowView = [[BOModalTableRowView alloc] init];
    if ([rowObject.textLabel isEqualToString: @"Task"]) {
        rowView.cornerOptions = JSUpperLeftCorner | JSUpperRightCorner;
        rowView.cornerRadius = MODAL_CORNER_RADIUS * 0.5;
    } else if ([rowObject.textLabel isEqualToString: @"Observers"]) {
        rowView.cornerOptions = JSLowerLeftCorner | JSLowerRightCorner;
        rowView.cornerRadius = MODAL_CORNER_RADIUS * 0.5;
    }
    return rowView;
}

- (void) configureCell: (BasicTableCellView *) tableCell forRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    [super configureCell: tableCell forRowObject: rowObject tableSection: tableSection];
    //    tableCell.backgroundView = [[BOWhiteView alloc] init];
    NSImage *image = [imageDictionary objectForKey: rowObject.textLabel];

    if ([rowObject.cellIdentifier isEqualToString: @"TokenCell"]) {
        BasicTokenCell *tokenCell = (BasicTokenCell *) tableCell;
        [tokenCell.tokenField.cell setPlaceholderString: rowObject.textLabel];
        tokenCell.tokenField.delegate = self;
        tokenCell.imageView.image = image;
        tokenCell.tokenField.enabled = NO;

        if (rowObject.detailTextLabel != nil) {
            tokenCell.tokenField.stringValue = rowObject.detailTextLabel;
        }

    }

    else if ([rowObject.cellIdentifier isEqualToString: @"TaskCell"]) {
        BasicTableCellView *taskCell = (BasicTableCellView *) tableCell;
        if (rowObject.detailTextLabel != nil) taskCell.textLabel.stringValue = rowObject.detailTextLabel;
        [taskCell.textLabel sizeToFit];

        taskCell.secondButton.left = taskCell.textLabel.right;
        [taskCell.secondButton addTarget: self action: @selector(handleEditButton:)];
        [taskCell.accessoryButton addTarget: self action: @selector(handleToggle:)];
    }

    else {
        BasicTextFieldCellView *cell = (BasicTextFieldCellView *) tableCell;
        [cell.textField.cell setPlaceholderString: rowObject.textLabel];


        if (rowObject.detailTextLabel != nil) cell.textLabel.stringValue = rowObject.detailTextLabel;


        cell.imageView.image = image;
        cell.textField.enabled = NO;

        if (image == nil || [rowObject.textLabel isEqualToString: @"Task"]) {
            cell.textField.left = 10;
        }
    }
}

//
//- (void) configureCell: (UITableViewCell *) tableCell forTableSection: (TableSection *) tableSection rowObject: (TableRowObject *) rowObject {
//    [super configureCell: tableCell forTableSection: tableSection rowObject: rowObject];
//
//    tableCell.backgroundView = [[BOWhiteView alloc] init];
//    NSImage *image = [imageDictionary objectForKey: rowObject.textLabel];
//
//    if ([rowObject.cellIdentifier isEqualToString: @"TokenCell"]) {
//        BasicTokenFieldCell *tokenCell = (BasicTokenFieldCell *) tableCell;
//        tokenCell.tokenField.textField.placeholder = rowObject.textLabel;
//        tokenCell.tokenField.delegate = self;
//        tokenCell.tokenField.tokenLimit = 1;
//        tokenCell.tokenField.textField.returnKeyType = UIReturnKeyNext;
//        tokenCell.tokenField.propertySelector = @"title";
//        tokenCell.imageView.image = image;
//        tokenCell.tokenField.textField.enabled = NO;
//        tokenCell.tokenField.userInteractionEnabled = NO;
//        tokenCell.tokenField.textField.hidden = YES;
//
//        if ([rowObject.textLabel isEqualToString: @"Job"]) {
//            tokenCell.dataSource = _model.jobs;
//            [tokenCell.tokenField.tokenContainer addTokenWithString: rowObject.detailTextLabel];
//            //            jobTokenField = tokenCell.tokenField;
//        } else if ([rowObject.textLabel isEqualToString: @"Service Item"]) {
//            tokenCell.dataSource = _model.serviceItems;
//            [tokenCell.tokenField.tokenContainer addTokenWithString: rowObject.detailTextLabel];
//            //            serviceItemTokenField = tokenCell.tokenField;
//        } else if ([rowObject.textLabel isEqualToString: @"Assignee"]) {
//
//            [tokenCell.tokenField.tokenContainer addTokenWithString: rowObject.detailTextLabel];
//            //            if (assigneesSource != nil) tokenCell.dataSource = assigneesSource;
//            //            tokenCell.tokenField.textField.enabled = assigneesSource != nil;
//            //            assigneeTokenField = tokenCell.tokenField;
//            //            assigneeActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
//            //            tokenCell.accessoryView = assigneeActivityView;
//        } else if ([rowObject.textLabel isEqualToString: @"Observers"]) {
//            tokenCell.dataSource = _model.contacts;
//            tokenCell.tokenField.tokenLimit = 9999;
//
//            NSMutableArray *observerIds = rowObject.content;
//            if ([observerIds count] > 0) {
//                NSArray *strings = [_model contactTitlesForIds: observerIds];
//                [tokenCell.tokenField.tokenContainer addTokensWithStrings: strings];
//            } else {
//                tokenCell.tokenField.textField.hidden = NO;
//            }
//        }
//
//        if (image == nil) tokenCell.tokenField.textField.left = 10;
//    }
//
//    else if ([rowObject.cellIdentifier isEqualToString: @"TaskCell"]) {
//        BasicTableCell *taskCell = (BasicTokenFieldCell *) tableCell;
//        taskCell.textLabel.text = rowObject.detailTextLabel;
//
//        [taskCell.textLabel sizeToFit];
//        taskCell.secondButton.left = taskCell.textLabel.right;
//        [taskCell.button addTarget: self action: @selector(handleCheckboxClick:) forControlEvents: UIControlEventTouchUpInside];
//        [taskCell.secondButton addTarget: self action: @selector(handleEditButton:) forControlEvents: UIControlEventTouchUpInside];
//        [taskCell.accessoryButton addTarget: self action: @selector(handleToggle:) forControlEvents: UIControlEventTouchUpInside];
//    }
//
//    else {
//        BasicTextFieldCell *cell = (BasicTextFieldCell *) tableCell;
//        cell.textField.placeholder = rowObject.textLabel;
//        cell.textField.text = rowObject.detailTextLabel;
//        cell.backgroundView.clipsToBounds = NO;
//        cell.backgroundView.layer.masksToBounds = NO;
//        cell.clipsToBounds = NO;
//        cell.imageView.image = image;
//        cell.textField.enabled = NO;
//
//        if (image == nil || [rowObject.textLabel isEqualToString: @"Task"]) {
//            cell.textField.left = 10;
//        }
//    }
//
//    [tableCell rasterize];
//}

//- (CGFloat) heightForFooterInTableSection: (TableSection *) tableSection {
//    return 300;
//}
//
//- (UIView *) viewForFooterInTableSection: (TableSection *) tableSection {
//    return discussionController.view;
//}


#pragma mark Callbacks

- (void) taskDidUpdate: (Task *) task {
    [self prepareDataSource];
    [table reloadData];
}

- (void) selectedTaskDidUpdate {
    [self prepareDataSource];
    [table reloadData];
}

@end