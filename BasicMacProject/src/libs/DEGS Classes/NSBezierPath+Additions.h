//
//  NSBezierPath+Additions.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 17/10/12.
//
//

#import <Cocoa/Cocoa.h>


enum {
    JSLowerLeftCorner = 1 << 0,
    JSLowerRightCorner = 1 << 1,
    JSUpperLeftCorner = 1 << 2,
    JSUpperRightCorner = 1 << 3,
};
typedef NSUInteger JSRoundedCornerOptions;


@interface NSBezierPath (Additions)


+ (NSBezierPath *) bezierPathWithRoundedRect: (NSRect) rect corners: (JSRoundedCornerOptions) corners radius: (CGFloat) radius;
- (void) appendBezierPathWithRoundedRect: (NSRect) rect corners: (JSRoundedCornerOptions) corners radius: (CGFloat) radius;

- (NSBezierPath *) pathWithStrokeWidth: (CGFloat) strokeWidth;

- (void) fillWithInnerShadow: (NSShadow *) shadow;
- (void) drawBlurWithColor: (NSColor *) color radius: (CGFloat) radius;

- (void) strokeInside;
- (void) strokeInsideWithinRect: (NSRect) clipRect;

@end
