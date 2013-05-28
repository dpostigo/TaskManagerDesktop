//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicButton.h"
#import "BasicButtonCell.h"


@implementation BasicButton {
}


+ (Class) cellClass {
    return NSClassFromString([NSString stringWithFormat: @"%@%@", NSStringFromClass([self class]), @"Cell"]);
}

- (void) setup {
}

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        [self setup];
    }

    return self;
}

- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {
        [self setup];
    }

    return self;
}

@end