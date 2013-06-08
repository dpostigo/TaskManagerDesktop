//
// Created by Daniela Postigo on 5/9/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AddTaskViewController.h"
#import "GetServiceItemsOperation.h"
//#import "BasicTokenFieldCell.h"
#import "CreateTaskOperation.h"
#import "BasicTokenCell.h"
#import "BasicTextFieldCellView.h"
#import "BOModalTableRowView.h"
#import "BasicDatePickerCell.h"
#import "GetAssigneeProcess.h"


@implementation AddTaskViewController {
    NSMenu *serviceItemMenu;
    BasicDatePickerCell *currentDateCell;
}


@synthesize modalSize;

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        modalSize = CGSizeMake(700, 365);
    }
    return self;
}

- (void) loadView {
    [super loadView];

    datePicker.dateValue = [NSDate date];
    datePicker.delegate = self;

    self.allowsSelection = NO;


    textFieldDict = [[NSMutableDictionary alloc] init];
    imageDictionary = [[NSMutableDictionary alloc] init];
    [imageDictionary setObject: [NSImage imageNamed: @"service-item-icon"] forKey: @"Service Item"];
    [imageDictionary setObject: [NSImage imageNamed: @"job-icon-dark"] forKey: @"Job"];
    [imageDictionary setObject: [NSImage imageNamed: @"notes-icon"] forKey: @"Notes"];
    [imageDictionary setObject: [NSImage imageNamed: @"today-icon-dark"] forKey: @"Start Date"];
    [imageDictionary setObject: [NSImage imageNamed: @"due-icon-dark"] forKey: @"Due Date"];
    [imageDictionary setObject: [NSImage imageNamed: @"assignee-icon"] forKey: @"Assignee"];
    [imageDictionary setObject: [NSImage imageNamed: @"observers-icon"] forKey: @"Observers"];

    if (_model.serviceItems == nil || [_model.serviceItems count] == 0) [_queue addOperation: [[GetServiceItemsOperation alloc] init]];

    [self handleValidation: nil];
    //    [self enableKeyboardNotifications];

    submitButton.enabled = YES;

}

- (void) prepareDataSource {
    [super prepareDataSource];

    [dataSource removeAllObjects];
    TableSection *tableSection;
    tableSection = [[TableSection alloc] initWithTitle: @""];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Task" cellIdentifier: @"TaskCell"]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Service Item" cellIdentifier: @"TokenCell" content: _model.serviceItems image: [NSImage imageNamed: @"service-item-icon"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Job" cellIdentifier: @"TokenCell" content: _model.jobs image: [NSImage imageNamed: @"job-icon-dark"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Notes" image: [NSImage imageNamed: @"notes-icon"] cellIdentifier: @"NotesCell"]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Start Date" image: [NSImage imageNamed: @"today-icon-dark"] cellIdentifier: @"DateCell"]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Due Date" image: [NSImage imageNamed: @"due-icon-dark"] cellIdentifier: @"DateCell"]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Assignee" image: [NSImage imageNamed: @"assignee-icon"] cellIdentifier: @"TokenCell"]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Observers" cellIdentifier: @"TokenCell" content: _model.contacts image: [NSImage imageNamed: @"observers-icon"]]];
    [self.dataSource addObject: tableSection];


    //    [self activateFirstTextField];
}


#pragma mark BasicTableViewController

- (NSTableRowView *) tableRowView: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    BOModalTableRowView *rowView = [[BOModalTableRowView alloc] init];
    if ([rowObject.textLabel isEqualToString: @"Task"]) {
        rowView.cornerOptions = JSUpperLeftCorner | JSUpperRightCorner;
        rowView.cornerRadius = MODAL_CORNER_RADIUS * 0.5;
    }
    return rowView;
}

- (void) configureCell: (BasicTableCellView *) tableCell forRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    [super configureCell: tableCell forRowObject: rowObject tableSection: tableSection];

    //    tableCell.backgroundView.gradientFill = [[NSGradient alloc] initWithColorsAndLocations:
    //            [NSColor colorWithDeviceWhite: 0.85f alpha: 1.0f], 0.0f,
    //            [NSColor colorWithDeviceWhite: 0.90f alpha: 1.0f], 0.2f,
    //            [NSColor colorWithDeviceWhite: 0.93f alpha: 1.0f], 0.5f,
    //            [NSColor colorWithDeviceWhite: 0.94f alpha: 1.0f], 0.7f,
    //            [NSColor colorWithDeviceWhite: 0.95f alpha: 1.0f], 1.0f,
    //            nil];

    tableCell.imageView.image = rowObject.image;

    if ([rowObject.cellIdentifier isEqualToString: @"TokenCell"]) {

        BasicTokenCell *tokenCell = (BasicTokenCell *) tableCell;
        tokenCell.tokenField.delegate = self;
        tokenCell.tokenField.rowObject = rowObject;
        [tokenCell.tokenField.cell setPlaceholderString: rowObject.textLabel];
        [self subscribeControl: tokenCell.tokenField];

        if ([rowObject.textLabel isEqualToString: @"Job"]) {
            jobTokenField = tokenCell.tokenField;
        }
        else if ([rowObject.textLabel isEqualToString: @"Service Item"]) {
            serviceItemTokenField = tokenCell.tokenField;
        } else if ([rowObject.textLabel isEqualToString: @"Assignee"]) {
            assigneeTokenField = tokenCell.tokenField;
        } else if ([rowObject.textLabel isEqualToString: @"Observers"]) {
            observersTokenField = tokenCell.tokenField;
        }
    } else {
        BasicTextFieldCellView *textCell = (BasicTextFieldCellView *) tableCell;
        [textCell.textField.cell setPlaceholderString: rowObject.textLabel];
        [textFieldDict setObject: textCell.textField forKey: rowObject.textLabel];

        if ([textCell.textField isKindOfClass: [BasicTextField class]]) {
            BasicTextField *basicTextField = (BasicTextField *) textCell.textField;
            basicTextField.rowObject = rowObject;
        }
        [self subscribeControl: textCell.textField];

        if ([rowObject.cellIdentifier isEqualToString: @"TaskCell"]) {
            textCell.textField.nextKeyView = serviceItemTokenField;
        } else if ([rowObject.cellIdentifier isEqualToString: @"NotesCell"]) {
        } else if ([rowObject.cellIdentifier isEqualToString: @"DateCell"]) {

            BasicDatePickerCell *dateCell = (BasicDatePickerCell *) tableCell;
            dateCell.button.target = self;
            dateCell.button.action = @selector(handleDatePicker:);
        }
    }



    //    NSImage *image = [imageDictionary objectForKey: rowObject.textLabel];
    //    tableCell.backgroundView = [[BOWhiteView alloc] init];
    //
    //    if ([rowObject.cellIdentifier isEqualToString: @"TokenCell"]) {
    //        BasicTokenFieldCell *tokenCell = (BasicTokenFieldCell *) tableCell;
    //        tokenCell.tokenField.textField.placeholder = rowObject.textLabel;
    //        tokenCell.tokenField.delegate = self;
    //        tokenCell.tokenField.tokenLimit = 1;
    //        tokenCell.tokenField.textField.returnKeyType = UIReturnKeyNext;
    //        tokenCell.tokenField.propertySelector = @"title";
    //        tokenCell.imageView.image = image;
    //
    //        if ([rowObject.textLabel isEqualToString: @"Job"]) {
    //            tokenCell.dataSource = _model.jobs;
    //            self.jobTokenField = tokenCell.tokenField;
    //        } else if ([rowObject.textLabel isEqualToString: @"Service Item"]) {
    //            tokenCell.dataSource = _model.serviceItems;
    //            self.serviceItemTokenField = tokenCell.tokenField;
    //        } else if ([rowObject.textLabel isEqualToString: @"Assignee"]) {
    //            if (assigneesSource != nil) tokenCell.dataSource = assigneesSource;
    //            tokenCell.tokenField.textField.enabled = assigneesSource != nil;
    //            tokenCell.tokenField.arrowDirection = UIPopoverArrowDirectionDown;
    //            self.assigneeTokenField = tokenCell.tokenField;
    //            assigneeActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    //            tokenCell.accessoryView = assigneeActivityView;
    //        } else if ([rowObject.textLabel isEqualToString: @"Observers"]) {
    //            tokenCell.dataSource = _model.contacts;
    //            tokenCell.tokenField.tokenLimit = 9999;
    //            tokenCell.tokenField.arrowDirection = UIPopoverArrowDirectionDown;
    //            self.observersTokenField = tokenCell.tokenField;
    //        }
    //
    //        if (image == nil) {
    //            tokenCell.tokenField.textField.left = 10;
    //        }
    //
    //        [self subscribeTextField: tokenCell.tokenField.textField];
    //    }
    //
    //    else {
    //        BasicTextFieldCell *cell = (BasicTextFieldCell *) tableCell;
    //        cell.textField.placeholder = rowObject.textLabel;
    //        cell.backgroundView.clipsToBounds = NO;
    //        cell.backgroundView.layer.masksToBounds = NO;
    //        cell.clipsToBounds = NO;
    //        cell.imageView.image = image;
    //
    //        if (image == nil) {
    //            cell.textField.left = 10;
    //        }
    //        if ([cell.textField isKindOfClass: [TableTextField class]]) {
    //            TableTextField *tableTextField = (TableTextField *) cell.textField;
    //            tableTextField.delegate = self;
    //            tableTextField.rowObject = rowObject;
    //        }
    //        [self subscribeTextField: cell.textField];
    //
    //        if ([rowObject.textLabel isEqualToString: @"Start Date"] || [rowObject.textLabel isEqualToString: @"Due Date"]) {
    //            cell.textField.placeholder = @"MM/DD/YYYY";
    //        }
    //    }

    //    [tableCell rasterize];
}



#pragma mark IBActions


- (IBAction) handleCancelButton: (id) sender {
    [_model notifyDelegates: @selector(closeAddTaskWindow) object: nil];
}

- (IBAction) handleCreateButton: (id) sender {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject: _model.currentUser.id forKey: @"added_by"];
    [dictionary setObject: selectedJobId forKey: @"job_id"];
    [dictionary setObject: selectedServiceItemId forKey: @"service_item_id"];
    [dictionary setObject: selectedAssigneeId forKey: @"contact_id"];
    [dictionary setObject: selectedTaskTitle forKey: @"task"];
    [dictionary setObject: selectedNotes forKey: @"notes"];
    [dictionary setObject: selectedStartDate forKey: @"start_date"];
    [dictionary setObject: selectedDueDate forKey: @"due_date"];
    [_queue addOperation: [[CreateTaskOperation alloc] initWithTaskDictionary: dictionary taskObservers: selectedObserverIds]];
}

- (void) handleValidation: (id) sender {

    submitButton.enabled = YES;
    //    submitButton.enabled = !(selectedJobId == nil || selectedServiceItemId == nil || selectedAssigneeId == nil || selectedTaskTitle == nil);
}

- (IBAction) handleDatePicker: (NSButton *) sender {

    BasicDatePickerCell *dateCell = (BasicDatePickerCell *) sender.superview;
    currentDateCell = dateCell;

    CGPoint point = [self.view convertPoint: sender.origin fromView: sender];

    datePicker.right = sender.left - 5;
    //    datePicker.top = point.y - sender.height + 5;
    datePicker.top = point.y - datePicker.height;

    if (datePicker.superview) {
        [datePicker removeFromSuperview];
    } else {
        [self.view addSubview: datePicker];
    }
}

- (void) showDatePicker: (id) sender {
}

- (void) hideDatePicker: (id) sender {
    [datePicker removeFromSuperview];
}

#pragma mark Callbacks

- (void) serviceItemsDidUpdate {
    [self prepareDataSource];
    [table reloadData];
}

- (void) fetchedAssignees: (NSArray *) array forJobId: (NSString *) jobId {
    if ([jobId isEqualToString: selectedJobId]) {

        assigneeTokenField.rowObject.content = array;
        //        assigneesSource = array;
        //        assigneeTokenField.dataSource = assigneesSource;
        //        assigneeTokenField.textField.enabled = YES;
        [assigneeActivityView stopAnimating];

        if (selectedAssigneeId != nil) {
            //            [assigneeTokenField didSelectObject: _model.selectedTask.assignee];
        }
    }
}

- (void) didCreateTask: (Task *) task {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self handleCancelButton: self];
}



#pragma mark UITextField



- (void) textFieldEndedEditing: (NSTextField *) textField withRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tablesection {
    [super textFieldEndedEditing: textField withRowObject: rowObject tableSection: tablesection];

    if ([rowObject.textLabel isEqualToString: @"Task"]) {
        selectedTaskTitle = textField.stringValue;
    } else if ([rowObject.textLabel isEqualToString: @"Notes"]) {
        selectedNotes = textField.stringValue;
    } else if ([rowObject.textLabel isEqualToString: @"Start Date"]) {
        selectedStartDate = textField.stringValue;
    } else if ([rowObject.textLabel isEqualToString: @"Due Date"]) {
        selectedDueDate = textField.stringValue;
    }

    if (selectedNotes == nil) selectedNotes = @"";
    if (selectedStartDate == nil) selectedStartDate = @"";
    if (selectedDueDate == nil) selectedDueDate = @"";
    [self handleValidation: self];
}


#pragma mark Keyboard
//
//
//- (void) keyboardWillShowForTextField: (UITextField *) textField {
//    [super keyboardWillShowForTextField: textField];
//    HomeViewController *homeController = (HomeViewController *) [Model sharedModel].homeController;
//    [homeController keyboardWillShowForTextField: textField];
//}
//
//- (void) keyboardWillHide: (NSNotification *) notification {
//    [super keyboardWillHide: notification];
//    HomeViewController *homeController = (HomeViewController *) [Model sharedModel].homeController;
//    [homeController keyboardWillHide: nil];
//}


#pragma mark NSTokenField


- (NSArray *) tokenField: (NSTokenField *) tokenField shouldAddObjects: (NSArray *) tokens atIndex: (NSUInteger) index1 {
    [self handleTokenValidation: tokenField];
    [self handleValidation: self];

    NSString *lastToken = [tokens lastObject];
    BasicTokenField *basicTokenField = (BasicTokenField *) tokenField;
    if (basicTokenField.rowObject.content != nil) {
        NSArray *array = basicTokenField.rowObject.content;
        array = [self titlesForObjects: array];
        if (![array containsObject: lastToken]) {
            NSMutableArray *tokensEdited = [[NSMutableArray alloc] initWithArray: tokens];
            [tokensEdited removeObject: lastToken];
            tokens = tokensEdited;
        }
    }

    return tokens;
}

- (NSString *) tokenField: (NSTokenField *) tokenField displayStringForRepresentedObject: (id) representedObject {
    [self handleTokenValidation: tokenField];
    [self handleValidation: self];
    return nil;
}

- (NSArray *) tokenField: (NSTokenField *) tokenField completionsForSubstring: (NSString *) substring indexOfToken: (NSInteger) tokenIndex  indexOfSelectedItem: (NSInteger *) selectedIndex {
    NSArray *ret = [NSArray array];
    if ([tokenField isKindOfClass: [BasicTokenField class]]) {
        BasicTokenField *basicTokenField = (BasicTokenField *) tokenField;
        TableRowObject *rowObject = basicTokenField.rowObject;

        if (rowObject.content != nil) {
            NSArray *array = [NSArray arrayWithArray: rowObject.content];
            array = [self titlesForObjects: array];
            ret = [array filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"SELF beginswith[cd] %@", substring]];
        }
    }
    return ret;
}

- (NSArray *) titlesForObjects: (NSArray *) objects {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (id object in objects) {
        [titles addObject: [NSString stringWithFormat: @"%@", [object valueForKey: @"title"]]];
    }
    return titles;
}

- (void) handleTokenValidation: (NSTokenField *) tokenField {
    selectedServiceItemId = [_model serviceItemIdForTitle: [serviceItemTokenField.objectValue lastObject]];
    selectedJobId = [_model jobIdForTitle: [jobTokenField.objectValue lastObject]];
    selectedAssigneeId = [_model contactIdForTitle: [assigneeTokenField.objectValue lastObject]];
    selectedObserverIds = [NSMutableArray arrayWithArray: [_model contactIdsForTitles: observersTokenField.objectValue]];

    if (tokenField == jobTokenField && selectedJobId != nil) {
        [_queue addOperation: [[GetAssigneeProcess alloc] initWithJobId: selectedJobId]];
    }
}



//
//- (NSArray *) tokenField: (BasicTokenField *) tokenField completionsForString: (NSString *) substring rowObject: (TableRowObject *) rowObject {
//
//    NSArray *ret = [NSArray array];
//    NSArray *array;
//
//    if (rowObject.content && [rowObject.content isKindOfClass: [NSArray class]]) {
//        array = [NSArray arrayWithArray: rowObject.content];
//    } else {
//        if ([rowObject.textLabel isEqualToString: @"Assignee"]) {
//            if (assigneesSource && [assigneesSource count] > 0) {
//                array = [_model contactTitlesForContacts: assigneesSource];
//            }
//        }
//    }
//
//    if (array != nil) {
//        ret = [array filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"SELF beginswith[cd] %@", substring]];
//    } else {
//        NSLog(@"no array");
//    }
//
//    if ([rowObject.textLabel isEqualToString: @"Job"]) {
//        NSLog(@"rowObject.content = %@", rowObject.content);
//    }
//    return ret;
//}
//- (NSArray *) tokenField: (NSTokenField *) tokenField shouldAddObjects: (NSArray *) tokens atIndex: (NSUInteger) index1 {
//    NSString *string = [tokens lastObject];
//
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//
//    if (tokenField == jobTokenField) {
//        selectedJobId = [_model jobIdForTitle: string];
//        [_queue addOperation: [[GetAssigneeProcess alloc] initWithJobId: selectedJobId]];
//    } else if (tokenField == serviceItemTokenField) {
//        selectedServiceItemId = [_model serviceItemIdForTitle: string];
//    } else if (tokenField == assigneeTokenField) {
//        selectedAssigneeId = [_model contactIdForTitle: string];
//    } else if (tokenField == observersTokenField) {
//        selectedObserverIds = [NSMutableArray arrayWithArray: [_model contactIdsForTitles: tokens]];
//    }
//
//    [self handleValidation: self];
//    return tokens;
//}
//
//- (BOOL) tokenField: (NSTokenField *) tokenField hasMenuForRepresentedObject: (id) representedObject {
//    return NO;
//}
//
//- (NSMenu *) tokenField: (NSTokenField *) tokenField menuForRepresentedObject: (id) representedObject {
//    if (tokenField == serviceItemTokenField) {
//        return serviceItemMenu;
//    }
//    return nil;
//}


//- (NSString *) tokenField: (NSTokenField *) tokenField displayStringForRepresentedObject: (id) representedObject {
//
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    return nil;
//}





#pragma mark NSDatePicker

- (void) datePickerCell: (NSDatePickerCell *) aDatePickerCell validateProposedDateValue: (NSDate **) proposedDateValue timeInterval: (NSTimeInterval *) proposedTimeInterval {

    NSDate *date = *proposedDateValue;
    NSString *dateString = [_model.slugFormatter stringFromDate: date];


    NSString *placeholderString = [currentDateCell.textField.cell placeholderString];
    if ([placeholderString isEqualToString: @"Start Date"]) {
        selectedStartDate = dateString;
    } else if ([placeholderString isEqualToString: @"Due Date"]) {
        selectedDueDate = dateString;
    }
    currentDateCell.textField.stringValue = dateString;
    [self hideDatePicker: self];
}

@end