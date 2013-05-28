//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NavigationBar.h"


@implementation NavigationBar {
}


@synthesize backButtonItem;
@synthesize barButtonHeight;

@synthesize titleLabel;

- (void) setup {
    [super setup];
    self.barButtonHeight = 25;
    shadow.shadowColor = [NSColor blackColor];
    shadow.shadowOffset = NSMakeSize(0, -1);
    shadow.shadowBlurRadius = 2.0;
}

- (void) awakeFromNib {
    [super awakeFromNib];

}

@end