//
//  JSChromeButtonCell.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 24/04/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSChromeButtonCell.h"

#define LIGHT_SHADOW_Y_OFFSET -1.0
#define LIGHT_SHADOW_X_OFFSET 0.0
#define LIGHT_SHADOW_BLUR_RADIUS 1.0
#define LIGHT_SHADOW_COLOR [[NSColor whiteColor] colorWithAlphaComponent:0.7]

#define DARK_SHADOW_Y_OFFSET -1.0
#define DARK_SHADOW_X_OFFSET 0.0
#define DARK_SHADOW_BLUR_RADIUS 2.0
#define DARK_SHADOW_COLOR [[NSColor blackColor] colorWithAlphaComponent:0.4]

@implementation JSChromeButtonCell

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSShadow *lightShadow = [[NSShadow alloc] init];
    [lightShadow setShadowOffset:NSMakeSize(LIGHT_SHADOW_X_OFFSET, LIGHT_SHADOW_Y_OFFSET)];
    [lightShadow setShadowBlurRadius:LIGHT_SHADOW_BLUR_RADIUS];
    [lightShadow setShadowColor:LIGHT_SHADOW_COLOR];
    
    NSShadow* darkShadow = [[NSShadow alloc] init];
    [darkShadow setShadowOffset:NSMakeSize(DARK_SHADOW_X_OFFSET, DARK_SHADOW_Y_OFFSET)];
    [darkShadow setShadowBlurRadius:DARK_SHADOW_BLUR_RADIUS];
    [darkShadow setShadowColor:DARK_SHADOW_COLOR];
    
    if (!self.isHighlighted) {
        [self drawInnerShadow:lightShadow withFrame:frame];
        [self drawOuterShadow:darkShadow withFrame:frame];
    } else {
        [self drawInnerShadow:darkShadow withFrame:frame];
        [self drawOuterShadow:lightShadow withFrame:frame];
    }
}

- (void)drawInnerShadow:(NSShadow *)shadow withFrame:(NSRect)frame
{
    [NSGraphicsContext saveGraphicsState];
    
    [shadow set];
    
    [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 3.0, 3.0) xRadius:4.0 yRadius:4.0] addClip];
    
    [[NSColor blackColor] setFill];
    
    NSBezierPath *filledPath = [NSBezierPath bezierPathWithRect:frame];
    [filledPath appendBezierPath:[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 3.0, 3.0) xRadius:3.0 yRadius:3.0]];
    [filledPath setWindingRule:NSEvenOddWindingRule];
    [filledPath fill];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void)drawOuterShadow:(NSShadow *)shadow withFrame:(NSRect)frame
{
    [NSGraphicsContext saveGraphicsState];

    [shadow set];
    
    NSBezierPath *clippingPath = [NSBezierPath bezierPathWithRect:frame];
    [clippingPath appendBezierPath:[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 3.0, 3.0) xRadius:2.0 yRadius:2.0]];
    [clippingPath setWindingRule:NSEvenOddWindingRule];
    [clippingPath addClip];
    
    [[NSColor blackColor] setFill];
    
    [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 3.0, 3.0) xRadius:3.0 yRadius:3.0] fill];
    
    [NSGraphicsContext restoreGraphicsState];
}

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView
{
    frame.origin.y += 2.0;
    [super drawImage:image withFrame:frame inView:controlView];
}

@end
