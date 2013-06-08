//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "BasicListViewController.h"
#import "TableRowObject.h"
#import "TableSection.h"
#import "BasicTableCellView.h"


@class BasicTableViewDelegate;


@interface BasicTableViewController : BasicListViewController {

    BOOL allowsSelection;
    IBOutlet NSTableView *table;
    BasicTableViewDelegate *tableDelegate;
}


@property(nonatomic, strong) NSTableView *table;
@property(nonatomic, strong) BasicTableViewDelegate *tableDelegate;
@property(nonatomic) BOOL allowsSelection;
- (NSInteger) numberOfRowsInTableView: (NSTableView *) tableView;
- (id) tableView: (NSTableView *) tableView objectValueForTableColumn: (NSTableColumn *) tableColumn row: (NSInteger) row;
- (NSView *) tableView: (NSTableView *) tableView viewForTableColumn: (NSTableColumn *) tableColumn row: (NSInteger) row;
- (CGFloat) tableView: (NSTableView *) tableView heightOfRow: (NSInteger) row;
- (BOOL) selectionShouldChangeInTableView: (NSTableView *) tableView;
- (NSTableRowView *) tableView: (NSTableView *) tableView rowViewForRow: (NSInteger) row;
- (NSTableRowView *) tableRowView: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection;
- (CGFloat) heightForRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection;
- (NSView *) cellForRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection;
- (id) objectValueForTableSection: (TableSection *) tableSection andRow: (TableRowObject *) rowObject;
- (void) configureCell: (BasicTableCellView *) cell forRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection;
- (void) insertRowObject: (TableRowObject *) rowObject inSection: (TableSection *) tableSection;
- (void) insertRowObject: (TableRowObject *) rowObject inSection: (TableSection *) tableSection withAnimation: (NSTableViewAnimationOptions) options;
@end