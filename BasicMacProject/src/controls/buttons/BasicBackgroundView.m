//
//  BasicBackgroundView.m
//  Button
//
//  Created by ampatspell on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BasicBackgroundView.h"
#import "NSBezierPath+DPUtils.h"
#import "NSGraphicsContext+DPUtils.h"


@implementation BasicBackgroundView


@synthesize borderColor;
@synthesize gradient;
@synthesize backgroundColor;
@synthesize cornerRadius;
@synthesize borderWidth;
@synthesize shadowOpacity;

@synthesize shadow;

- (void) setup {
    self.cornerRadius = 0.0;
    self.borderWidth = 0.0;
    self.borderColor = [NSColor clearColor];
    self.backgroundColor = [NSColor clearColor];


    shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [NSColor clearColor];
    shadow.shadowBlurRadius = 2.0;
    shadow.shadowOffset = NSMakeSize(0, -1);
    shadowOpacity = 0.5;


}

- (id) initWithFrame: (NSRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setBackgroundColor: (NSColor *) backgroundColor1 {
    backgroundColor = backgroundColor1;
    self.gradient = [[NSGradient alloc] initWithStartingColor: backgroundColor endingColor: backgroundColor];
}

- (void) drawRect: (NSRect) rect {


    if (shadow.shadowColor != [NSColor clearColor]) {

        CGFloat amount = 3;
        NSRect newRect = self.bounds;
        if (self.isFlipped) {
            newRect.size.height -= amount;

        } else {
            newRect.size.height -= amount;
            newRect.origin.y += amount;
        }


        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: newRect xRadius: cornerRadius yRadius: cornerRadius];
        [path drawShadow: shadow shadowOpacity: shadowOpacity];
        [path drawGradient: gradient angle: 90.0f];
        [path drawStroke: borderColor width: borderWidth];


    } else {


        NSRect bounds = self.bounds;
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: self.bounds xRadius: cornerRadius yRadius: cornerRadius];

        [path drawGradient: gradient angle: 90.0f];
        [path drawStroke: borderColor];

    }
}


//
//- (void) drawShadowForPath: (NSBezierPath *) path {
//    [NSGraphicsContext saveGraphicsState];
//
//    // Create the shadow below and to the right of the shape.
//    NSShadow *theShadow = [[NSShadow alloc] init];
//    theShadow.shadowColor = self.shadowColor;
//    theShadow.shadowBlurRadius = self.shadowRadius;
//    theShadow.shadowOffset = self.shadowOffset;
//
//    [theShadow set];
//
//    NSColor *fadedColor = [self.shadowColor colorWithAlphaComponent: shadowOpacity];
//    [fadedColor setFill];
//    [path fill];
//
//    [NSGraphicsContext restoreGraphicsState];
//}

- (BOOL) isOpaque {
    return NO;
}

@end
