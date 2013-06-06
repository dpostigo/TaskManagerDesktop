//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TaskDetailViewController.h"
#import "TaskDiscussionViewController.h"


#define TASK_INFO_HEIGHT 250

@implementation TaskDetailViewController {

    TaskDiscussionViewController *discussionController;
    TaskInfoViewController *infoController;
    BOOL isAnimating;
    BasicWhiteView *bgShadow;
    BOOL hasToggled;
    CGFloat animationDuration;
}


@synthesize isOpen;

- (id) initWithDefaultNib {
    self = [super initWithDefaultNib];
    if (self) {
        self.showsNavigationBar = YES;
        animationDuration = 0.35;
    }

    return self;
}

- (void) loadView {
    [super loadView];

    isOpen = YES;

    self.navigationBar.titleLabel.stringValue = _model.currentTaskMode;
    self.backgroundView.backgroundColor = [NSColor lightGrayColor];

    self.navigationBar.backButtonItem.target = self;
    self.navigationBar.backButtonItem.action = @selector(handleBackButton:);


    infoController = [[TaskInfoViewController alloc] initWithDefaultNib];
    infoController.detailController = self;

    discussionController = [[TaskDiscussionViewController alloc] initWithDefaultNib];
    discussionController.detailController = self;

    [self embedViewController: infoController inView: infoContainer];
    [self embedViewController: discussionController inView: discussionContainer];


    infoContainer.maximumHeight = TASK_INFO_HEIGHT;
    infoContainer.minimumHeight = TASK_INFO_HEIGHT;
    infoContainer.height = TASK_INFO_HEIGHT;
    infoContainer.isLocked = YES;


    splitView.delegate = self;
    self.dividerEnabled = YES;

    //    [contentSplitView setHoldingPriority: 2 forSubviewAtIndex: 0];
    //    [contentSplitView setHoldingPriority: 1 forSubviewAtIndex: 1];

    //
    //    infoContainer.height = TASK_INFO_HEIGHT;
    //
    //
    //    bgShadow = [[BasicWhiteView alloc] initWithFrame: NSMakeRect(0, 0, infoController.table.enclosingScrollView.width + 1, infoController.table.enclosingScrollView.height)];
    //    bgShadow.cornerRadius = 5.0;
    //    bgShadow.shadow.shadowColor = [NSColor colorWithDeviceWhite: 0.0 alpha: 0.5];
    //    bgShadow.left = (self.view.width - bgShadow.width) / 2;
    //    bgShadow.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
    //    [self.view addSubview: bgShadow];
    //    [self.view addSubview: splitView];
    //

    NSLog(@"%s", __PRETTY_FUNCTION__);
    //
    //    NSRect infoRect = NSMakeRect(0, TASK_INFO_HEIGHT, 599, TASK_INFO_HEIGHT);
    //    NSRect shadowRect = [self getShadowRect: infoRect];
    //    //    bgShadow.frame = shadowRect;
    //    shadowRect = bgShadow.frame;
    //
    //    shadowRect = NSMakeRect(12, 305, shadowRect.size.width, TASK_INFO_HEIGHT);
    //    bgShadow.frame = shadowRect;

    NSLog(@"navigationBar.width = %f", navigationBar.width);
    NSLog(@"navigationBar.frame = %@", NSStringFromRect(navigationBar.frame));

    NSLog(@"self.view.width = %f", self.view.width);

}






#pragma mark Task Details Animation

- (void) toggleTaskDetails: (id) sender {
    hasToggled = YES;
    if (isOpen) [self closeTaskDetails: sender];
    else [self openTaskDetails: sender];
}


- (void) taskDetailsDidOpen {
    isOpen = YES;
    isAnimating = NO;
    [_model notifyDelegates: @selector(taskInfoControllerDidOpen:) object: nil];
}


- (void) openTaskDetails: (id) sender {
    if (isAnimating) return;
    if (isOpen) return;


    isAnimating = YES;

    CGRect rect = discussionContainer.frame;
    rect.origin.y = infoContainer.top + infoController.firstHeight + 10;
    rect.size.height = self.view.height - rect.origin.y;


    NSRect infoRect = infoContainer.frame;
    infoRect.size.height = TASK_INFO_HEIGHT;
    infoRect.origin.y = infoRect.size.height;

    //    infoRect.origin.y -= 5;
    NSRect shadowRect = [self getShadowRect: infoRect];


    [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
        context.duration = animationDuration;
        //        context.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        context.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        [infoContainer.animator setFrame: infoRect];
        [bgShadow.animator setFrame: shadowRect];
    }                   completionHandler: ^{
        [self taskDetailsDidOpen];
    }];
}

- (void) closeTaskDetails: (id) sender {
    [self closeTaskDetails: sender animated: YES];
}


- (void) closeTaskDetails: (id) sender animated: (BOOL) isAnimated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (isAnimating) return;
    if (!isOpen) return;
    isAnimating = YES;


    NSRect infoRect = infoContainer.frame;
    infoRect.size.height = infoController.table.rowHeight;
    infoRect.origin.y = infoRect.size.height;


    NSRect shadowRect = [self getShadowRect: infoRect];

    [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
        context.duration = animationDuration;
        context.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        [infoContainer.animator setFrame: infoRect];
        [bgShadow.animator setFrame: shadowRect];
    }                   completionHandler: ^{
        [self taskDetailsDidClose];
    }];


}

- (NSRect) getShadowRect: (NSRect) infoRect {
    CGFloat offsetY = 4;

    NSPoint point = [infoContainer.superview convertPoint: infoRect.origin toView: self.view];
    NSRect shadowRect = bgShadow.frame;
    shadowRect.size.height = infoRect.size.height + offsetY;
    shadowRect.origin.y = point.y - offsetY;

    return shadowRect;


}

- (void) taskDetailsDidClose {
    isOpen = NO;
    isAnimating = NO;
    [_model notifyDelegates: @selector(taskInfoControllerDidClose:) object: nil];
}


//
//- (void) handleToggle: (id) sender {
//    if (infoController.isAnimating) return;
//    if ([sender isKindOfClass: [TaskDiscussionViewController class]]) {
//        if (!infoController.isOpen) {
//            return;
//        }
//    }
//
//    TaskInfoViewController *controller = infoController;
//    if (controller.isAnimating) return;
//    controller.isAnimating = YES;
//
//    if (controller.isOpen) {
//        CGRect rect = discussionContainer.frame;
//        rect.origin.y = infoContainer.top + infoController.table.rowHeight + 10;
//        rect.size.height = self.view.height - rect.origin.y;
//
//        [UIView beginAnimations: @"closeAnimation" context: nil];
//        [UIView setAnimationDuration: 0.5];
//        [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
//        infoController.view.height = infoController.table.rowHeight;
//        discussionContainer.frame = rect;
//
//        [UIView commitAnimations];
//
//        [UIView animateWithDuration: 0.5 animations: ^{
//        }                completion: ^(BOOL completion) {
//            controller.isOpen = NO;
//            controller.isAnimating = NO;
//            [_model notifyDelegates: @selector(taskInfoControllerDidClose:) object: nil];
//        }];
//    } else {
//        CGRect rect = discussionContainer.frame;
//        rect.origin.y = infoContainer.top + infoController.firstHeight + 10;
//        rect.size.height = self.view.height - rect.origin.y;
//
//        [UIView beginAnimations: @"openAnimation" context: nil];
//        [UIView setAnimationDuration: 0.5];
//        [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
//        infoController.view.height = infoController.firstHeight;
//        discussionContainer.frame = rect;
//        [UIView commitAnimations];
//
//        [UIView animateWithDuration: 0.5 animations: ^{
//        }                completion: ^(BOOL completion) {
//            controller.isOpen = YES;
//            controller.isAnimating = NO;
//            [_model notifyDelegates: @selector(taskInfoControllerDidOpen:) object: nil];
//        }];
//    }
//}

#pragma mark UITableView


#pragma mark IBActions

- (IBAction) handleBackButton: (id) sender {
    [self.navigationController popViewController];
}


#pragma mark Callbacks


- (void) taskDidUpdate: (Task *) task {
    self.title = _model.selectedTask.title;
}
//
//- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
//    [super prepareForSegue: segue sender: sender];
//
//    if ([segue.identifier isEqualToString: @"TaskInfoEmbed"]) {
//        infoController = segue.destinationViewController;
//        infoController.detailController = self;
//        NSLog(@"infoController = %@", infoController);
//    } else if ([segue.identifier isEqualToString: @"TaskDiscussionEmbed"]) {
//        discussionController = segue.destinationViewController;
//        discussionController.detailController = self;
//    }
//}






// /
//- (CGFloat) splitView: (NSSplitView *) splitView1 constrainSplitPosition: (CGFloat) proposedPosition ofSubviewAt: (NSInteger) dividerIndex {
//    if (dividerIndex == 0) {
//
//        return 400;
//    }
//    return 0;
//}



- (void) fixBgShadow {
    if (!hasToggled) {
        //NSLog(@"Setting.");
        NSRect rect = [self.view convertRect: infoContainer.frame fromView: splitView];
        NSRect shadowRect = bgShadow.frame;
        shadowRect.size.height = rect.size.height;
        shadowRect.origin.y = rect.origin.y + 4;
        bgShadow.frame = shadowRect;
    }

}



#pragma mark BasicSplitViewController



#pragma mark NSSplitViewDelegate
//
//
//- (BOOL) splitView: (NSSplitView *) splitView1 canCollapseSubview: (NSView *) subview {
//    return NO;
//}
//
//- (CGFloat) splitView: (NSSplitView *) splitView1 constrainMinCoordinate: (CGFloat) proposedMinimumPosition ofSubviewAt: (NSInteger) dividerIndex {
//
//    [self fixBgShadow];
//    return [super splitView: splitView1 constrainMinCoordinate: proposedMinimumPosition ofSubviewAt: dividerIndex];
//}
//

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