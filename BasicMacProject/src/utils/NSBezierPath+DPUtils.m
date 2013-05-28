//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSBezierPath+DPUtils.h"


@implementation NSBezierPath (DPUtils)


#pragma mark Gradient
- (void) drawGradient: (NSGradient *) gradient {
    [self drawGradient: gradient angle: 90.0f];

}

- (void) drawGradient: (NSGradient *) gradient angle: (CGFloat) angle {
    [NSGraphicsContext saveGraphicsState];
    [gradient drawInBezierPath: self angle: angle];
    //    [gradient drawInRect: self.bounds angle: angle];
    //    [self setClip];
    [NSGraphicsContext restoreGraphicsState];
}


#pragma mark Stroke


- (void) drawStroke: (NSColor *) strokeColor {
    [self drawStroke: strokeColor width: 1.0];
}

- (void) drawStroke: (NSColor *) strokeColor width: (CGFloat) borderWidth {
    [NSGraphicsContext saveGraphicsState];
    [strokeColor setStroke];
    //    [self setLineWidth: borderWidth];
    //    [self setLineCapStyle: NSRoundLineCapStyle];
    [self stroke];
    [NSGraphicsContext restoreGraphicsState];
}




#pragma mark Shadow

- (void) drawShadow: (NSShadow *) shadow {
    [self drawShadow: shadow shadowOpacity: 0.5];
}

- (void) drawShadow: (NSShadow *) shadow shadowOpacity: (CGFloat) sOpacity {
    NSColor *alphaShadowColor = [shadow.shadowColor colorWithAlphaComponent: sOpacity];

    [NSGraphicsContext saveGraphicsState];
    [shadow set];
    [alphaShadowColor setFill];
    [self fill];
    [NSGraphicsContext restoreGraphicsState];
}


- (void) drawShadowColor: (NSColor *) sColor shadowRadius: (CGFloat) sRadius shadowOffset: (NSSize) sOffset shadowOpacity: (CGFloat) sOpacity {
    NSShadow *theShadow = [[NSShadow alloc] init];
    theShadow.shadowColor = sColor;
    theShadow.shadowBlurRadius = sRadius;
    theShadow.shadowOffset = sOffset;
    [self drawShadow: theShadow shadowOpacity: 0.5];
}


- (void) drawImage: (NSImage *) image {

    [NSGraphicsContext saveGraphicsState];
    [self addClip];
    [image drawInRect: self.bounds fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.0];
    [NSGraphicsContext restoreGraphicsState];

}
@end