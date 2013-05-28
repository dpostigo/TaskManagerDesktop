//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOModalBackgroundView.h"


@implementation BOModalBackgroundView {
}


- (void) setup {
    [super setup];
    self.cornerRadius = 10.0;
    self.borderColor = [NSColor whiteColor];
    self.borderWidth = 0.0;
    self.gradient = [[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithDeviceWhite: 0.85f alpha: 1.0f], 0.0f,
            [NSColor colorWithDeviceWhite: 0.90f alpha: 1.0f], 0.2f,
            [NSColor colorWithDeviceWhite: 0.93f alpha: 1.0f], 0.5f,
            [NSColor colorWithDeviceWhite: 0.94f alpha: 1.0f], 0.7f,
            [NSColor colorWithDeviceWhite: 0.95f alpha: 1.0f], 1.0f,
            nil];

    self.cornerOptions = JSUpperLeftCorner | JSUpperRightCorner | JSLowerRightCorner | JSLowerLeftCorner;
}

@end