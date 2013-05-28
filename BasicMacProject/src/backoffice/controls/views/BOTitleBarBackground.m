//
// Created by Daniela Postigo on 5/20/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOTitleBarBackground.h"


@implementation BOTitleBarBackground {
}


- (void) setup {
    [super setup];
    self.cornerRadius = MODAL_CORNER_RADIUS;
    self.cornerOptions = JSUpperLeftCorner | JSUpperRightCorner;
    self.borderColor = [NSColor blackColor];
    self.gradient = [[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithDeviceWhite: 0.15f alpha: 1.0f], 0.0f,
            [NSColor colorWithDeviceWhite: 0.19f alpha: 1.0f], 0.5f,
            [NSColor colorWithDeviceWhite: 0.20f alpha: 1.0f], 0.5f,
            [NSColor colorWithDeviceWhite: 0.25f alpha: 1.0f], 1.0f,
            nil];

    self.shadow.shadowColor = [NSColor clearColor];
}

@end