//
//  JSBinaryTableRowView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 23/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSBinaryTableRowView.h"
#import "NSBezierPath+Additions.h"
#import "KGNoise.h"


#define INSETX 16.0f
#define INSETY 7.0f
#define RADIUS 6.0f
#define LEFT_RECT_WIDTH 125.0f // this is the width of the grey part of the cell
#define SHADOW_BLUR_RADIUS 4.0f
#define SHADOW_OPACITY 0.4f
#define SHADOW_OFFSET_X 2.0f
#define SHADOW_OFFSET_Y -2.0f
#define LEFT_SIDE_CELL_COLOR [NSColor colorWithCalibratedWhite:0.85 alpha:1.0]
#define LEFT_SIDE_CELL_COLOR_SELECTED [NSColor colorWithCalibratedRed:0.608 green:0.784 blue:0.910 alpha:1.0]
#define RIGHT_SIDE_CELL_COLOR [NSColor colorWithCalibratedWhite:1.0 alpha:1.0]
#define CELL_NOISE_OPACITY 0.25
#define CELL_NOISE_OPACITY_SELECTED 0.1
#define CELL_BORDER_COLOR [NSColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:1.0]


@implementation JSBinaryTableRowView


- (void) drawBackgroundInRect: (NSRect) dirtyRect {
    BOOL selected = self.selected;
    [self drawBackgroundInRect: dirtyRect selected: selected];
}

- (void) drawBackgroundInRect: (NSRect) dirtyRect selected: (BOOL) selected {
    NSRect cellRect = NSMakeRect([self bounds].origin.x + 0.5 * INSETX, [self bounds].origin.y + 0.5 * INSETY, [self bounds].size.width - INSETX, [self bounds].size.height - INSETY);

    NSBezierPath *roundedPath = [NSBezierPath bezierPathWithRoundedRect: cellRect xRadius: RADIUS yRadius: RADIUS];

    [self drawShadowForPath: roundedPath];

    NSRect leftRect = NSMakeRect(cellRect.origin.x, cellRect.origin.y, LEFT_RECT_WIDTH, cellRect.size.height);
    NSBezierPath *leftPath = [NSBezierPath bezierPathWithRoundedRect: leftRect corners: (JSLowerLeftCorner | JSUpperLeftCorner) radius: RADIUS];
    if (!selected) [LEFT_SIDE_CELL_COLOR setFill];
    else [LEFT_SIDE_CELL_COLOR_SELECTED setFill];
    [leftPath fill];

    NSRect rightRect = NSMakeRect(cellRect.origin.x + LEFT_RECT_WIDTH, cellRect.origin.y, cellRect.size.width - LEFT_RECT_WIDTH, cellRect.size.height);
    NSBezierPath *rightPath = [NSBezierPath bezierPathWithRoundedRect: rightRect corners: (JSLowerRightCorner | JSUpperRightCorner) radius: RADIUS];
    [RIGHT_SIDE_CELL_COLOR setFill];
    [rightPath fill];

    [roundedPath addClip];
    if (!selected) [KGNoise drawNoiseWithOpacity: CELL_NOISE_OPACITY];
    else [KGNoise drawNoiseWithOpacity: CELL_NOISE_OPACITY_SELECTED];

    [CELL_BORDER_COLOR setStroke];
    [leftPath stroke];
    [rightPath stroke];
}

- (void) drawShadowForPath: (NSBezierPath *) path {
    [NSGraphicsContext saveGraphicsState];

    // Create the shadow below and to the right of the shape.
    NSShadow *theShadow = [[NSShadow alloc] init];
    [theShadow setShadowOffset: NSMakeSize(SHADOW_OFFSET_X, SHADOW_OFFSET_Y)];
    [theShadow setShadowBlurRadius: SHADOW_BLUR_RADIUS];
    [theShadow setShadowColor: [[NSColor blackColor] colorWithAlphaComponent: SHADOW_OPACITY]];

    [theShadow set];

    NSColor *backgroundColor = [[NSColor blackColor] colorWithAlphaComponent: 0.2];
    [backgroundColor setFill];
    [path fill];

    [NSGraphicsContext restoreGraphicsState];
}

- (void) setSelected: (BOOL) selected {
    if (selected != self.isSelected) [self setNeedsDisplay: YES];
    [super setSelected: selected];
}

@end
