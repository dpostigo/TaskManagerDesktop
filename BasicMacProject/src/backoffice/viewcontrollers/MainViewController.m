//
//  MainViewController.m
//  TaskManager
//
//  Created by Daniela Postigo on 5/26/13.
//  Copyright 2013 Dani Postigo. All rights reserved.
//

#import "MainViewController.h"
#import "SidebarViewController.h"
#import "TasksViewController.h"
#import "BottomViewController.h"
#import "BONavigationBar.h"


@implementation MainViewController {

}


- (void) loadView {
    [super loadView];

    NSLog(@"%s", __PRETTY_FUNCTION__);


}

- (void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"%s", __PRETTY_FUNCTION__);


    NavigationController *navController = [[NavigationController alloc] initWithRootViewController: [[TasksViewController alloc] initWithDefaultNib]];
    navController.navigationBar = [[BONavigationBar alloc] initWithFrame: NSZeroRect];


    [self embedViewController: [[SidebarViewController alloc] initWithDefaultNib] inView: sidebar];
    [self embedViewController: [[BottomViewController alloc] initWithDefaultNib] inView: bottomView];
    [self embedViewController: navController inView: mainView];


    navController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;


    sidebar.minimumWidth = 150.0;
    sidebar.maximumWidth = 250.0;
    sidebar.isLocked = YES;

    bottomView.minimumHeight = 40.0f;
    bottomView.maximumHeight = 60.0f;
    bottomView.height = 40.0f;
    bottomView.isLocked = YES;


    splitView.delegate = self;
    contentSplitView.delegate = self;
    self.dividerEnabled = YES;

    [contentSplitView setHoldingPriority: 2 forSubviewAtIndex: 0];
    [contentSplitView setHoldingPriority: 1 forSubviewAtIndex: 1];


}


#pragma mark NSSplitViewDelegate


- (CGFloat) splitView: (NSSplitView *) splitView1 constrainMinCoordinate: (CGFloat) proposedMinimumPosition ofSubviewAt: (NSInteger) dividerIndex {
    CGFloat ret = proposedMinimumPosition;
    DPSplitView *dpSplit = (DPSplitView *) splitView1;
    return [self dpSplitView: dpSplit limitedCoordinateForValue: proposedMinimumPosition atDividerIndex: dividerIndex];
}


- (CGFloat) splitView: (NSSplitView *) splitView1 constrainMaxCoordinate: (CGFloat) proposedMaximumPosition ofSubviewAt: (NSInteger) dividerIndex {
    CGFloat ret = proposedMaximumPosition;
    DPSplitView *dpSplit = (DPSplitView *) splitView1;
    return [self dpSplitView: dpSplit limitedCoordinateForValue: proposedMaximumPosition atDividerIndex: dividerIndex];
}


- (CGFloat) splitView: (NSSplitView *) splitView1 constrainSplitPosition: (CGFloat) proposedPosition ofSubviewAt: (NSInteger) dividerIndex {
    DPSplitView *dpSplit = (DPSplitView *) splitView1;
    return [self dpSplitView: dpSplit limitedCoordinateForValue: proposedPosition atDividerIndex: dividerIndex];
}

- (BOOL) splitView: (NSSplitView *) splitView1 shouldAdjustSizeOfSubview: (NSView *) view1 {
    if ([view1 isKindOfClass: [SplitViewContainer class]]) {
        SplitViewContainer *splitContainer = (SplitViewContainer *) view1;
        return !splitContainer.isLocked;
    }
    return YES;
}


@end