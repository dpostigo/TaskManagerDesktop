//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOWhiteTextButton.h"
#import "NSButton+TextColor.h"


@implementation BOWhiteTextButton {
}


- (void) setup {

    self.textColor = [NSColor colorWithDeviceWhite: 0.9 alpha: 1.0];
}

- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {
        [self setup];
    }

    return self;
}

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        [self setup];
    }

    return self;
}

@end