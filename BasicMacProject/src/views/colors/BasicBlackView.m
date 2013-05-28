//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicBlackView.h"
#import "NSGraphicsContext+DPUtils.h"


@implementation BasicBlackView {
}


- (void) setup {
    [super setup];

    self.borderColor = [NSColor blackColor];
    self.gradient = [[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithDeviceWhite: 0.15f alpha: 1.0f], 0.0f,
            [NSColor colorWithDeviceWhite: 0.19f alpha: 1.0f], 0.5f,
            [NSColor colorWithDeviceWhite: 0.20f alpha: 1.0f], 0.5f,
            [NSColor colorWithDeviceWhite: 0.25f alpha: 1.0f], 1.0f,
            nil];
}


@end