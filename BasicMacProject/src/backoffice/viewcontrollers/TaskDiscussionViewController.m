//
// Created by Daniela Postigo on 5/12/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TaskDiscussionViewController.h"
#import "BasicTableCellView.h"
#import "NSString+Utils.h"
#import "GetDiscussionProcess.h"
#import "BasicTextFieldCellView.h"
#import "DiscussionItem.h"
#import "TTTTimeIntervalFormatter.h"
#import "PostCommentOperation.h"
#import "NSString+JSAdditions.h"
#import "BasicCustomRowView.h"
#import "BODiscussionRowView.h"
#import "NSColor+Utils.h"
#import "NSButton+DPUtils.h"
#import "BODiscussionFooterRowView.h"
#import "NSImageView+DPImageManager.h"

#define KEYBOARD_HEIGHT 0


@implementation TaskDiscussionViewController {
    TTTTimeIntervalFormatter *formatter;
    BasicTextFieldCellView *footerCell;
    NSString *selectedCommentText;
    NSTextField *commentTextField;
    NSButton *postButton;
    CGFloat keyboardHeight;
    DiscussionItem *tempItem;
}


@synthesize detailController;

- (void) loadView {
    [super loadView];
    formatter = [[TTTTimeIntervalFormatter alloc] init];
    keyboardHeight = 300;
    self.allowsSelection = NO;
    [_queue addOperation: [[GetDiscussionProcess alloc] initWithTask: _model.selectedTask]];
}




#pragma mark UITableView

- (void) prepareDataSource {
    [super prepareDataSource];

    [dataSource removeAllObjects];

    TableSection *tableSection = [[TableSection alloc] initWithTitle: @"Content"];

    if ([_model.selectedTask.discussion count] > 0) {
        for (DiscussionItem *item in _model.selectedTask.discussion) {
            [tableSection.rows addObject: [[TableRowObject alloc] initWithContent: item cellIdentifier: @"DataCell"]];
        }
    }

    [tableSection.rows addObject: [[TableRowObject alloc] initWithContent: nil cellIdentifier: @"FooterCell"]];
    [dataSource addObject: tableSection];

}


- (CGFloat) heightForRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    if ([rowObject.cellIdentifier isEqualToString: @"FooterCell"]) {
        return table.rowHeight;
    }

    DiscussionItem *item = rowObject.content;
    NSString *text = item.text;
    CGSize constraint = CGSizeMake(table.width - (10 * 2), 20000.0f);

    NSSize size = [text sizeWithWidth: constraint.width andFont: [NSFont systemFontOfSize: 12.0]];
    CGFloat height = MAX(size.height, 68.0f);
    return height + (5 * 2);
}


- (NSTableRowView *) tableRowView: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    NSTableRowView *rowView = nil;

    if ([rowObject.cellIdentifier isEqualToString: @"FooterCell"]) {
        rowView = [[BODiscussionFooterRowView alloc] init];
    } else {
        rowView = [[BODiscussionRowView alloc] init];
        rowView.width -= 60;
    }

    return rowView;
}


- (void) configureCell: (BasicTableCellView *) tableCell forRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
    //    [super configureCell: cell forRowObject: rowObject tableSection: tableSection];


    BasicTextFieldCellView *cell = (BasicTextFieldCellView *) tableCell;

    if ([rowObject.cellIdentifier isEqualToString: @"DataCell"]) {

        DiscussionItem *item = rowObject.content;
        cell.textLabel.stringValue = item.text;


        if (item.contact == nil) {
            User *contact = [_model contactForId: item.contactId];
        } else {


            [cell.imageView setImageWithURL: [item.contact.thumbnailURL URL]];

            //            [cell.imageView prettifyWithBackgroundColor: [UIColor clearColor]];
        }
        cell.detailTextLabel.text = [formatter stringForTimeIntervalFromDate: item.createdDate toDate: [NSDate date]];

        //        [cell.imageView rasterize];
    } else if ([rowObject.cellIdentifier isEqualToString: @"FooterCell"]) {


        [cell.imageView setImageWithURL: [_model.currentUser.thumbnailURL URL]];

        //        [cell.imageView prettifyWithBackgroundColor: [UIColor clearColor]];
        //        [self subscribeTextField: cell.textField];

        [cell.textField.cell setPlaceholderString: @"Add a comment..."];
        commentTextField = cell.textField;
        postButton = cell.button;
        [cell.button addTarget: self action: @selector(handlePostButton:)];
    }


    //    BasicWhiteView *imagePrettyView = [[BasicWhiteView alloc] initWithFrame: cell.imageView.frame];
    //    imagePrettyView.cornerRadius = 3.0;
    //    imagePrettyView.borderColor = [NSColor colorWithDeviceWhite: 0.0 alpha: 0.5];
    //    imagePrettyView.shadow.shadowColor = [NSColor blackColor];
    //    //    imagePrettyView.height = cell.imageView.image.size.height;
    //    //    imagePrettyView.width = cell.imageView.image.size.width;
    //    imagePrettyView.gradient = [[NSGradient alloc] initWithStartingColor: [NSColor clearColor] endingColor: [NSColor colorWithDeviceWhite: 1.0 alpha: 0.5]];
    //    [cell.imageView.superview addSubview: imagePrettyView];
    ////    [imagePrettyView addSubview: cell.imageView];
    //    cell.imageView.top = 0;
    //    cell.imageView.left = 0;
    //    imagePrettyView.autoresizingMask = cell.imageView.autoresizingMask;
    //    //
    //    [cell rasterize];
}



#pragma mark IBActions

- (IBAction) handlePostButton: (id) sender {
    NSButton *button = sender;
    button.enabled = NO;
    [commentTextField resignFirstResponder];
    selectedCommentText = commentTextField.stringValue;

    //    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    //    activityView.centerY = button.centerY;
    //    activityView.right = button.left - 10;
    //    [button.superview addSubview: activityView];
    //    [activityView startAnimating];

    DiscussionItem *item = [[DiscussionItem alloc] init];
    item.contact = _model.currentUser;
    item.text = selectedCommentText == nil ? @"" : selectedCommentText;
    //    [self addDiscussionItem: item];

    [_queue addOperation: [[PostCommentOperation alloc] initWithTask: _model.selectedTask discussionItem: item]];
}


#pragma mark Callbacks


- (void) discussionDidUpdateForTask: (Task *) task {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    //    TableSection *tableSection = [dataSource objectAtIndex: 0];
    //    for (DiscussionItem *discussionItem in _model.selectedTask.discussion) {
    //        [tableSection.rows addObject: [[TableRowObject alloc] initWithContent: discussionItem cellIdentifier: @"MessageCell"]];
    //    }
    //    [dataSource addObject: tableSection];
    //
    //    NSArray *indexPaths = [self indexPathsForRowObjects: tableSection.rows inSection: tableSection];
    //    [table insertRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationLeft];


    [self prepareDataSource];
    [table reloadData];
}

- (void) taskUpdated: (Task *) task withNewItem: (DiscussionItem *) item {

    if ([task.id isEqualToString: _model.selectedTask.id]) {
        //        [activityView stopAnimating];
        commentTextField.stringValue = @"";

        [self addDiscussionItem: item];


        //        [self prepareDataSource];
        //        [table reloadData];
    }
}

- (void) addDiscussionItem: (DiscussionItem *) item {
    tempItem = item;
    TableSection *tableSection = [dataSource objectAtIndex: 0];
    TableRowObject *rowObject = [[TableRowObject alloc] initWithContent: item cellIdentifier: @"MessageCell"];
    [_model.selectedTask.discussion addObject: item];
    //    [self insertRowObject: rowObject inSection: tableSection];
}


- (void) selectedTaskDidUpdate {
    [self prepareDataSource];
    [table reloadData];
}


#pragma mark TextFields

//
//- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField {
//    [detailController closeTaskDetails: self];
//    table.tableFooterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, table.width, keyboardHeight)];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection: 1];
//    [table scrollToRowAtIndexPath: indexPath atScrollPosition: UITableViewScrollPositionTop animated: YES];
//    return YES;
//}
//
//- (void) textFieldDidReturn: (UITextField *) aTextField {
//    [super textFieldDidReturn: aTextField];
//    if (aTextField == commentTextField) {
//        selectedCommentText = commentTextField.text;
//    }
//}
//
//- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string {
//    postButton.enabled = [textField.text length] > 0;
//    return [super textField: textField shouldChangeCharactersInRange: range replacementString: string];
//}


#pragma mark Keyboard

//
//- (void) keyboardWillShowForTextField: (UITextField *) textField {
//    [super keyboardWillShowForTextField: textField];
//    //    table.tableFooterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, table.width, KEYBOARD_HEIGHT)];
//}
//
//- (void) keyboardWillShow: (NSNotification *) notification {
//    NSDictionary *keyboardInfo = [notification userInfo];
//    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey: UIKeyboardFrameBeginUserInfoKey];
//    CGRect rect = [keyboardFrameBegin CGRectValue];
//    keyboardHeight = rect.size.height;
//}
//
//- (void) keyboardDidShow: (NSNotification *) notification {
//    [super keyboardDidShow: notification];
//}
//
//- (void) keyboardWillHide: (NSNotification *) notification {
//    [super keyboardWillHide: notification];
//    [self closeTableFooter: nil];
//}


#pragma mark Animations

- (void) closeTableFooter: (id) sender {
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection: 1];
    //
    //    [UIView beginAnimations: @"closeTableFooter" context: nil];
    //    [UIView setAnimationDuration: 0.5];
    //    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    //    [UIView setAnimationDelegate: self];
    //    [UIView setAnimationDidStopSelector: @selector(tableFooterDidClose)];
    //
    //    [UIView commitAnimations];
}

- (void) tableFooterDidClose {
    //    table.tableFooterView = nil;
}

- (void) taskInfoControllerDidClose: (id) object {
}

@end