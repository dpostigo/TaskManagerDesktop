//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPTitleBarView.h"
#import "DPCustomWindowIncludes.h"
#import "DPCustomWindow.h"
#import "NSColor+INAdditions.h"


#define IN_COLOR_MAIN_START [NSColor colorWithDeviceWhite:0.659 alpha:1.0]
#define IN_COLOR_MAIN_END [NSColor colorWithDeviceWhite:0.812 alpha:1.0]
#define IN_COLOR_MAIN_BOTTOM [NSColor colorWithDeviceWhite:0.318 alpha:1.0]
#define IN_COLOR_NOTMAIN_START [NSColor colorWithDeviceWhite:0.851 alpha:1.0]
#define IN_COLOR_NOTMAIN_END [NSColor colorWithDeviceWhite:0.929 alpha:1.0]
#define IN_COLOR_NOTMAIN_BOTTOM [NSColor colorWithDeviceWhite:0.600 alpha:1.0]
#define IN_COLOR_MAIN_TITLE_TEXT [NSColor colorWithDeviceWhite:56.0/255.0 alpha:1.0]
#define IN_COLOR_NOTMAIN_TITLE_TEXT [NSColor colorWithDeviceWhite:56.0/255.0 alpha:0.5]

/** Lion */

#define IN_COLOR_MAIN_START_L [NSColor colorWithDeviceWhite:0.66 alpha:1.0]
#define IN_COLOR_MAIN_END_L [NSColor colorWithDeviceWhite:0.9 alpha:1.0]
#define IN_COLOR_MAIN_BOTTOM_L [NSColor colorWithDeviceWhite:0.408 alpha:1.0]
#define IN_COLOR_NOTMAIN_START_L [NSColor colorWithDeviceWhite:0.878 alpha:1.0]
#define IN_COLOR_NOTMAIN_END_L [NSColor colorWithDeviceWhite:0.976 alpha:1.0]
#define IN_COLOR_NOTMAIN_BOTTOM_L [NSColor colorWithDeviceWhite:0.655 alpha:1.0]

static inline CGPathRef createClippingPathWithRectAndRadius(NSRect rect, CGFloat radius) {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, NSMinX(rect), NSMinY(rect));
    CGPathAddLineToPoint(path, NULL, NSMinX(rect), NSMaxY(rect) - radius);
    CGPathAddArcToPoint(path, NULL, NSMinX(rect), NSMaxY(rect), NSMinX(rect) + radius, NSMaxY(rect), radius);
    CGPathAddLineToPoint(path, NULL, NSMaxX(rect) - radius, NSMaxY(rect));
    CGPathAddArcToPoint(path, NULL, NSMaxX(rect), NSMaxY(rect), NSMaxX(rect), NSMaxY(rect) - radius, radius);
    CGPathAddLineToPoint(path, NULL, NSMaxX(rect), NSMinY(rect));
    CGPathCloseSubpath(path);
    return path;
}

static inline CGGradientRef createGradientWithColors(NSColor *startingColor, NSColor *endingColor) {
    CGFloat locations[2] = {0.0f, 1.0f,};
    CGColorRef cgStartingColor = [startingColor IN_CGColorCreate];
    CGColorRef cgEndingColor = [endingColor IN_CGColorCreate];
#if __has_feature(objc_arc)
    CFArrayRef colors = (__bridge CFArrayRef) [NSArray arrayWithObjects: (__bridge id) cgStartingColor, (__bridge id) cgEndingColor, nil];
#else
    CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects:(id)cgStartingColor, (id)cgEndingColor, nil];
    #endif
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(cgStartingColor);
    CGColorRelease(cgEndingColor);
    return gradient;
}


@implementation DPTitleBarView {
}


@synthesize cornerRadius;

- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {
        self.cornerRadius = 30.0;
    }

    return self;
}

- (void) drawNoiseWithOpacity: (CGFloat) opacity {
    static CGImageRef noiseImageRef = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSUInteger width = 124, height = width;
        NSUInteger size = width * height;
        char *rgba = (char *) malloc(size);
        srand(120);
        for (NSUInteger i = 0; i < size; ++i) {rgba[i] = rand() % 256;}
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef bitmapContext =
                CGBitmapContextCreate(rgba, width, height, 8, width, colorSpace, kCGImageAlphaNone);
        CFRelease(colorSpace);
        noiseImageRef = CGBitmapContextCreateImage(bitmapContext);
        CFRelease(bitmapContext);
        free(rgba);
    });
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    CGContextSetAlpha(context, opacity);
    CGContextSetBlendMode(context, kCGBlendModeScreen);
    if ([[self window] respondsToSelector: @selector(backingScaleFactor)]) {
        CGFloat scaleFactor = [[self window] backingScaleFactor];
        CGContextScaleCTM(context, 1 / scaleFactor, 1 / scaleFactor);
    }
    CGRect imageRect = (CGRect) {CGPointZero, CGImageGetWidth(noiseImageRef), CGImageGetHeight(noiseImageRef)};
    CGContextDrawTiledImage(context, imageRect, noiseImageRef);
    CGContextRestoreGState(context);
}

- (void) drawRect: (NSRect) dirtyRect {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    DPCustomWindow *window = (DPCustomWindow *) [self window];
    BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);
    NSRect drawingRect = [self bounds];
    if (window.titleBarDrawingBlock) {
        CGPathRef clippingPath = createClippingPathWithRectAndRadius(drawingRect, self.cornerRadius);
        window.titleBarDrawingBlock(drawsAsMainWindow, NSRectToCGRect(drawingRect), clippingPath);
        CGPathRelease(clippingPath);
    } else {
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        NSColor *startColor = drawsAsMainWindow ? window.titleBarStartColor: window.inactiveTitleBarStartColor;
        NSColor *endColor = drawsAsMainWindow ? window.titleBarEndColor: window.inactiveTitleBarEndColor;
        if (IN_RUNNING_LION) {
            startColor = startColor ? : (drawsAsMainWindow ? IN_COLOR_MAIN_START_L: IN_COLOR_NOTMAIN_START_L);
            endColor = endColor ? : (drawsAsMainWindow ? IN_COLOR_MAIN_END_L: IN_COLOR_NOTMAIN_END_L);
        } else {
            startColor = startColor ? : (drawsAsMainWindow ? IN_COLOR_MAIN_START: IN_COLOR_NOTMAIN_START);
            endColor = endColor ? : (drawsAsMainWindow ? IN_COLOR_MAIN_END: IN_COLOR_NOTMAIN_END);
        }
        NSRect clippingRect = drawingRect;
#if IN_COMPILING_LION
        if ((([window styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask)) {
            [[NSColor blackColor] setFill];
            [[NSBezierPath bezierPathWithRect: self.bounds] fill];
        }
#endif
        clippingRect.size.height -= 1;
        CGPathRef clippingPath = createClippingPathWithRectAndRadius(clippingRect, self.cornerRadius);
        CGContextAddPath(context, clippingPath);
        CGContextClip(context);
        CGPathRelease(clippingPath);
        CGGradientRef gradient = createGradientWithColors(startColor, endColor);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(NSMidX(drawingRect), NSMinY(drawingRect)),
                CGPointMake(NSMidX(drawingRect), NSMaxY(drawingRect)), 0);
        CGGradientRelease(gradient);
        if ([window showsBaselineSeparator]) {
            NSColor *bottomColor = drawsAsMainWindow ? window.baselineSeparatorColor: window.inactiveBaselineSeparatorColor;
            if (IN_RUNNING_LION) {
                bottomColor = bottomColor ? bottomColor: drawsAsMainWindow ? IN_COLOR_MAIN_BOTTOM_L: IN_COLOR_NOTMAIN_BOTTOM_L;
            } else {
                bottomColor = bottomColor ? bottomColor: drawsAsMainWindow ? IN_COLOR_MAIN_BOTTOM: IN_COLOR_NOTMAIN_BOTTOM;
            }
            NSRect bottomRect = NSMakeRect(0.0, NSMinY(drawingRect), NSWidth(drawingRect), 1.0);
            [bottomColor set];
            NSRectFill(bottomRect);
            if (IN_RUNNING_LION) {
                bottomRect.origin.y += 1.0;
                [[NSColor colorWithDeviceWhite: 1.0 alpha: 0.12] setFill];
                [[NSBezierPath bezierPathWithRect: bottomRect] fill];
            }
        }
        if (IN_RUNNING_LION && drawsAsMainWindow) {
            CGRect noiseRect = NSInsetRect(drawingRect, 1.0, 1.0);
            if (![window showsBaselineSeparator]) {
                noiseRect.origin.y -= 1.0;
                noiseRect.size.height += 1.0;
            }
            CGPathRef noiseClippingPath = createClippingPathWithRectAndRadius(noiseRect, self.cornerRadius);
            CGContextAddPath(context, noiseClippingPath);
            CGContextClip(context);
            CGPathRelease(noiseClippingPath);
            [self drawNoiseWithOpacity: 0.1];
        }
    }
    if ([window showsTitle] && (([window styleMask] & NSFullScreenWindowMask) == 0 || window.showsTitleInFullscreen)) {
        NSRect titleTextRect;
        NSDictionary *titleTextStyles = nil;
        [self getTitleFrame: &titleTextRect textAttributes: &titleTextStyles forWindow: window];
        [window.title drawInRect: titleTextRect withAttributes: titleTextStyles];
    }
}

- (void) getTitleFrame: (out NSRect *) frame textAttributes: (out NSDictionary **) attributes forWindow: (DPCustomWindow *) window {
    BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);
    NSShadow *titleTextShadow = drawsAsMainWindow ? window.titleTextShadow: window.inactiveTitleTextShadow;
    if (titleTextShadow == nil) {
        titleTextShadow = [[NSShadow alloc] init];
        titleTextShadow.shadowBlurRadius = 0.0;
        titleTextShadow.shadowOffset = NSMakeSize(0, -1);
        titleTextShadow.shadowColor = [NSColor colorWithDeviceWhite: 1.0 alpha: 0.5];
    }
    NSColor *titleTextColor = drawsAsMainWindow ? window.titleTextColor: window.inactiveTitleTextColor;
    titleTextColor = titleTextColor ? titleTextColor: drawsAsMainWindow ? IN_COLOR_MAIN_TITLE_TEXT: IN_COLOR_NOTMAIN_TITLE_TEXT;
    NSDictionary *titleTextStyles = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSFont titleBarFontOfSize: [NSFont systemFontSizeForControlSize: NSRegularControlSize]], NSFontAttributeName,
            titleTextColor, NSForegroundColorAttributeName,
            titleTextShadow, NSShadowAttributeName,
            nil];
    NSSize titleSize = [window.title sizeWithAttributes: titleTextStyles];
    NSRect titleTextRect;
    titleTextRect.size = titleSize;
    NSButton *docIconButton = [window standardWindowButton: NSWindowDocumentIconButton];
    NSButton *versionsButton = [window standardWindowButton: NSWindowDocumentVersionsButton];
    if (docIconButton) {
        NSRect docIconButtonFrame = [self convertRect: docIconButton.frame fromView: docIconButton.superview];
        titleTextRect.origin.x = NSMaxX(docIconButtonFrame) + 4.0;
        titleTextRect.origin.y = NSMidY(docIconButtonFrame) - titleSize.height / 2 + 1;
    }
    else if (versionsButton) {
        NSRect versionsButtonFrame = [self convertRect: versionsButton.frame fromView: versionsButton.superview];
        titleTextRect.origin.x = NSMinX(versionsButtonFrame) - titleSize.width - 1;
        NSDocument *document = (NSDocument *) [(NSWindowController *) self.window.windowController document];
        if ([document hasUnautosavedChanges] || [document isDocumentEdited]) {
            titleTextRect.origin.x -= 20;
        }
    }
    else {
        titleTextRect.origin.x = NSMidX(self.bounds) - titleSize.width / 2;
    }
    titleTextRect.origin.y = NSMaxY(self.bounds) - titleSize.height - 2.0;
    if (frame) {
        *frame = titleTextRect;
    }
    if (attributes) {
        *attributes = titleTextStyles;
    }
}

- (void) mouseUp: (NSEvent *) theEvent {
    if ([theEvent clickCount] == 2) {
        // Get settings from "System Preferences" >  "Appearance" > "Double-click on windows title bar to minimize"
        NSString *const MDAppleMiniaturizeOnDoubleClickKey = @"AppleMiniaturizeOnDoubleClick";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL shouldMiniaturize = [[userDefaults objectForKey: MDAppleMiniaturizeOnDoubleClickKey] boolValue];
        if (shouldMiniaturize) {
            [[self window] miniaturize: self];
        }
    }
}

@end