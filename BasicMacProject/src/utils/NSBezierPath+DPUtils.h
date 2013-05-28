//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface NSBezierPath (DPUtils)


- (void) drawGradient: (NSGradient *) gradient;
- (void) drawGradient: (NSGradient *) gradient angle: (CGFloat) angle;
- (void) drawStroke: (NSColor *) strokeColor;
- (void) drawStroke: (NSColor *) strokeColor width: (CGFloat) borderWidth;
- (void) drawShadow: (NSShadow *) shadow1;
- (void) drawShadow: (NSShadow *) shadow1 shadowOpacity: (CGFloat) sOpacity;
- (void) drawShadowColor: (NSColor *) sColor shadowRadius: (CGFloat) sRadius shadowOffset: (NSSize) sOffset shadowOpacity: (CGFloat) sOpacity;
- (void) drawImage: (NSImage *) image;
@end