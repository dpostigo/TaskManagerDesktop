//
// Created by Daniela Postigo on 5/7/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicArrayViewController.h"


@implementation BasicArrayViewController


@synthesize arraySource;
@synthesize arrayController;

- (void) loadView {
    [super loadView];

    self.arraySource = [[NSMutableArray alloc] init];
    [self prepareDataSource];
}

#pragma mark BasicArrayViewController

- (void) prepareDataSource {
}
@end