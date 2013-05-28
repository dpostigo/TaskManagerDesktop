//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LoginOutlineViewController.h"
#import "TableSection.h"
#import "TableRowObject.h"
#import "OutlineSection.h"
#import "BasicTextFieldCellView.h"


@implementation LoginOutlineViewController {
}


- (void) loadView {
    [super loadView];
    outline.allowsTypeSelect = NO;

    [outline expandItem: nil expandChildren: YES];
}

- (void) prepareDataSource {
    [super prepareDataSource];

    OutlineSection *tableSection = [[OutlineSection alloc] initWithTitle: @"Section" isExpandable: NO];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Username" cellIdentifier: @"TextFieldCell"]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Password"]];
    [dataSource addObject: tableSection];
}




#pragma mark BasicOutlineViewController

- (CGFloat) heightForHeaderSection: (OutlineSection *) outlineSection {
    return 0;
}

- (CGFloat) heightForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection {
    return 30;
}





#pragma mark IBActions


#pragma mark Callbacks


#pragma mark BasicOutlineViewController


- (void) configureCell: (BasicTableCellView *) cell forRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection {
    [super configureCell: cell forRowObject: rowObject outlineSection: outlineSection];

    [cell.textField.cell setPlaceholderString: rowObject.textLabel];
    cell.textField.stringValue = @"";
}

@end