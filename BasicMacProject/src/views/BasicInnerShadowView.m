//
// Created by dpostigo on 2/20/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicInnerShadowView.h"


@implementation BasicInnerShadowView {
}


@synthesize cornerRadius;
@synthesize fillColor;
@synthesize borderColor;
@synthesize shadowColor;
@synthesize shadowRadius;


- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {

        self.cornerRadius = 3.0;
        self.shadowRadius = 5.0;
        self.fillColor = [NSColor colorWithDeviceWhite: 0.8 alpha: 0.05];
        self.borderColor = [NSColor whiteColor];
        self.shadowColor = [NSColor grayColor];
    }

    return self;
}


- (BOOL) isOpaque {
    return NO;
}


- (void) drawRect: (NSRect) dirtyRect {
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];

    [context setCompositingOperation: NSCompositeSourceOver];

    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: dirtyRect xRadius: cornerRadius yRadius: cornerRadius];

    [fillColor setFill];
    [borderColor setStroke];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = self.shadowColor;
    shadow.shadowBlurRadius = self.shadowRadius;

    [shadow set];
    [path setLineWidth: 2.0];
    [path fill];
    [path stroke];

    [context restoreGraphicsState];
}

@end