//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicCustomRowView.h"
#import "NSBezierPath+DPUtils.h"


@implementation BasicCustomRowView


@synthesize cornerRadius;
@synthesize cornerOptions;
@synthesize borderColor;
@synthesize gradient;

@synthesize shadow;
@synthesize shadowOpacity;


@synthesize insetRect;

@synthesize borderWidth;


@synthesize selectedGradient;

- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {

        insetRect = NSZeroRect;

        shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [NSColor blackColor];
        shadow.shadowBlurRadius = 2.0;
        shadow.shadowOffset = NSMakeSize(0, -1);
        shadowOpacity = 0.5;

        cornerRadius = 2.0;
        cornerOptions = JSUpperLeftCorner | JSUpperRightCorner | JSLowerLeftCorner | JSLowerRightCorner;
        [NSColor colorWithCalibratedWhite: 0.89 alpha: 1.0];
        borderColor = [NSColor whiteColor];
        borderWidth = 1.0;
        gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceWhite: 0.85f alpha: 1.0f], 0.0f,
                [NSColor colorWithDeviceWhite: 0.90f alpha: 1.0f], 0.2f,
                [NSColor colorWithDeviceWhite: 0.93f alpha: 1.0f], 0.5f,
                [NSColor colorWithDeviceWhite: 0.94f alpha: 1.0f], 0.7f,
                [NSColor colorWithDeviceWhite: 0.95f alpha: 1.0f], 1.0f,
                nil];

    }

    return self;
}

- (NSRect) modifiedRect: (NSRect) rect {
    rect.origin.x += insetRect.origin.x;
    rect.origin.y += insetRect.origin.y;
    rect.size.width += insetRect.size.width;
    rect.size.height += insetRect.size.height;
    return rect;
}

- (void) drawBackgroundInRect: (NSRect) dirtyRect {
    BOOL selected = self.selected;
    NSRect rect = [self modifiedRect: self.bounds];
    [self drawBackgroundInRect: rect selected: selected];
}


- (void) drawBackgroundInRect: (NSRect) dirtyRect selected: (BOOL) selected {

    NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect: dirtyRect xRadius: cornerRadius yRadius: cornerRadius];
    [roundedPath drawShadow: shadow shadowOpacity: shadowOpacity];

    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: dirtyRect xRadius: cornerRadius yRadius: cornerRadius];
    [path drawGradient: gradient angle: -90];

    if (selected) {

        if (selectedGradient == nil) {
            [path drawGradient: gradient angle: 90];
        } else {
            [path drawGradient: selectedGradient angle: 90];
        }
    }


    [path drawStroke: borderColor width: borderWidth];

}


- (void) setSelected: (BOOL) selected {
    if (selected != self.isSelected) [self setNeedsDisplay: YES];
    [super setSelected: selected];
}


- (BOOL) isOpaque {
    return NO;
}

@end