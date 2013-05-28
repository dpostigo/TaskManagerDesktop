//
// Created by Daniela Postigo on 5/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "BasicCustomWindow.h"
#import "VeryBasicViewController.h"
#import "NSView+Animation.h"
#import "NSWindow+Animation.h"
#import "ModalWindow.h"


@implementation BasicCustomWindow {
    BasicBackgroundView *modalBackground;
}


@synthesize modalWindow;

- (void) presentModalView: (VeryBasicViewController *) controller withSize: (NSSize) size {
    [self presentModalView: controller withSize: size animated: NO];
}

- (void) presentModalView: (VeryBasicViewController *) controller withSize: (NSSize) size animated: (BOOL) animated {

    NSRect modalRect = [self modalRectForSize: size];
    CGRect rect = [self windowRectForModal];

    ModalWindow *window = [[ModalWindow alloc] initWithContentRect: rect styleMask: NSBorderlessWindowMask backing: NSBackingStoreBuffered defer: NO];
    window.backgroundColor = [NSColor colorWithDeviceWhite: 0.0 alpha: 0.5];
    [window setReleasedWhenClosed: NO];
    window.alphaValue = 0;
    self.modalWindow = window;

    controller.modalWindow = self;
    controller.view.frame = modalRect;

    [self addChildWindow: modalWindow ordered: NSWindowAbove];

    if (animated) {
        [controller.view animateInDirection: NSViewAnimationDirectionFromBottom amount: 10 duration: 0.4 alpha: 1 completionHandler: nil];
        [modalWindow animateToAlpha: 1 fromAlpha: 0 duration: 0.4 completionHandler: ^{
            [modalWindow makeKeyWindow];
        }];
    }
    [modalWindow.contentView addSubview: controller.view];
}

- (NSRect) modalRectForSize: (NSSize) size {
    NSRect modalRect = NSMakeRect(0, 0, size.width, size.height);
    modalRect.origin.x = (self.frame.size.width - modalRect.size.width) / 2;
    modalRect.origin.y = (self.frame.size.height - modalRect.size.height) * 0.66;
    return modalRect;
}

- (NSRect) windowRectForModal {
    CGRect wRect = self.frame;
    NSView *contentView = self.contentView;
    CGRect cRect = contentView.frame;
    CGRect rect = CGRectMake(wRect.origin.x, wRect.origin.y, cRect.size.width, cRect.size.height);
    return rect;
}

- (void) dismissCurrentModal {
    if (modalWindow != nil) {
        [self removeChildWindow: modalWindow];
        [modalWindow close];
    }
}

- (void) dismissController: (NSViewController *) controller animated: (BOOL) animated {

    if (modalWindow == nil) return;

    if (animated) {
        [controller.view animateInDirection: NSViewAnimationDirectionToBottom amount: 10 duration: 0.4 alpha: 0 completionHandler: ^{
            [self removeChildWindow: modalWindow];
            [modalWindow close];
        }];

        [modalWindow animateToAlpha: 0 fromAlpha: 1 duration: 0.4];
    } else {
        [self removeChildWindow: modalWindow];
        [modalWindow close];
    }
}

- (id) initWithContentRect: (NSRect) contentRect styleMask: (NSUInteger) aStyle backing: (NSBackingStoreType) bufferingType defer: (BOOL) flag {
    self = [super initWithContentRect: contentRect styleMask: aStyle backing: bufferingType defer: flag];
    if (self) {
        [self configureWindow];
        [self configureToolbar];
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
}

- (void) addController: (NSViewController *) viewController toView: (NSView *) aView {
    viewController.view.width = aView.frame.size.width;
    viewController.view.height = aView.frame.size.height;
    viewController.view.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
    [aView addSubview: viewController.view];
}

- (void) configureToolbar {
    NSLog(@"self.toolbar = %@", self.toolbar);

    self.showsToolbarButton = YES;
    [self toggleToolbarShown: self];
}

- (void) setupCloseButton {
    INWindowButton *button = [INWindowButton windowButtonWithSize: NSMakeSize(14, 16) groupIdentifier: nil];
    button.activeImage = [NSImage imageNamed: @"close-active-color.tiff"];
    button.activeNotKeyWindowImage = [NSImage imageNamed: @"close-activenokey-color.tiff"];
    button.inactiveImage = [NSImage imageNamed: @"close-inactive-disabled-color.tiff"];
    button.pressedImage = [NSImage imageNamed: @"close-pd-color.tiff"];
    button.rolloverImage = [NSImage imageNamed: @"close-rollover-color.tiff"];
    self.closeButton = button;
}

- (void) setupMinimizeButton {
    INWindowButton *button = [INWindowButton windowButtonWithSize: NSMakeSize(14, 16) groupIdentifier: nil];
    button.activeImage = [NSImage imageNamed: @"minimize-active-color.tiff"];
    button.activeNotKeyWindowImage = [NSImage imageNamed: @"minimize-activenokey-color.tiff"];
    button.inactiveImage = [NSImage imageNamed: @"minimize-inactive-disabled-color.tiff"];
    button.pressedImage = [NSImage imageNamed: @"minimize-pd-color.tiff"];
    button.rolloverImage = [NSImage imageNamed: @"minimize-rollover-color.tiff"];
    self.minimizeButton = button;
}

- (void) setupZoomButton {
    INWindowButton *button = [INWindowButton windowButtonWithSize: NSMakeSize(14, 16) groupIdentifier: nil];
    button.activeImage = [NSImage imageNamed: @"zoom-active-color.tiff"];
    button.activeNotKeyWindowImage = [NSImage imageNamed: @"zoom-activenokey-color.tiff"];
    button.inactiveImage = [NSImage imageNamed: @"zoom-inactive-disabled-color.tiff"];
    button.pressedImage = [NSImage imageNamed: @"zoom-pd-color.tiff"];
    button.rolloverImage = [NSImage imageNamed: @"zoom-rollover-color.tiff"];
    self.zoomButton = button;
}

- (void) configureWindow {
    self.fullScreenButtonRightMargin = 7.0;
    self.fullScreenButtonRightMargin = 7.0;
    self.centerFullScreenButton = YES;
    self.titleBarHeight = 40.0;
    self.trafficLightButtonsLeftMargin = 13.0;


    self.titleBarDrawingBlock = ^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath) {
        CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
        CGContextAddPath(ctx, clippingPath);
        CGContextClip(ctx);
        NSColor *chromeEndingColor = [NSColor colorWithCalibratedRed: 52 / 255.0 green: 160 / 255.0 blue: 194 / 255.0 alpha: 1];
        NSColor *chromeStartingColor = [NSColor colorWithCalibratedRed: 115 / 255.0 green: 184 / 255.0 blue: 194 / 255.0 alpha: 1];
        chromeStartingColor = [NSColor colorWithCalibratedRed: 38 / 255.0 green: (43 / 255.0) blue: (46 / 255.0) alpha: 1.0];
        chromeEndingColor = [NSColor colorWithCalibratedRed: (52 / 255.0) green: (58 / 255.0) blue: (61 / 255.0) alpha: 1.0];
        NSGradient *gradient = nil;
        if (drawsAsMainWindow) {
            gradient = [[NSGradient alloc] initWithStartingColor: chromeStartingColor endingColor: chromeEndingColor];
            [[NSColor darkGrayColor] setFill];
        } else {
            // set the default non-main window gradientFill colors
            gradient = [[NSGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedWhite: 0.851f alpha: 1] endingColor: [NSColor colorWithCalibratedWhite: 0.929f alpha: 1]];
            [[NSColor colorWithCalibratedWhite: 0.6f alpha: 1] setFill];
        }
        [gradient drawInRect: drawingRect angle: 90];
        NSRectFill(NSMakeRect(NSMinX(drawingRect), NSMinY(drawingRect), NSWidth(drawingRect), 1));
    };
    [self addControls];
}

- (void) addControls {
    NSSize segmentSize = NSMakeSize(104, 25);
    NSRect segmentFrame = NSMakeRect(NSMidX(self.titleBarView.bounds) - (segmentSize.width), NSMidY(self.titleBarView.bounds) - (segmentSize.height / 2.f), segmentSize.width, segmentSize.height);

    NSSegmentedControl *segment = [[NSSegmentedControl alloc] initWithFrame: segmentFrame];
    segment.segmentCount = 3;
    segment.selectedSegment = 0;
    //    segment.segmentStyle = NSSegmentStyleTexturedRounded;
    segment.segmentStyle = NSSegmentStyleCapsule;
    segment.segmentStyle = NSSegmentStyleSmallSquare;
    //    segment.segmentStyle = NSSegmentStyleRoundRect;

    [segment setImage: [NSImage imageNamed: NSImageNameIconViewTemplate] forSegment: 0];
    [segment setImage: [NSImage imageNamed: NSImageNameListViewTemplate] forSegment: 1];
    [segment setImage: [NSImage imageNamed: NSImageNameFlowViewTemplate] forSegment: 2];
    [segment setAction: @selector(handleSegmentClicked:)];
    //    [self.titleBarView addSubview: segment];
    segment.right = self.titleBarView.width;
    segment.autoresizingMask = NSViewMinXMargin;
}

- (IBAction) handleSegmentClicked: (id) sender {
    NSSegmentedControl *control = sender;
    if (control.selectedSegment == 0) {
        [self iconSegmentClicked: sender];
    }
    else if (control.selectedSegment == 1) {
        [self listSegmentClicked: sender];
    }
    else if (control.selectedSegment == 2) {
        [self flowIconClicked: sender];
    }
}

- (IBAction) iconSegmentClicked: (id) sender {
}

- (IBAction) listSegmentClicked: (id) sender {
}

- (IBAction) flowIconClicked: (id) sender {
}

@end