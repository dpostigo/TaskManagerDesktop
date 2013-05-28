//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPCustomWindow.h"
#import "DPCustomWindowDelegateProxy.h"
#import "DPCustomTitleBarContainer.h"
#import "DPTitleBarView.h"
#import "NSColor+INAdditions.h"


const CGFloat DPCornerClipRadius = 4.0;

NS_INLINE CGFloat DPMidHeight(NSRect aRect) {
    return (aRect.size.height * (CGFloat) 0.5);
}

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


@interface DPCustomWindow ()


- (void) _doInitialWindowSetup;
- (void) _createTitlebarView;
- (void) _setupTrafficLightsTrackingArea;
- (void) _recalculateFrameForTitleBarContainer;
- (void) _repositionContentView;
- (void) _layoutTrafficLightsAndContent;
- (CGFloat) _minimumTitlebarHeight;
- (void) _displayWindowAndTitlebar;
- (void) _hideTitleBarView: (BOOL) hidden;
- (CGFloat) _defaultTrafficLightLeftMargin;
- (CGFloat) _defaultTrafficLightSeparation;
@end


@implementation DPCustomWindow {
    CGFloat cachedTitleBarHeight;

    BOOL setFullScreenButtonRightMargin;
    BOOL preventWindowFrameChange;
    DPCustomWindowDelegateProxy *delegateProxy;
    DPCustomTitleBarContainer *titleBarContainer;
}


@synthesize cornerRadius;
@synthesize titleBarHeight;
@synthesize titleBarView;
@synthesize centerFullScreenButton;
@synthesize centerTrafficLightButtons;
@synthesize verticalTrafficLightButtons;
@synthesize hideTitleBarInFullScreen;
@synthesize showsBaselineSeparator;
@synthesize trafficLightButtonsLeftMargin;
@synthesize trafficLightButtonsTopMargin;
@synthesize fullScreenButtonRightMargin;
@synthesize fullScreenButtonTopMargin;
@synthesize trafficLightSeparation;
@synthesize showsTitle;
@synthesize showsTitleInFullscreen;
@synthesize closeButton;
@synthesize minimizeButton;
@synthesize zoomButton;
@synthesize fullScreenButton;
@synthesize titleBarStartColor;
@synthesize titleBarEndColor;
@synthesize baselineSeparatorColor;
@synthesize titleTextColor;
@synthesize titleTextShadow;
@synthesize inactiveTitleBarStartColor;
@synthesize inactiveTitleBarEndColor;
@synthesize inactiveBaselineSeparatorColor;
@synthesize inactiveTitleTextColor;
@synthesize inactiveTitleTextShadow;

- (id) initWithContentRect: (NSRect) contentRect styleMask: (NSUInteger) aStyle backing: (NSBackingStoreType) bufferingType defer: (BOOL) flag {
    self = [super initWithContentRect: contentRect styleMask: aStyle backing: bufferingType defer: flag];
    if (self) {
        [self _doInitialWindowSetup];
    }
    return self;
}

- (id) initWithContentRect: (NSRect) contentRect styleMask: (NSUInteger) aStyle backing: (NSBackingStoreType) bufferingType defer: (BOOL) flag screen: (NSScreen *) screen {
    self = [super initWithContentRect: contentRect styleMask: aStyle backing: bufferingType defer: flag screen: screen];
    if (self) {
        [self _doInitialWindowSetup];
    }
    return self;
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    //    [self setDelegate:nil];
#if !__has_feature(objc_arc)
//    [delegateProxy release];
    [_titleBarView release];
    [closeButton release];
    [minimizeButton release];
    [zoomButton release];
    [fullScreenButton release];
    [super dealloc];
    #endif
}

#pragma mark -
#pragma mark NSWindow Overrides

- (void) becomeKeyWindow {
    [super becomeKeyWindow];
    [self _updateTitlebarView];
    [self _layoutTrafficLightsAndContent];
    [self _setupTrafficLightsTrackingArea];
}

- (void) resignKeyWindow {
    [super resignKeyWindow];
    [self _updateTitlebarView];
    [self _layoutTrafficLightsAndContent];
}

- (void) becomeMainWindow {
    [super becomeMainWindow];
    [self _updateTitlebarView];
}

- (void) resignMainWindow {
    [super resignMainWindow];
    [self _updateTitlebarView];
}

- (void) setContentView: (NSView *) aView {
    [super setContentView: aView];
    [self _repositionContentView];
}

- (void) setTitle: (NSString *) aString {
    [super setTitle: aString];
    [self _layoutTrafficLightsAndContent];
    [self _displayWindowAndTitlebar];
}

#pragma mark -
#pragma mark Accessors

- (void) setCornerRadius: (CGFloat) cornerRadius1 {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    cornerRadius = cornerRadius1;
    titleBarView.cornerRadius = cornerRadius;

    //
    [self _layoutTrafficLightsAndContent];
    [self _displayWindowAndTitlebar];
}

- (void) setTitleBarView: (DPTitleBarView *) newTitleBarView {
    if ((titleBarView != newTitleBarView) && newTitleBarView) {
        [titleBarView removeFromSuperview];
        titleBarView = newTitleBarView;

        [titleBarView setFrame: [titleBarContainer bounds]];
        [titleBarView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
        [titleBarContainer addSubview: titleBarView];
    }
}

- (void) setTitleBarHeight: (CGFloat) newTitleBarHeight {
    if (titleBarHeight != newTitleBarHeight) {
        cachedTitleBarHeight = newTitleBarHeight;
        titleBarHeight = cachedTitleBarHeight;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
    }
}

- (void) setShowsBaselineSeparator: (BOOL) showsBaselineSeparator1 {
    if (showsBaselineSeparator != showsBaselineSeparator1) {
        showsBaselineSeparator = showsBaselineSeparator1;
        [self.titleBarView setNeedsDisplay: YES];
    }
}

- (void) setTrafficLightButtonsLeftMargin: (CGFloat) newTrafficLightButtonsLeftMargin {
    if (trafficLightButtonsLeftMargin != newTrafficLightButtonsLeftMargin) {
        trafficLightButtonsLeftMargin = newTrafficLightButtonsLeftMargin;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
        [self _setupTrafficLightsTrackingArea];
    }
}

- (void) setFullScreenButtonRightMargin: (CGFloat) newFullScreenButtonRightMargin {
    if (fullScreenButtonRightMargin != newFullScreenButtonRightMargin) {
        setFullScreenButtonRightMargin = YES;
        fullScreenButtonRightMargin = newFullScreenButtonRightMargin;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
    }
}

- (void) setShowsTitle: (BOOL) showsTitle {
    if (showsTitle != showsTitle) {
        showsTitle = showsTitle;
        [self _displayWindowAndTitlebar];
    }
}

- (void) setCenterFullScreenButton: (BOOL) centerFullScreenButton {
    if (centerFullScreenButton != centerFullScreenButton) {
        centerFullScreenButton = centerFullScreenButton;
        [self _layoutTrafficLightsAndContent];
    }
}

- (void) setCenterTrafficLightButtons: (BOOL) centerTrafficLightButtons {
    if (centerTrafficLightButtons != centerTrafficLightButtons) {
        centerTrafficLightButtons = centerTrafficLightButtons;
        [self _layoutTrafficLightsAndContent];
        [self _setupTrafficLightsTrackingArea];
    }
}

- (void) setVerticalTrafficLightButtons: (BOOL) verticalTrafficLightButtons {
    if (verticalTrafficLightButtons != verticalTrafficLightButtons) {
        verticalTrafficLightButtons = verticalTrafficLightButtons;
        [self _layoutTrafficLightsAndContent];
        [self _setupTrafficLightsTrackingArea];
    }
}

- (void) setTrafficLightSeparation: (CGFloat) trafficLightSeparation {
    if (trafficLightSeparation != trafficLightSeparation) {
        trafficLightSeparation = trafficLightSeparation;
        [self _layoutTrafficLightsAndContent];
        [self _setupTrafficLightsTrackingArea];
    }
}

- (void) setDelegate: (id <NSWindowDelegate>) anObject {
    [delegateProxy setSecondaryDelegate: anObject];
    [super setDelegate: nil];
    [super setDelegate: delegateProxy];
}

- (id <NSWindowDelegate>) delegate {
    return [delegateProxy secondaryDelegate];
}

- (void) setCloseButton: (DPCustomWindowButton *) closeButton {
    if (closeButton != closeButton) {
        [closeButton removeFromSuperview];
        closeButton = closeButton;
        if (closeButton) {
            closeButton.target = self;
            closeButton.action = @selector(performClose:);
            [closeButton setFrameOrigin: [[self standardWindowButton: NSWindowCloseButton] frame].origin];
            [[self themeFrameView] addSubview: closeButton];
        }
    }
}

- (void) setMinimizeButton: (DPCustomWindowButton *) minimizeButton {
    if (minimizeButton != minimizeButton) {
        [minimizeButton removeFromSuperview];
        minimizeButton = minimizeButton;
        if (minimizeButton) {
            minimizeButton.target = self;
            minimizeButton.action = @selector(performMiniaturize:);
            [minimizeButton setFrameOrigin: [[self standardWindowButton: NSWindowMiniaturizeButton] frame].origin];
            [[self themeFrameView] addSubview: minimizeButton];
        }
    }
}

- (void) setZoomButton: (DPCustomWindowButton *) zoomButton {
    if (zoomButton != zoomButton) {
        [zoomButton removeFromSuperview];
        zoomButton = zoomButton;
        if (zoomButton) {
            zoomButton .target = self;
            zoomButton .action = @selector(performZoom:);
            [zoomButton setFrameOrigin: [[self standardWindowButton: NSWindowZoomButton] frame].origin];
            [[self themeFrameView] addSubview: zoomButton];
        }
    }
}

- (void) setFullScreenButton: (DPCustomWindowButton *) fullScreenButton {
    if (fullScreenButton != fullScreenButton) {
        [fullScreenButton removeFromSuperview];
        fullScreenButton = fullScreenButton;
        if (fullScreenButton) {
            fullScreenButton.target = self;
            fullScreenButton.action = @selector(toggleFullScreen:);
            [fullScreenButton setFrameOrigin: [[self standardWindowButton: NSWindowFullScreenButton] frame].origin];
            [[self themeFrameView] addSubview: fullScreenButton];
        }
    }
}

- (void) setStyleMask: (NSUInteger) styleMask {
    preventWindowFrameChange = YES;
    [super setStyleMask: styleMask];
    preventWindowFrameChange = NO;
}

- (void) setFrame: (NSRect) frameRect display: (BOOL) flag {
    if (!preventWindowFrameChange)
        [super setFrame: frameRect display: flag];
}

- (void) setFrame: (NSRect) frameRect display: (BOOL) displayFlag animate: (BOOL) animateFlag {
    if (!preventWindowFrameChange)
        [super setFrame: frameRect display: displayFlag animate: animateFlag];
}

#pragma mark -
#pragma mark Private

- (void) _doInitialWindowSetup {
    cornerRadius = 100.0;
    showsBaselineSeparator = YES;
    centerTrafficLightButtons = YES;
    titleBarHeight = [self _minimumTitlebarHeight];
    cachedTitleBarHeight = titleBarHeight;
    trafficLightButtonsLeftMargin = [self _defaultTrafficLightLeftMargin];
    delegateProxy = [DPCustomWindowDelegateProxy alloc];
    trafficLightButtonsTopMargin = 3.f;
    fullScreenButtonTopMargin = 3.f;
    trafficLightSeparation = [self _defaultTrafficLightSeparation];
    [super setDelegate: delegateProxy];

    /** -----------------------------------------
     - The window automatically does layout every time its moved or resized, which means that the traffic lights and content view get reset at the original positions, so we need to put them back in place
     - NSWindow is hardcoded to redraw the traffic lights in a specific rect, so when they are moved down, only part of the buttons get redrawn, causing graphical artifacts. Therefore, the window must be force redrawn every time it becomes key/resigns key
     ----------------------------------------- **/
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self selector: @selector(_layoutTrafficLightsAndContent) name: NSWindowDidResizeNotification object: self];
    [nc addObserver: self selector: @selector(_layoutTrafficLightsAndContent) name: NSWindowDidMoveNotification object: self];
    [nc addObserver: self selector: @selector(_layoutTrafficLightsAndContent) name: NSWindowDidEndSheetNotification object: self];
    [nc addObserver: self selector: @selector(_updateTitlebarView) name: NSApplicationDidBecomeActiveNotification object: nil];
    [nc addObserver: self selector: @selector(_updateTitlebarView) name: NSApplicationDidResignActiveNotification object: nil];
#if IN_COMPILING_LION
    if (IN_RUNNING_LION) {
        [nc addObserver: self selector: @selector(_setupTrafficLightsTrackingArea) name: NSWindowDidExitFullScreenNotification object: nil];
        [nc addObserver: self selector: @selector(windowWillEnterFullScreen:) name: NSWindowWillEnterFullScreenNotification object: nil];
        [nc addObserver: self selector: @selector(windowWillExitFullScreen:) name: NSWindowWillExitFullScreenNotification object: nil];
    }
#endif
    [self _createTitlebarView];
    [self _layoutTrafficLightsAndContent];
    [self _setupTrafficLightsTrackingArea];
}

- (NSButton *) _windowButtonToLayout: (NSWindowButton) defaultButtonType orUserProvided: (NSButton *) userButton {
    NSButton *defaultButton = [self standardWindowButton: defaultButtonType];
    if (userButton) {
        [defaultButton setHidden: YES];
        defaultButton = userButton;
    } else if ([defaultButton superview] != [self themeFrameView]) {
        [defaultButton setHidden: NO];
    }
    return defaultButton;
}

- (NSButton *) closeButtonToLayout {
    return [self _windowButtonToLayout: NSWindowCloseButton orUserProvided: self.closeButton];
}

- (NSButton *) minimizeButtonToLayout {
    return [self _windowButtonToLayout: NSWindowMiniaturizeButton orUserProvided: self.minimizeButton];
}

- (NSButton *) zoomButtonToLayout {
    return [self _windowButtonToLayout: NSWindowZoomButton orUserProvided: self.zoomButton];
}

- (NSButton *) fullScreenButtonToLayout {
    return [self _windowButtonToLayout: NSWindowFullScreenButton orUserProvided: self.fullScreenButton];
}

- (void) _layoutTrafficLightsAndContent {
    // Reposition/resize the title bar view as needed
    [self _recalculateFrameForTitleBarContainer];
    NSButton *close = [self closeButtonToLayout];
    NSButton *minimize = [self minimizeButtonToLayout];
    NSButton *zoom = [self zoomButtonToLayout];

    // Set the frame of the window buttons
    NSRect closeFrame = [close frame];
    NSRect minimizeFrame = [minimize frame];
    NSRect zoomFrame = [zoom frame];
    NSRect titleBarFrame = [titleBarContainer frame];
    CGFloat buttonOrigin = 0.0;
    if (!self.verticalTrafficLightButtons) {
        if (self.centerTrafficLightButtons) {
            buttonOrigin = round(NSMidY(titleBarFrame) - DPMidHeight(closeFrame));
        } else {
            buttonOrigin = NSMaxY(titleBarFrame) - NSHeight(closeFrame) - self.trafficLightButtonsTopMargin;
        }
        closeFrame.origin.y = buttonOrigin;
        minimizeFrame.origin.y = buttonOrigin;
        zoomFrame.origin.y = buttonOrigin;
        closeFrame.origin.x = self.trafficLightButtonsLeftMargin;
        minimizeFrame.origin.x = NSMaxX(closeFrame) + self.trafficLightSeparation;
        zoomFrame.origin.x = NSMaxX(minimizeFrame) + self.trafficLightSeparation;
    } else {
        CGFloat groupHeight = NSHeight(closeFrame) + NSHeight(minimizeFrame) + NSHeight(zoomFrame) + 2.f * (self.trafficLightSeparation - 2.f);
        if (self.centerTrafficLightButtons) {
            buttonOrigin = round(NSMidY(titleBarFrame) - groupHeight / 2.f);
        } else {
            buttonOrigin = NSMaxY(titleBarFrame) - groupHeight - self.trafficLightButtonsTopMargin;
        }
        closeFrame.origin.x = self.trafficLightButtonsLeftMargin;
        minimizeFrame.origin.x = self.trafficLightButtonsLeftMargin;
        zoomFrame.origin.x = self.trafficLightButtonsLeftMargin;
        zoomFrame.origin.y = buttonOrigin;
        minimizeFrame.origin.y = NSMaxY(zoomFrame) + self.trafficLightSeparation - 2.f;
        closeFrame.origin.y = NSMaxY(minimizeFrame) + self.trafficLightSeparation - 2.f;
    }
    [close setFrame: closeFrame];
    [minimize setFrame: minimizeFrame];
    [zoom setFrame: zoomFrame];
#if IN_COMPILING_LION
    // Set the frame of the FullScreen button in Lion if available
    if (IN_RUNNING_LION) {
        NSButton *fullScreen = [self fullScreenButtonToLayout];
        if (fullScreen) {
            NSRect fullScreenFrame = [fullScreen frame];
            if (!_setFullScreenButtonRightMargin) {
                self.fullScreenButtonRightMargin = NSWidth([titleBarContainer frame]) - NSMaxX(fullScreen.frame);
            }
            fullScreenFrame.origin.x = NSWidth(titleBarFrame) - NSWidth(fullScreenFrame) - fullScreenButtonRightMargin;
            if (self.centerFullScreenButton) {
                fullScreenFrame.origin.y = round(NSMidY(titleBarFrame) - INMidHeight(fullScreenFrame));
            } else {
                fullScreenFrame.origin.y = NSMaxY(titleBarFrame) - NSHeight(fullScreenFrame) - self.trafficLightButtonsTopMargin;
            }
            [fullScreen setFrame: fullScreenFrame];
        }
    }
#endif
    [self _repositionContentView];
}

- (void) undoManagerDidCloseUndoGroupNotification: (NSNotification *) notification {
    [self _displayWindowAndTitlebar];
}

- (void) windowWillEnterFullScreen: (NSNotification *) notification {
    if (hideTitleBarInFullScreen) {
        // Recalculate the views when entering from fullscreen
        titleBarHeight = 0.0f;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
        [self _hideTitleBarView: YES];
    }
}

- (void) windowWillExitFullScreen: (NSNotification *) notification {
    if (hideTitleBarInFullScreen) {
        titleBarHeight = cachedTitleBarHeight;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
        [self _hideTitleBarView: NO];
    }
}

- (NSView *) themeFrameView {
    return [[self contentView] superview];
}

- (void) _createTitlebarView {
    // Create the title bar view
    DPCustomTitleBarContainer *container = [[DPCustomTitleBarContainer alloc] initWithFrame: NSZeroRect];
    // Configure the view properties and add it as a subview of the theme frame
    NSView *firstSubview = [[[self themeFrameView] subviews] objectAtIndex: 0];
    [self _recalculateFrameForTitleBarContainer];
    [[self themeFrameView] addSubview: container positioned: NSWindowBelow relativeTo: firstSubview];
    titleBarContainer = container;
    self.titleBarView = [[DPTitleBarView alloc] initWithFrame: NSZeroRect];
    titleBarView.cornerRadius = cornerRadius;
}

- (void) _hideTitleBarView: (BOOL) hidden {
    [self.titleBarView setHidden: hidden];
}

// Solution for tracking area issue thanks to @Perspx (Alex Rozanski) <https://gist.github.com/972958>
- (void) _setupTrafficLightsTrackingArea {
    [[self themeFrameView] viewWillStartLiveResize];
    [[self themeFrameView] viewDidEndLiveResize];
}

- (void) _recalculateFrameForTitleBarContainer {
    NSRect themeFrameRect = [[self themeFrameView] frame];
    NSRect titleFrame = NSMakeRect(0.0, NSMaxY(themeFrameRect) - titleBarHeight, NSWidth(themeFrameRect), titleBarHeight);
    [titleBarContainer setFrame: titleFrame];
}

- (void) _repositionContentView {
    NSView *contentView = [self contentView];
    NSRect windowFrame = [self frame];
    NSRect currentContentFrame = [contentView frame];
    NSRect newFrame = currentContentFrame;
    CGFloat titleHeight = NSHeight(windowFrame) - NSHeight(newFrame);
    CGFloat extraHeight = titleBarHeight - titleHeight;
    newFrame.size.height -= extraHeight;
    if (!NSEqualRects(currentContentFrame, newFrame)) {
        [contentView setFrame: newFrame];
        [contentView setNeedsDisplay: YES];
    }
}

- (CGFloat) _minimumTitlebarHeight {
    static CGFloat minTitleHeight = 0.0;
    if (!minTitleHeight) {
        NSRect frameRect = [self frame];
        NSRect contentRect = [self contentRectForFrameRect: frameRect];
        minTitleHeight = NSHeight(frameRect) - NSHeight(contentRect);
    }
    return minTitleHeight;
}

- (CGFloat) _defaultTrafficLightLeftMargin {
    static CGFloat trafficLightLeftMargin = 0.0;
    if (!trafficLightLeftMargin) {
        NSButton *close = [self closeButtonToLayout];
        trafficLightLeftMargin = NSMinX(close.frame);
    }
    return trafficLightLeftMargin;
}

- (CGFloat) _defaultTrafficLightSeparation {
    static CGFloat trafficLightSeparation = 0.0;
    if (!trafficLightSeparation) {
        NSButton *close = [self closeButtonToLayout];
        NSButton *minimize = [self minimizeButtonToLayout];
        trafficLightSeparation = NSMinX(minimize.frame) - NSMaxX(close.frame);
    }
    return trafficLightSeparation;
}

- (void) _displayWindowAndTitlebar {
    // Redraw the window and titlebar
    [titleBarView setNeedsDisplay: YES];
}

- (void) _updateTitlebarView {
    [titleBarView setNeedsDisplay: YES];

    // "validate" any controls in the titlebar view
    BOOL isMainWindowAndActive = ([self isMainWindow] && [[NSApplication sharedApplication] isActive]);
    for (NSView *childView in [titleBarView subviews]) {
        if ([childView isKindOfClass: [NSControl class]]) {
            [(NSControl *) childView setEnabled: isMainWindowAndActive];
        }
    }
}
@end