//
// Created by Daniela Postigo on 5/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "INAppStoreWindow.h"
#import "VeryBasicViewController.h"


@interface BasicCustomWindow : INAppStoreWindow {

    NSWindow *modalWindow;
}


@property(nonatomic, strong) NSWindow *modalWindow;

- (void) presentModalView: (VeryBasicViewController *) controller withSize: (NSSize) size1;
- (void) presentModalView: (VeryBasicViewController *) controller withSize: (NSSize) size1 animated: (BOOL) animated;
- (void) animateView: (NSView *) view inWindow: (NSWindow *) window;
- (void) dismissCurrentModal;
- (void) dismissController: (NSViewController *) controller animated: (BOOL) animated;
- (void) addController: (NSViewController *) viewController toView: (NSView *) aView;
- (IBAction) iconSegmentClicked: (id) sender;
- (IBAction) listSegmentClicked: (id) sender;
- (IBAction) flowIconClicked: (id) sender;
@end