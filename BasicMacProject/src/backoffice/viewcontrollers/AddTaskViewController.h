//
// Created by Daniela Postigo on 5/9/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicTableArrayController.h"
//#import "TITokenField.h"
//#import "DPTokenTextField.h"
#import "BasicTableViewController.h"
#import "ActivityView.h"
#import "BasicTokenField.h"


@interface AddTaskViewController : BasicTableViewController <NSTokenFieldDelegate, NSDatePickerCellDelegate>
//        <TokenTextFieldDelegate>
{

    IBOutlet NSDatePicker *datePicker;
    NSString *selectedJobId;
    NSString *selectedTaskTitle;
    NSString *selectedNotes;
    NSString *selectedStartDate;
    NSString *selectedDueDate;
    NSString *selectedServiceItemId;
    NSString *selectedAssigneeId;
    NSMutableArray *selectedObserverIds;


    BasicTokenField *assigneeTokenField;
    BasicTokenField *serviceItemTokenField;
    BasicTokenField *jobTokenField;
    BasicTokenField *observersTokenField;


    NSMutableDictionary *textFieldDict;

    NSArray *assigneesSource;
    ActivityView *assigneeActivityView;

    CGSize modalSize;

    NSMutableDictionary *imageDictionary;
}


@property(nonatomic) CGSize modalSize;
//@property(nonatomic, strong) DPTokenTextField *jobTokenField;
//@property(nonatomic, strong) DPTokenTextField *assigneeTokenField;
//@property(nonatomic, strong) DPTokenTextField *serviceItemTokenField;
//@property(nonatomic, strong) DPTokenTextField *observersTokenField;
- (IBAction) handleCreateButton: (id) sender;
- (void) handleValidation: (id) sender;
- (IBAction) handleDatePicker: (id) sender;
@end