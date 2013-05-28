//
// Created by Daniela Postigo on 5/22/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VeryBasicButtonCell.h"
#import "NSGraphicsContext+DPUtils.h"


@implementation VeryBasicButtonCell {
}


@synthesize gradientColor;
@synthesize disabledGradientColor;

@synthesize strokeColor;
@synthesize disabledStrokeColor;

@synthesize innerStrokeColor;
@synthesize disabledInnerStrokeColor;

@synthesize cornerRadius;
@synthesize imageColor;
@synthesize imageShadowColor;

@synthesize autoAdjustsCornerRadius;

- (void) setup {

    self.imageColor = [NSColor colorWithDeviceWhite: 0.9 alpha: 1.0];
    self.imageShadowColor = [NSColor clearColor];

    self.strokeColor = [NSColor colorWithDeviceWhite: 0.12f alpha: 1.0f];
    self.innerStrokeColor = [NSColor colorWithDeviceWhite: 1.0f alpha: 0.05f];
    self.highlightedColor = [NSColor colorWithCalibratedWhite: 0.0f alpha: 0.35];

    self.cornerRadius = 3.0;
    self.autoAdjustsCornerRadius = NO;

    gradientColor = [[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithDeviceWhite: 0.1f alpha: 1.0f], 0.0,
            [NSColor colorWithDeviceWhite: 0.35 alpha: 1.0f], 1.0,
            nil];

    disabledGradientColor = [[NSGradient alloc] initWithColorsAndLocations:
            [NSColor lightGrayColor], 0.0,
            [NSColor darkGrayColor], 1.0,
            nil];

    disabledStrokeColor = [NSColor darkGrayColor];
    disabledInnerStrokeColor = [NSColor lightGrayColor];
}

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initTextCell: (NSString *) aString {
    self = [super initTextCell: aString];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initImageCell: (NSImage *) image {
    self = [super initImageCell: image];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) drawImage: (NSImage *) image withFrame: (NSRect) frame inView: (NSView *) controlView {
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    CGContextRef contextRef = [ctx graphicsPort];
    CGContextTranslateCTM(contextRef, 0, controlView.frame.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);

    NSData *data = [image TIFFRepresentation];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) data, NULL);
    if (source) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        CFRelease(source);

        CGContextSaveGState(contextRef);
        {
            NSRect rect = NSOffsetRect(frame, 0.0f, 1.0f);
            CGContextClipToMask(contextRef, rect, imageRef);
            [self.imageShadowColor setFill];
            NSRectFill(rect);
        }
        CGContextRestoreGState(contextRef);

        CGContextSaveGState(contextRef);
        {
            NSRect rect = frame;
            //            CGContextTranslateCTM(contextRef, 0, rect.size.height);
            //            CGContextScaleCTM(contextRef, 1.0, -1.0);
            CGContextClipToMask(contextRef, rect, imageRef);
            [self.imageColor setFill];
            NSRectFill(rect);
        }
        CGContextRestoreGState(contextRef);
        CFRelease(imageRef);
    }
}

- (void) drawBezelWithFrame: (NSRect) frame inView: (NSView *) controlView {
    if (autoAdjustsCornerRadius && cornerRadius > 0) {
        self.cornerRadius = frame.size.height * 0.4;
    }

    NSGraphicsContext *context = [NSGraphicsContext currentContext];

    BOOL outer = NO;
    BOOL stroke = YES;
    BOOL background = YES;
    BOOL innerStroke = YES;
    if (outer) [self drawOuter: context frame: frame];
    if (background) [self drawBackgroundFill: context frame: frame];
    if (stroke) [self drawStroke: context frame: frame];
    if (innerStroke) [self drawInnerStroke: context frame: frame];
    if (self.isHighlighted) [self drawHighlight: context frame: frame];
}

- (BOOL) isOpaque {
    return NO;
}


#pragma mark Drawing


- (void) drawOuter: (NSGraphicsContext *) context frame: (NSRect) frame {
    [context saveGraphicsState];
    NSBezierPath *outerClip = [NSBezierPath bezierPathWithRoundedRect: frame xRadius: cornerRadius yRadius: cornerRadius];
    [outerClip setClip];

    NSGradient *outerGradient = [[NSGradient alloc] initWithColorsAndLocations:
            [NSColor colorWithDeviceWhite: 0.20f alpha: 1.0f], 0.0f,
            [NSColor colorWithDeviceWhite: 0.21f alpha: 1.0f], 1.0f,
            nil];

    [outerGradient drawInRect: [outerClip bounds] angle: 90.0f];
    [context restoreGraphicsState];
}

- (void) drawStroke: (NSGraphicsContext *) context frame: (NSRect) frame {
    [context saveGraphicsState];
    NSColor *color = self.isEnabled ? strokeColor : disabledStrokeColor;
    [color setStroke];
    [[NSBezierPath bezierPathWithRoundedRect: NSInsetRect(frame, 1.5f, 1.5f) xRadius: cornerRadius - 1 yRadius: cornerRadius - 1] stroke];
    [context restoreGraphicsState];
}

- (void) drawInnerStroke: (NSGraphicsContext *) context frame: (NSRect) frame {
    [context saveGraphicsState];
    NSColor *color = self.isEnabled ? innerStrokeColor : disabledInnerStrokeColor;
    [color setStroke];
    [[NSBezierPath bezierPathWithRoundedRect: NSInsetRect(frame, 2.5f, 2.5f) xRadius: cornerRadius yRadius: cornerRadius] stroke];
    [context restoreGraphicsState];
}

- (void) drawBackgroundFill: (NSGraphicsContext *) context frame: (NSRect) frame {
    NSGradient *theGradient = self.isEnabled ? gradientColor : disabledGradientColor;
    NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRoundedRect: NSInsetRect(frame, 2.0f, 2.0f) xRadius: cornerRadius yRadius: cornerRadius];
    [context drawBackgroundGradient: theGradient inPath: backgroundPath angle: 270.0f];
}

- (void) drawHighlight: (NSGraphicsContext *) context frame: (NSRect) frame {
    [context saveGraphicsState];
    [[NSBezierPath bezierPathWithRoundedRect: NSInsetRect(frame, 2.0f, 2.0f) xRadius: cornerRadius yRadius: cornerRadius] setClip];
    [self.highlightedColor setFill];
    NSRectFillUsingOperation(frame, NSCompositeSourceOver);
    [context restoreGraphicsState];
}

@end