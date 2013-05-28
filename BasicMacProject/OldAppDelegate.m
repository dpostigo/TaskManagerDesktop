#import "OldAppDelegate.h"
#import "ColoredWindowController.h"
#import "INWindowButton.h"
#import "PrioritySplitViewDelegate.h"


#define LEFT_VIEW_INDEX 0
#define LEFT_VIEW_PRIORITY 2
#define LEFT_VIEW_MINIMUM_WIDTH 60.0
#define MAIN_VIEW_INDEX 1
#define MAIN_VIEW_PRIORITY 0
#define MAIN_VIEW_MINIMUM_WIDTH 20.0
#define RIGHT_VIEW_INDEX 2


@implementation OldAppDelegate {
    PrioritySplitViewDelegate *splitViewDelegate;
}


- (void) applicationDidFinishLaunching: (NSNotification *) aNotification {

    backgroundView.backgroundColor = [NSColor colorWithPatternImage: [NSImage imageNamed: @"background-texture.png"]];
    sidebarBackground.backgroundColor = [NSColor colorWithDeviceWhite: 1.0 alpha: 0.5];
    //    sidebarBackground.backgroundColor= [NSColor colorWithDeviceWhite: 0.3 alpha: 0.5];
    sidebarOutlineView.mainContentView.backgroundColor = [NSColor clearColor];

    [sidebarOutlineView setContentViewToName: @"Inbox"];

    [self configureCustomWindow];
    [self configureSplitView];
}

- (void) setupCloseButton {
    INWindowButton *closeButton = [INWindowButton windowButtonWithSize: NSMakeSize(14, 16) groupIdentifier: nil];
    closeButton.activeImage = [NSImage imageNamed: @"close-active-color.tiff"];
    closeButton.activeNotKeyWindowImage = [NSImage imageNamed: @"close-activenokey-color.tiff"];
    closeButton.inactiveImage = [NSImage imageNamed: @"close-inactive-disabled-color.tiff"];
    closeButton.pressedImage = [NSImage imageNamed: @"close-pd-color.tiff"];
    closeButton.rolloverImage = [NSImage imageNamed: @"close-rollover-color.tiff"];
    self.window.closeButton = closeButton;
}

- (void) setupMinimizeButton {
    INWindowButton *button = [INWindowButton windowButtonWithSize: NSMakeSize(14, 16) groupIdentifier: nil];
    button.activeImage = [NSImage imageNamed: @"minimize-active-color.tiff"];
    button.activeNotKeyWindowImage = [NSImage imageNamed: @"minimize-activenokey-color.tiff"];
    button.inactiveImage = [NSImage imageNamed: @"minimize-inactive-disabled-color.tiff"];
    button.pressedImage = [NSImage imageNamed: @"minimize-pd-color.tiff"];
    button.rolloverImage = [NSImage imageNamed: @"minimize-rollover-color.tiff"];
    self.window.minimizeButton = button;
}

- (void) setupZoomButton {
    INWindowButton *button = [INWindowButton windowButtonWithSize: NSMakeSize(14, 16) groupIdentifier: nil];
    button.activeImage = [NSImage imageNamed: @"zoom-active-color.tiff"];
    button.activeNotKeyWindowImage = [NSImage imageNamed: @"zoom-activenokey-color.tiff"];
    button.inactiveImage = [NSImage imageNamed: @"zoom-inactive-disabled-color.tiff"];
    button.pressedImage = [NSImage imageNamed: @"zoom-pd-color.tiff"];
    button.rolloverImage = [NSImage imageNamed: @"zoom-rollover-color.tiff"];
    self.window.zoomButton = button;
}

- (IBAction) showSheetAction: (id) sender {
    [NSApp beginSheet: self.sheet modalForWindow: self.window
        modalDelegate: self didEndSelector: nil contextInfo: nil];
}

- (IBAction) doneSheetAction: (id) sender {
    [self.sheet orderOut: nil];
    [NSApp endSheet: self.sheet];
}

- (IBAction) createWindowController: (id) sender {
    ColoredWindowController *controller = [[ColoredWindowController alloc] initWithWindowNibName: @"ColoredWindow"];
    [controller showWindow: nil];
    [self.windowControllers addObject: controller];
}

- (IBAction) checkboxAction: (id) sender {
    if ([sender isEqual: self.centerFullScreen]) {
        self.window.centerFullScreenButton = [sender state];
    } else if ([sender isEqual: self.centerTrafficLight]) {
        self.window.centerTrafficLightButtons = [sender state];
    } else if ([sender isEqual: self.verticalTrafficLight]) {
        self.window.verticalTrafficLightButtons = [sender state];
    } else {
        self.window.showsBaselineSeparator = [sender state];
    }
}

- (IBAction) sliderAction: (id) sender {
    if ([sender isEqual: self.fullScreenRightMarginSlider]) {
        self.window.fullScreenButtonRightMargin = [sender doubleValue];
    } else if ([sender isEqual: self.trafficLightLeftMargin]) {
        self.window.trafficLightButtonsLeftMargin = [sender doubleValue];
    } else if ([sender isEqual: self.trafficLightSeparation]) {
        self.window.trafficLightSeparation = [sender doubleValue];
    }
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) sender {
    return YES;
}

- (void) configureSplitView {
    splitViewDelegate = [[PrioritySplitViewDelegate alloc] init];

    [splitViewDelegate setPriority: LEFT_VIEW_PRIORITY forViewAtIndex: LEFT_VIEW_INDEX];
    [splitViewDelegate setMinimumLength: LEFT_VIEW_MINIMUM_WIDTH forViewAtIndex: LEFT_VIEW_INDEX];
    [splitViewDelegate setPriority: MAIN_VIEW_PRIORITY forViewAtIndex: MAIN_VIEW_INDEX];
    [splitViewDelegate setMinimumLength: MAIN_VIEW_MINIMUM_WIDTH forViewAtIndex: MAIN_VIEW_INDEX];

    [splitView setDelegate: splitViewDelegate];
}

- (void) configureCustomWindow {
    self.windowControllers = [NSMutableArray array];
    self.centerFullScreen.state = self.window.centerFullScreenButton;
    self.centerTrafficLight.state = self.window.centerTrafficLightButtons;
    self.verticalTrafficLight.state = self.window.verticalTrafficLightButtons;
    self.showsBaselineSeparator.state = self.window.showsBaselineSeparator;
    self.fullScreenRightMarginSlider.doubleValue = self.window.fullScreenButtonRightMargin;
    self.trafficLightLeftMargin.doubleValue = self.window.trafficLightButtonsLeftMargin;
    self.trafficLightSeparation.doubleValue = self.window.trafficLightSeparation;

    [self setupCloseButton];
    [self setupMinimizeButton];
    [self setupZoomButton];

    [self configureWindow];
}

- (void) configureWindow {

    self.window.fullScreenButtonRightMargin = 7.0;
    self.window.centerFullScreenButton = YES;

    self.window.titleBarHeight = 40.0;
    self.window.trafficLightButtonsLeftMargin = 13.0;
    self.window.titleBarDrawingBlock = ^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath) {
        CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
        CGContextAddPath(ctx, clippingPath);
        CGContextClip(ctx);

        NSColor *chromeStartingColor = [NSColor colorWithCalibratedRed: 0 green: 0.319 blue: 0.9 alpha: 1];
        NSColor *chromeEndingColor = [NSColor colorWithCalibratedRed: 0 green: 0.627 blue: 0.9 alpha: 1];


        //        NSColor *chromeStartingColor = [NSColor colorWithCalibratedRed: 52/255.0 green: 119/255.0 blue: 194/255.0 alpha: 1];
        //        NSColor *chromeEndingColor = [NSColor colorWithCalibratedRed: 115/255.0 green: 184/255.0 blue: 243/255.0 alpha: 1];


        NSGradient *gradient = nil;
        if (drawsAsMainWindow) {
            gradient = [[NSGradient alloc] initWithStartingColor: chromeStartingColor
                                                     endingColor: chromeEndingColor];
            [[NSColor darkGrayColor] setFill];
        } else {
            // set the default non-main window gradientFill colors
            gradient = [[NSGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedWhite: 0.851f alpha: 1]
                                                     endingColor: [NSColor colorWithCalibratedWhite: 0.929f alpha: 1]];
            [[NSColor colorWithCalibratedWhite: 0.6f alpha: 1] setFill];
        }
        [gradient drawInRect: drawingRect angle: 90];
        NSRectFill(NSMakeRect(NSMinX(drawingRect), NSMinY(drawingRect), NSWidth(drawingRect), 1));
    };

    NSView *titleBarView = self.window.titleBarView;
    NSSize segmentSize = NSMakeSize(104, 25);
    NSRect segmentFrame = NSMakeRect(NSMidX(titleBarView.bounds) - (segmentSize.width), NSMidY(titleBarView.bounds) - (segmentSize.height / 2.f), segmentSize.width, segmentSize.height);
    NSSegmentedControl *segment = [[NSSegmentedControl alloc] initWithFrame: segmentFrame];
    [segment setSegmentCount: 3];
    [segment setImage: [NSImage imageNamed: NSImageNameIconViewTemplate] forSegment: 0];
    [segment setImage: [NSImage imageNamed: NSImageNameListViewTemplate] forSegment: 1];
    [segment setImage: [NSImage imageNamed: NSImageNameFlowViewTemplate] forSegment: 2];
    [segment setSelectedSegment: 0];
    [segment setSegmentStyle: NSSegmentStyleTexturedRounded];
    [titleBarView addSubview: segment];

    segment.right = titleBarView.width;
    segment.autoresizingMask = NSViewMaxXMargin;
}

- (void) buttonClicked: (id) sender {
    // Example target action for the button
    NSInteger row = [sidebarOutlineView rowForView: sender];
    NSLog(@"row: %ld", row);
}

- (IBAction) sidebarMenuDidChange: (id) sender {
    // Allow the user to pick a sidebar style
    NSInteger rowSizeStyle = [sender tag];
    [sidebarOutlineView setRowSizeStyle: rowSizeStyle];
}

- (void) menuNeedsUpdate: (NSMenu *) menu {
    for (NSInteger i = 0; i < [menu numberOfItems]; i++) {
        NSMenuItem *item = [menu itemAtIndex: i];
        if (![item isSeparatorItem]) {
            // In IB, the tag was set to the appropriate rowSizeStyle. Read in that value.
            NSInteger state = ([item tag] == [sidebarOutlineView rowSizeStyle]) ? 1: 0;
            [item setState: state];
        }
    }
}

- (BOOL) splitView: (NSSplitView *) splitView canCollapseSubview: (NSView *) subview {
    return NO;
}

- (CGFloat) splitView: (NSSplitView *) splitView constrainMinCoordinate: (CGFloat) proposedMinimumPosition ofSubviewAt: (NSInteger) dividerIndex {
    if (proposedMinimumPosition < 75) {
        proposedMinimumPosition = 75;
    }
    return proposedMinimumPosition;
}

@end
