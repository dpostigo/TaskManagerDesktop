//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LoginTableViewController.h"
#import "BasicSecureTextField.h"
#import "LoginOperation.h"
#import "BOGoldButtonCell.h"


@implementation LoginTableViewController {
    NSString *selectedUsername;
    NSString *selectedPassword;
}


@synthesize window;
@synthesize usernameField;
@synthesize passwordField;

- (void) loadView {
    [super loadView];

    BOGoldButtonCell *cell = submitButton.cell;
    cell.cornerRadius = 6.0;
}

- (void) prepareDataSource {
    [super prepareDataSource];

    TableSection *tableSection = [[TableSection alloc] initWithTitle: @"Section"];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"HeaderCell" cellIdentifier: @"HeaderCell"]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Username" cellIdentifier: @"TextFieldCell"]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Password" cellIdentifier: @"PasswordCell"]];
    [dataSource addObject: tableSection];

}


#pragma mark UITableView

- (CGFloat) heightForRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    if ([rowObject.cellIdentifier isEqualToString: @"HeaderCell"]) return 120;
    return [super heightForRowObject: rowObject tableSection: tableSection];
}


- (void) configureCell: (BasicTableCellView *) cell forRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    [super configureCell: cell forRowObject: rowObject tableSection: tableSection];
    cell.textField.stringValue = @"";

    if ([cell.textField isKindOfClass: [BasicTextField class]]) {
        BasicTextField *basicTextField = (BasicTextField *) cell.textField;
        basicTextField.rowObject = rowObject;
        basicTextField.tableSection = tableSection;
    } else if ([cell.textField isKindOfClass: [BasicSecureTextField class]]) {
        BasicSecureTextField *secureTextField = (BasicSecureTextField *) cell.textField;
        secureTextField.rowObject = rowObject;
        secureTextField.tableSection = tableSection;
    }

    if ([rowObject.textLabel isEqualToString: @"Username"]) {
        self.usernameField = cell.textField;
        if (window) {
            window.initialFirstResponder = cell.textField;
        }
    } else if ([rowObject.textLabel isEqualToString: @"Password"]) {
        self.passwordField = cell.textField;

        usernameField.nextKeyView = passwordField;
        passwordField.nextKeyView = submitButton;
    }

    [self subscribeControl: cell.textField];
}



#pragma mark IBActions

- (IBAction) handleSubmitButton: (id) sender {
    [super handleSubmitButton: sender];


    [self resignAllTextFields];

    if (selectedUsername == nil || selectedPassword == nil) return;
    [_queue addOperation: [[LoginOperation alloc] initWithUsername: selectedUsername password: selectedPassword]];
}




#pragma mark Callbacks



- (void) loginSucceeded {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    //    [SVProgressHUD showSuccessWithStatus: @"Success!"];
}

- (void) loginFailedWithMessage: (NSString *) message {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    //    [SVProgressHUD showErrorWithStatus: message];
}



#pragma mark TextField

- (void) textFieldEndedEditing: (NSTextField *) textField withRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tablesection {
    [super textFieldEndedEditing: textField withRowObject: rowObject tableSection: tablesection];

    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([rowObject.textLabel isEqualToString: @"Username"]) {
        selectedUsername = textField.stringValue;
        //        [passwordField becomeFirstResponder];
    } else if ([rowObject.textLabel isEqualToString: @"Password"]) {
        selectedPassword = textField.stringValue;
        //        NSSecureTextField *secureTextField = textField;
        //        NSLog(@"secureTextField.stringValue = %@", secureTextField.stringValue);

        //        [submitButton becomeFirstResponder];
    }
}

@end