//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "INTitleBarView.h"
#import "INAppStoreWindow.h"


@implementation INTitleBarView {
}


@synthesize cornerRadius;

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
    INAppStoreWindow *window = (INAppStoreWindow *)
    [self window];
    BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);
    NSRect drawingRect = [self bounds];
    if (window.titleBarDrawingBlock) {
        CGPathRef clippingPath = createClippingPathWithRectAndRadius(drawingRect, cornerRadius);
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
        CGPathRef clippingPath = createClippingPathWithRectAndRadius(clippingRect, cornerRadius);
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
            CGPathRef noiseClippingPath =
                    createClippingPathWithRectAndRadius(noiseRect, cornerRadius);
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

- (void) getTitleFrame: (out NSRect *) frame textAttributes: (out NSDictionary **) attributes forWindow: (in INAppStoreWindow *) window {
    BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);
    NSShadow *titleTextShadow = drawsAsMainWindow ? window.titleTextShadow: window.inactiveTitleTextShadow;
    if (titleTextShadow == nil) {
#if __has_feature(objc_arc)
        titleTextShadow = [[NSShadow alloc] init];
#else
        titleTextShadow = [[[NSShadow alloc] init] autorelease];
        #endif
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


