//
//  JSButtonCell.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 29/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSButtonCell.h"

#define BUTTON_RADIUS 3.5
#define BUTTON_INSET_X 1.0
#define BUTTON_INSET_Y 3.0
#define BUTTON_TOP_COLOR [NSColor colorWithCalibratedWhite:0.98f alpha:1.0f]
#define BUTTON_BOTTOM_COLOR [NSColor colorWithCalibratedWhite:0.88f alpha:1.0f]

@implementation JSButtonCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super drawWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect insetRect = NSInsetRect(cellFrame, BUTTON_INSET_X, BUTTON_INSET_Y);
    NSBezierPath *buttonPath = [NSBezierPath bezierPathWithRoundedRect:insetRect xRadius:BUTTON_RADIUS yRadius:BUTTON_RADIUS];
    NSGradient *backgroundGradient = [[NSGradient alloc] initWithStartingColor:BUTTON_TOP_COLOR endingColor:BUTTON_BOTTOM_COLOR];
    [backgroundGradient drawInBezierPath:buttonPath angle:90.0f];
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}


@end
