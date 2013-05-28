//
// Created by Daniela Postigo on 4/21/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicTableArrayController.h"


@implementation BasicTableArrayController


- (void) loadView {
    [super loadView];

    table.dataSource = self;
    table.delegate = self;
}


#pragma mark UITableView



- (NSInteger) numberOfRowsInTableView: (NSTableView *) tableView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [arraySource count];
}




#pragma mark IBActions


#pragma mark Callbacks



@end