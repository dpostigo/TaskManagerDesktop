//
// Created by Daniela Postigo on 5/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RoundedView.h"
#import "NSBezierPath+Additions.h"
#import "NSBezierPath+DPUtils.h"


@implementation RoundedView {
}


@synthesize cornerOptions;

- (void) setup {
    [super setup];
    self.cornerOptions = JSUpperLeftCorner | JSUpperRightCorner;
}

- (void) drawRect: (NSRect) rect {

    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: rect corners: cornerOptions radius: cornerRadius];

    if (shadow.shadowColor != [NSColor clearColor]) {
        NSRect newRect = self.bounds;
        newRect.size.height -= 3;

        [path drawShadow: shadow shadowOpacity: shadowOpacity];

        [gradient drawInBezierPath: path angle: 90];
        [path addClip];

        [ctx saveGraphicsState];
        [borderColor setStroke];
        [path setLineWidth: borderWidth];
        [path setLineCapStyle: NSRoundLineCapStyle];
        [path stroke];
        [ctx restoreGraphicsState];
    } else {

        NSRect bounds = self.bounds;
        if (cornerRadius > 0) {
            [ctx saveGraphicsState];
            [gradient drawInBezierPath: path angle: 90];
            [path addClip];
            [ctx restoreGraphicsState];
            //
            //            NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect: NSInsetRect(rect, 1, 1) xRadius: cornerRadius yRadius: cornerRadius];
            //            [ctx saveGraphicsState];
            //            [borderColor setStroke];
            //            [borderPath stroke];
            //            [ctx restoreGraphicsState];
        } else {

            [gradient drawInRect: bounds angle: 90.0f];
            [ctx saveGraphicsState];
            [self.borderColor setStroke];
            [NSBezierPath strokeRect: bounds];
            [ctx restoreGraphicsState];
        }
    }
}

//- (void) secondDraw: (NSRect) rect {
//    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: rect corners: cornerOptions radius: cornerRadius];
//    NSRect newRect = self.bounds;
//
//    if (shadow.shadowColor != [NSColor clearColor]) {
//        newRect.size.height -= 3;
//        [path drawBezierPathWithShadowColor: shadowColor shadowRadius: shadowRadius shadowOffset: shadowOffset shadowOpacity: shadowOpacity];
//    }
//}

- (BOOL) isOpaque {
    return YES;
}

@end