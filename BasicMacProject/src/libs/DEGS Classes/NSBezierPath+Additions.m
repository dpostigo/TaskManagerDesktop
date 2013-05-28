//
//  NSBezierPath+Additions.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 17/10/12.
//
//

#import "NSBezierPath+Additions.h"


@implementation NSBezierPath (Additions)


+ (NSBezierPath *) bezierPathWithRoundedRect: (NSRect) rect corners: (JSRoundedCornerOptions) corners radius: (CGFloat) radius {
    NSBezierPath *path = [self bezierPath];
    [path appendBezierPathWithRoundedRect: rect corners: corners radius: radius];
    return path;
}

- (void) appendBezierPathWithRoundedRect: (NSRect) rect corners: (JSRoundedCornerOptions) corners radius: (CGFloat) radius {
    BOOL flipped = [[NSGraphicsContext currentContext] isFlipped];

    if (flipped) {
        NSUInteger upperCorners = (corners & (JSUpperLeftCorner | JSUpperRightCorner));

        corners = corners << 2;
        corners |= (upperCorners >> 2);

        corners &= (JSUpperLeftCorner | JSUpperRightCorner | JSLowerLeftCorner | JSLowerRightCorner);
    }

    [self moveToPoint: NSMakePoint(NSMidX(rect), NSMinY(rect))];

    radius = MIN(radius, MIN(NSWidth(rect), NSHeight(rect)) / 2.0);

    if (corners & JSLowerRightCorner)
        [self appendBezierPathWithArcFromPoint: NSMakePoint(NSMaxX(rect), NSMinY(rect)) toPoint: NSMakePoint(NSMaxX(rect), NSMidY(rect)) radius: radius];
    else {
        [self lineToPoint: NSMakePoint(NSMaxX(rect), NSMinY(rect))];
        [self lineToPoint: NSMakePoint(NSMaxX(rect), NSMidY(rect))];
    }

    if (corners & JSUpperRightCorner)
        [self appendBezierPathWithArcFromPoint: NSMakePoint(NSMaxX(rect), NSMaxY(rect)) toPoint: NSMakePoint(NSMidX(rect), NSMaxY(rect)) radius: radius];
    else {
        [self lineToPoint: NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
        [self lineToPoint: NSMakePoint(NSMidX(rect), NSMaxY(rect))];
    }

    if (corners & JSUpperLeftCorner)
        [self appendBezierPathWithArcFromPoint: NSMakePoint(NSMinX(rect), NSMaxY(rect)) toPoint: NSMakePoint(NSMinX(rect), NSMidY(rect)) radius: radius];
    else {
        [self lineToPoint: NSMakePoint(NSMinX(rect), NSMaxY(rect))];
        [self lineToPoint: NSMakePoint(NSMinX(rect), NSMidY(rect))];
    }

    if (corners & JSLowerLeftCorner)
        [self appendBezierPathWithArcFromPoint: NSMakePoint(NSMinX(rect), NSMinY(rect)) toPoint: NSMakePoint(NSMidX(rect), NSMinY(rect)) radius: radius];
    else
        [self lineToPoint: NSMakePoint(NSMinX(rect), NSMinY(rect))];

    [self closePath];
}

- (NSBezierPath *) pathWithStrokeWidth: (CGFloat) strokeWidth {
#ifdef MCBEZIER_USE_PRIVATE_FUNCTION
	NSBezierPath *path = [self copy];
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGPathRef pathRef = [path cgPath];
	[path release];
	
	CGContextSaveGState(context);
    
	CGContextBeginPath(context);
	CGContextAddPath(context, pathRef);
	CGContextSetLineWidth(context, strokeWidth);
	CGContextReplacePathWithStrokedPath(context);
	CGPathRef strokedPathRef = CGContextCopyPath(context);
	CGContextBeginPath(context);
	NSBezierPath *strokedPath = [NSBezierPath bezierPathWithCGPath:strokedPathRef];
	
	CGContextRestoreGState(context);
	
	CFRelease(pathRef);
	CFRelease(strokedPathRef);
	
	return strokedPath;
#else
    return nil;
#endif//MCBEZIER_USE_PRIVATE_FUNCTION
}

- (void) fillWithInnerShadow: (NSShadow *) shadow {
    [NSGraphicsContext saveGraphicsState];

    NSSize offset = shadow.shadowOffset;
    NSSize originalOffset = offset;
    CGFloat radius = shadow.shadowBlurRadius;
    NSRect bounds = NSInsetRect(self.bounds, -(ABS(offset.width) + radius), -(ABS(offset.height) + radius));
    offset.height += bounds.size.height;
    shadow.shadowOffset = offset;
    NSAffineTransform *transform = [NSAffineTransform transform];
    if ([[NSGraphicsContext currentContext] isFlipped])
        [transform translateXBy: 0 yBy: bounds.size.height];
    else
        [transform translateXBy: 0 yBy: -bounds.size.height];

    NSBezierPath *drawingPath = [NSBezierPath bezierPathWithRect: bounds];
    [drawingPath setWindingRule: NSEvenOddWindingRule];
    [drawingPath appendBezierPath: self];
    [drawingPath transformUsingAffineTransform: transform];

    [self addClip];
    [shadow set];
    [[NSColor blackColor] set];
    [drawingPath fill];

    shadow.shadowOffset = originalOffset;

    [NSGraphicsContext restoreGraphicsState];
}

- (void) drawBlurWithColor: (NSColor *) color radius: (CGFloat) radius {
    NSRect bounds = NSInsetRect(self.bounds, -radius, -radius);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = NSMakeSize(0, bounds.size.height);
    shadow.shadowBlurRadius = radius;
    shadow.shadowColor = color;
    NSBezierPath *path = [self copy];
    NSAffineTransform *transform = [NSAffineTransform transform];
    if ([[NSGraphicsContext currentContext] isFlipped])
        [transform translateXBy: 0 yBy: bounds.size.height];
    else
        [transform translateXBy: 0 yBy: -bounds.size.height];
    [path transformUsingAffineTransform: transform];

    [NSGraphicsContext saveGraphicsState];

    [shadow set];
    [[NSColor blackColor] set];
    NSRectClip(bounds);
    [path fill];

    [NSGraphicsContext restoreGraphicsState];
}

// Credit for the next two methods goes to Matt Gemmell
- (void) strokeInside {
    /* Stroke within path using no additional clipping rectangle. */
    [self strokeInsideWithinRect: NSZeroRect];
}

- (void) strokeInsideWithinRect: (NSRect) clipRect {
    NSGraphicsContext *thisContext = [NSGraphicsContext currentContext];
    float lineWidth = [self lineWidth];

    /* Save the current graphics context. */
    [thisContext saveGraphicsState];

    /* Double the stroke width, since -stroke centers strokes on paths. */
    [self setLineWidth: (lineWidth * 2.0)];

    /* Clip drawing to this path; draw nothing outwith the path. */
    [self setClip];

    /* Further clip drawing to clipRect, usually the view's frame. */
    if (clipRect.size.width > 0.0 && clipRect.size.height > 0.0) {
        [NSBezierPath clipRect: clipRect];
    }

    /* Stroke the path. */
    [self stroke];

    /* Restore the previous graphics context. */
    [thisContext restoreGraphicsState];
    [self setLineWidth: lineWidth];
}

@end
