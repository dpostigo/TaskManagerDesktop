//
//  NSGraphicsContext+DPUtils.m
//  TaskManager
//
//  Created by Daniela Postigo on 5/26/13.
//  Copyright 2013 Dani Postigo. All rights reserved.
//

#import "NSGraphicsContext+DPUtils.h"


@implementation NSGraphicsContext (DPUtils)


- (void) drawStrokeColor: (NSColor *) strokeColor withPath: (NSBezierPath *) path {
    [self drawStrokeColor: strokeColor width: 1.0 path: path];
}

- (void) drawStrokeColor: (NSColor *) strokeColor width: (CGFloat) strokewidth path: (NSBezierPath *) path {
    [self saveGraphicsState];
    [strokeColor setStroke];
    [path setLineWidth: strokewidth];
    [path setLineCapStyle: NSRoundLineCapStyle];
    [path stroke];
    [self restoreGraphicsState];
}


- (void) drawBackgroundGradient: (NSGradient *) gradient inPath: (NSBezierPath *) path {
    [self drawBackgroundGradient: gradient inPath: path angle: 90.0f];

}

- (void) drawBackgroundGradient: (NSGradient *) gradient inPath: (NSBezierPath *) path angle: (CGFloat) angle {
    [self saveGraphicsState];
    [path setClip];
    [gradient drawInRect: path.bounds angle: angle];
    [self restoreGraphicsState];
}

- (void) drawShadow: (NSShadow *) shadow inPath: (NSBezierPath *) path opacity: (CGFloat) shadowOpacity {
    [self saveGraphicsState];
    [shadow set];
    NSColor *alphaShadowColor = [shadow.shadowColor colorWithAlphaComponent: shadowOpacity];
    [alphaShadowColor setFill];
    [path fill];
    [self restoreGraphicsState];

}


@end