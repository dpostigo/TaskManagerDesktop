//
// Created by dpostigo on 2/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicView.h"


@implementation BasicView {
}


@synthesize backgroundColor;


- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {
        self.backgroundColor = [NSColor clearColor];
    }

    return self;
}


- (BOOL) isOpaque {
    return NO;
}


- (BOOL) isFlipped {
    return YES;
}


- (void) setBackgroundColor: (NSColor *) backgroundColor1 {
    if (backgroundColor != backgroundColor1) {
        backgroundColor = backgroundColor1;
    }
    [self setNeedsDisplay: YES];
}


- (void) drawRect: (NSRect) dirtyRect {
        [super drawRect: dirtyRect];

    [backgroundColor setFill];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);

//
//    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
//    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
//    CGContextFillRect(context, NSRectToCGRect(dirtyRect));

}

@end