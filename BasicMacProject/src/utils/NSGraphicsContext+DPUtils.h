//
//  NSGraphicsContext+DPUtils.h
//  TaskManager
//
//  Created by Daniela Postigo on 5/26/13.
//  Copyright 2013 Dani Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSGraphicsContext (DPUtils)

- (void) drawStrokeColor: (NSColor *) strokeColor withPath: (NSBezierPath *) path;
- (void) drawStrokeColor: (NSColor *) strokeColor width: (CGFloat) strokewidth path: (NSBezierPath *) path;
- (void) drawBackgroundGradient: (NSGradient *) gradient inPath: (NSBezierPath *) path;
- (void) drawBackgroundGradient: (NSGradient *) gradient inPath: (NSBezierPath *) path angle: (CGFloat) angle;
- (void) drawShadow: (NSShadow *) shadow1 inPath: (NSBezierPath *) path opacity: (CGFloat) shadowOpacity;
@end