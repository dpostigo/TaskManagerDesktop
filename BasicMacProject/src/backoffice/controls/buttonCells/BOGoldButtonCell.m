//
// Created by Daniela Postigo on 5/11/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOGoldButtonCell.h"
#import "NSColor+Utils.h"


@implementation BOGoldButtonCell {
}


- (void) setup {
    [super setup];

    gradientColor = [[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithString: @"be955b"], 0.0,
            [NSColor colorWithString: @"efb564"], 1.0,
            nil];

    strokeColor = [NSColor blackColor];
    innerStrokeColor = [NSColor colorWithString: @"fece80"];

    cornerRadius = 10.0;
    imageColor = [NSColor redColor];

    [self setButtonType: NSMomentaryPushButton];
    self.bezelStyle = NSSmallSquareBezelStyle;

    textShadow.shadowColor = [NSColor colorWithString: @"7b5e36"];

    disabledTextColor = [NSColor colorWithString: @"595959"];
    disabledTextShadow.shadowColor = [NSColor colorWithDeviceWhite: 1.0 alpha: 0.5];
    disabledTextShadow.shadowBlurRadius = 1.0;
    disabledTextShadow.shadowOffset = NSMakeSize(0, -1.0);
}

@end