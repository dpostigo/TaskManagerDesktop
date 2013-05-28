//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicTableViewDelegate.h"


@implementation BasicTableViewDelegate {
}


@synthesize dataSource;
@synthesize viewController;

- (id) initWithViewController: (BasicTableViewController *) aViewController {
    self = [super init];
    if (self) {
        self.viewController = aViewController;
    }

    return self;
}

- (NSInteger) numberOfRowsInTableView: (NSTableView *) tableView {
    return [viewController numberOfRowsInTableView: tableView];
}

- (id) tableView: (NSTableView *) tableView objectValueForTableColumn: (NSTableColumn *) tableColumn row: (NSInteger) row {
    return [viewController tableView: tableView objectValueForTableColumn: tableColumn row: row];
}

- (NSView *) tableView: (NSTableView *) tableView viewForTableColumn: (NSTableColumn *) tableColumn row: (NSInteger) row {
    return [viewController tableView: tableView viewForTableColumn: tableColumn row: row];
}

- (CGFloat) tableView: (NSTableView *) tableView heightOfRow: (NSInteger) row {
    return [viewController tableView: tableView heightOfRow: row];
}

- (BOOL) selectionShouldChangeInTableView: (NSTableView *) tableView {
    return [viewController selectionShouldChangeInTableView: tableView];
}

- (NSTableRowView *) tableView: (NSTableView *) tableView rowViewForRow: (NSInteger) row {
    return [viewController tableView: tableView rowViewForRow: row];
}

@end