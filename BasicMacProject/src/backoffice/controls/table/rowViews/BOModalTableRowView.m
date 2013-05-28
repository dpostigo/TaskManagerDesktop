//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOModalTableRowView.h"
#import "KGNoise.h"
#import "NSBezierPath+DPUtils.h"


@implementation BOModalTableRowView {
}


- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {

        shadow.shadowBlurRadius = 2.0;
        shadow.shadowOffset = NSMakeSize(0, -1);
        shadow.shadowColor = [NSColor lightGrayColor];

        cornerRadius = 0.0;
        backgroundFillColor = [NSColor colorWithCalibratedWhite: 0.95 alpha: 1.0];
        borderColor = [NSColor clearColor];

        gradientColor = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceWhite: 0.85 alpha: 1.0f], 0.0,
                [NSColor colorWithDeviceWhite: 0.90 alpha: 1.0f], 0.2,
                [NSColor colorWithDeviceWhite: 0.93 alpha: 1.0f], 0.5,
                [NSColor colorWithDeviceWhite: 0.94 alpha: 1.0f], 0.7,
                [NSColor colorWithDeviceWhite: 0.95 alpha: 1.0f], 1.0,
                nil];


        noiseOpacity = 0.25;
        selectedNoiseOpacity = 0.1;
    }

    return self;
}



@end