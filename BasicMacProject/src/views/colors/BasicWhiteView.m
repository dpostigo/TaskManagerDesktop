//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicWhiteView.h"
#import "NSBezierPath+DPUtils.h"


@implementation BasicWhiteView {
}


- (void) setup {
    [super setup];

    self.cornerRadius = 2.0;
    self.borderColor = [NSColor whiteColor];
    self.gradient = [[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithDeviceWhite: 0.85f alpha: 1.0f], 0.0f,
            [NSColor colorWithDeviceWhite: 0.90f alpha: 1.0f], 0.2f,
            [NSColor colorWithDeviceWhite: 0.93f alpha: 1.0f], 0.5f,
            [NSColor colorWithDeviceWhite: 0.94f alpha: 1.0f], 0.7f,
            [NSColor colorWithDeviceWhite: 0.95f alpha: 1.0f], 1.0f,
            nil];


    //    shadow.shadowColor = [NSColor blackColor];
    //    shadow.shadowBlurRadius = 2.0;
    //    shadow.shadowOffset = NSMakeSize(0, -1);
    //    shadowOpacity = 0.5;
}


@end