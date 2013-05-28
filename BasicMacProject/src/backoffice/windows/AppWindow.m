//
// Created by Daniela Postigo on 5/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AppWindow.h"
#import "SidebarViewController.h"
#import "BottomViewController.h"
#import "TasksViewController.h"
#import "BONavigationBar.h"


#define MIN_SIDEBAR_WIDTH 150.0f
#define MAX_SIDEBAR_WIDTH 250.0f
#define MIN_MAIN_WIDTH 600.0f
#define MAX_BOTTOM_HEIGHT 130.0f
#define MIN_BOTTOM_VIEW_HEIGHT 40.0f


@implementation AppWindow {
    BOOL sidebarIsOpen;
    CGFloat originalWidth;
    SidebarViewController *sidebarViewController;
    BOOL isToggling;
    CGFloat currentSidebarWidth;
    CGFloat lastSidebarWidth;
}


- (id) initWithContentRect: (NSRect) contentRect styleMask: (NSUInteger) aStyle backing: (NSBackingStoreType) bufferingType defer: (BOOL) flag {
    self = [super initWithContentRect: contentRect styleMask: aStyle backing: bufferingType defer: flag];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];

    mainSplitView.dividerThickness = 1;
    mainSplitView.dividerColor = [NSColor blackColor];
    bottomSplitView.dividerColor = [NSColor blackColor];

    sidebarIsOpen = YES;
    originalWidth = self.frame.size.width;

    sidebarViewController = [[SidebarViewController alloc] initWithDefaultNib];
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController: [[TasksViewController alloc] initWithDefaultNib]];
    navigationController.navigationBar = [[BONavigationBar alloc] initWithFrame: NSZeroRect];



    [self addController: sidebarViewController toView: sidebarView];
    [self addController: [[BottomViewController alloc] initWithDefaultNib] toView: bottomView];
    [self addController: navigationController toView: mainView];

//    [bottomSplitView setCanCollapse: YES subviewAtIndex: 1];
//    [mainSplitView setCanCollapse: YES subviewAtIndex: 0];
}

- (void) openSidebar: (id) sender {
    sidebarIsOpen = YES;
    //    [mainSplitView setCanCollapse: NO subviewAtIndex: 0];
    [mainSplitView setMinSize: MIN_SIDEBAR_WIDTH ofSubview: sidebarView];
    [mainSplitView setMaxSize: MAX_SIDEBAR_WIDTH ofSubview: sidebarView];
    [mainSplitView setSize: 200.0 ofSubviewAtIndex: 0 animated: YES completition: ^(BOOL completion) {
    }];
}

- (void) closeSidebar: (id) sender {
    sidebarIsOpen = NO;
    [mainSplitView setMaxSize: MAX_SIDEBAR_WIDTH ofSubview: sidebarView];
    [mainSplitView setSize: MAX_SIDEBAR_WIDTH ofSubviewAtIndex: 0 animated: YES completition: ^(BOOL completion) {
    }];

    //    [mainSplitView collapseOrExpandSubview: sidebarView animated: YES];
}

- (IBAction) toggleSidebar: (id) sender {

    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (sidebarView.width == 0) {
        [mainSplitView setSize: currentSidebarWidth ofSubview: sidebarView animated: YES];
        //        [mainSplitView setMinSize: MIN_SIDEBAR_WIDTH ofSubview: sidebarView];
    } else {
        currentSidebarWidth = sidebarView.width;
        //        [mainSplitView setMinSize: 0 ofSubview: sidebarView];
        [mainSplitView setSize: 0 ofSubview: sidebarView animated: YES];
    }
}

- (IBAction) toggleBottomView: (id) sender {

    CGFloat newHeight = 50.0;
    if (bottomView.height == MIN_BOTTOM_VIEW_HEIGHT) {
        newHeight = MAX_BOTTOM_HEIGHT;
    } else {
        newHeight = MIN_BOTTOM_VIEW_HEIGHT;
    }

    [bottomSplitView setMaxSize: newHeight ofSubviewAtIndex: 1];
    [bottomSplitView setSize: newHeight ofSubviewAtIndex: 1 animated: YES completition: ^(BOOL completion) {
    }];
}

- (void) closeBottomView: (id) sender {
    [bottomSplitView setMaxSize: MIN_BOTTOM_VIEW_HEIGHT ofSubviewAtIndex: 1];
    [bottomSplitView setSize: MIN_BOTTOM_VIEW_HEIGHT ofSubviewAtIndex: 1 animated: YES completition: ^(BOOL completion) {
    }];
}

- (void) resetBottomView: (id) sender {
    [bottomSplitView setMaxSize: MIN_BOTTOM_VIEW_HEIGHT ofSubviewAtIndex: 1];
    [bottomSplitView setSize: MIN_BOTTOM_VIEW_HEIGHT ofSubviewAtIndex: 1 animated: NO completition: ^(BOOL completion) {
    }];
}

- (void) resetMainView: (id) sender {
    [mainSplitView setMinSize: MIN_MAIN_WIDTH ofSubviewAtIndex: 1];
    //    [mainSplitView setSize: MIN_BOTTOM_VIEW_HEIGHT ofSubviewAtIndex: 1 animated: NO completition: ^(BOOL completion) {
    //    }];

}

- (void) resetSidebarView: (id) sender {
    [mainSplitView setMinSize: MIN_SIDEBAR_WIDTH ofSubviewAtIndex: 0];
    [mainSplitView setMaxSize: MAX_SIDEBAR_WIDTH ofSubviewAtIndex: 0];

    [mainSplitView setSize: 200 ofSubviewAtIndex: 0 animated: NO completition: ^(BOOL completion) {
    }];
}

#pragma mark NSWindowDelegate



- (NSSize) windowWillResize: (NSWindow *) sender toSize: (NSSize) frameSize {
    NSSize result;
    return frameSize;
}

- (void) windowWillStartLiveResize: (NSNotification *) notification {
    if (!isToggling) {
        [mainSplitView constrainView: sidebarView];
    }
}

- (void) windowDidEndLiveResize: (NSNotification *) notification {
    isToggling = NO;
    [mainSplitView unconstrainView: sidebarView];
}

@end