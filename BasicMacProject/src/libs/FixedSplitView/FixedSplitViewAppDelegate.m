//
//  OldAppDelegate.m
//  ColumnSplitView
//
//  Created by Matt Gallagher on 2009/09/01.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import "OldAppDelegate.h"
#import "PrioritySplitViewDelegate.h"


#define LEFT_VIEW_INDEX 0
#define LEFT_VIEW_PRIORITY 2
#define LEFT_VIEW_MINIMUM_WIDTH 10.0
#define MAIN_VIEW_INDEX 1
#define MAIN_VIEW_PRIORITY 0
#define MAIN_VIEW_MINIMUM_WIDTH 20.0
#define RIGHT_VIEW_INDEX 2
#define RIGHT_VIEW_PRIORITY 1
#define RIGHT_VIEW_MINIMUM_WIDTH 5.0


@implementation FixedSplitViewAppDelegate


- (void) applicationDidFinishLaunching: (NSNotification *) aNotification {
    splitViewDelegate =  [[PrioritySplitViewDelegate alloc] init];

    [splitViewDelegate setPriority: LEFT_VIEW_PRIORITY forViewAtIndex: LEFT_VIEW_INDEX];
    [splitViewDelegate setMinimumLength: LEFT_VIEW_MINIMUM_WIDTH forViewAtIndex: LEFT_VIEW_INDEX];
    [splitViewDelegate setPriority: MAIN_VIEW_PRIORITY forViewAtIndex: MAIN_VIEW_INDEX];
    [splitViewDelegate setMinimumLength: MAIN_VIEW_MINIMUM_WIDTH forViewAtIndex: MAIN_VIEW_INDEX];
    [splitViewDelegate setPriority: RIGHT_VIEW_PRIORITY forViewAtIndex: RIGHT_VIEW_INDEX];
    [splitViewDelegate setMinimumLength: RIGHT_VIEW_MINIMUM_WIDTH forViewAtIndex: RIGHT_VIEW_INDEX];

    [splitView setDelegate: splitViewDelegate];

    [[[splitView subviews] objectAtIndex: LEFT_VIEW_INDEX] setBackgroundColor: [NSColor redColor]];
    [[[splitView subviews] objectAtIndex: MAIN_VIEW_INDEX] setBackgroundColor: [NSColor darkGrayColor]];
    [[[splitView subviews] objectAtIndex: RIGHT_VIEW_INDEX] setBackgroundColor: [NSColor blueColor]];

    [mainWindow makeKeyAndOrderFront: self];
}


//
// applicationWillTerminate
//
// Clears the delegate.
//
- (void) applicationWillTerminate: (NSNotification *) aNotification {
    [splitView setDelegate: nil];
}

@end
