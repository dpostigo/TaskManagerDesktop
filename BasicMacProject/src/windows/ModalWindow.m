//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ModalWindow.h"


@implementation ModalWindow {
}


- (void) setup {
    [self setOpaque: NO];
    self.autorecalculatesKeyViewLoop = YES;
}

- (id) initWithContentRect: (NSRect) contentRect styleMask: (NSUInteger) aStyle backing: (NSBackingStoreType) bufferingType defer: (BOOL) flag {
    self = [super initWithContentRect: contentRect styleMask: aStyle backing: bufferingType defer: flag];
    if (self) {
        [self setup];
    }

    return self;
}

- (BOOL) canBecomeKeyWindow {
    return YES;
}

@end