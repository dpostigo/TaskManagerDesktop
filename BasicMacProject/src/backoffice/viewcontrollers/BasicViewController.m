//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicViewController.h"


@implementation BasicViewController {
}


@synthesize titleLabel;



- (void) loadView {
    [super loadView];
    if (self.titleLabel != nil) self.titleLabel.stringValue = self.title;
}


@end