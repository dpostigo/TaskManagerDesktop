//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOModalFooterBackgroundView.h"
#import "NSBezierPath+DPUtils.h"


@implementation BOModalFooterBackgroundView {
}


- (void) setup {
    [super setup];

    self.cornerRadius = MODAL_CORNER_RADIUS;
    self.cornerOptions = JSLowerLeftCorner | JSLowerRightCorner;
    self.borderColor = [NSColor blackColor];
    self.gradient = [[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithDeviceWhite: 0.15f alpha: 1.0f], 0.0f,
            [NSColor colorWithDeviceWhite: 0.19f alpha: 1.0f], 0.5f,
            [NSColor colorWithDeviceWhite: 0.20f alpha: 1.0f], 0.5f,
            [NSColor colorWithDeviceWhite: 0.25f alpha: 1.0f], 1.0f,
            nil];

    self.shadow.shadowColor = [NSColor clearColor];
}

- (void) drawRect: (NSRect) dirtyRect {

    if (shadow.shadowColor != [NSColor clearColor]) {
        NSRect newRect = self.bounds;
        newRect.size.height -= 3;

        NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect: newRect xRadius: cornerRadius yRadius: cornerRadius];

        [roundedPath drawShadow: shadow shadowOpacity: 0.5];

        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: newRect xRadius: cornerRadius yRadius: cornerRadius];
        [gradient drawInBezierPath: path angle: 90];
        [roundedPath addClip];
        [borderColor setStroke];
        [path stroke];
    } else {
        NSRect bounds = self.bounds;
        if (cornerRadius > 0) {
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: self.bounds xRadius: cornerRadius yRadius: cornerRadius];
            [gradient drawInBezierPath: path angle: 90];
            [self.borderColor setStroke];
            [path setLineWidth: self.borderWidth];
            [path setLineCapStyle: NSRoundLineCapStyle];
            [path stroke];
        } else {
            [gradient drawInRect: bounds angle: 90.0f];
            [self.borderColor setStroke];
            [NSBezierPath strokeRect: bounds];
        }
    }
}


@end