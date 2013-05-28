//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicListViewController.h"


@implementation BasicListViewController {
}


@synthesize dataSource;

- (void) loadView {
    [super loadView];
    [self prepareDataSource];
}

- (void) prepareDataSource {
    self.dataSource = [[NSMutableArray alloc] init];
}

#pragma mark UITableView


#pragma mark IBActions


#pragma mark Callbacks


@end