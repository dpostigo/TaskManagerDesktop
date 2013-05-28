//
// Created by Daniela Postigo on 5/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicFullWindow.h"


@implementation BasicFullWindow {
}


@synthesize mainView;

@synthesize mainSplitView;

@synthesize bottomSplitView;

- (id) initWithContentRect: (NSRect) contentRect styleMask: (NSUInteger) aStyle backing: (NSBackingStoreType) bufferingType defer: (BOOL) flag {
    self = [super initWithContentRect: contentRect styleMask: aStyle backing: bufferingType defer: flag];
    if (self) {
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];

    mainSplitView.dividerColor = [NSColor colorWithDeviceWhite: 1.0 alpha: 0.0];
}

@end