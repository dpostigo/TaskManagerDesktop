//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicAppDelegate.h"


@implementation BasicAppDelegate {
}


- (void) applicationDidFinishLaunching: (NSNotification *) notification {
    [self applicationDelegateDidFinishLaunching: notification];
}

- (void) applicationDelegateDidFinishLaunching: (NSNotification *) notification {
    _model = [Model sharedModel];
}


- (void) embedViewController: (NSViewController *) viewController inView: (NSView *) aSuperview {
    viewController.view.frame = aSuperview.bounds;
    viewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [aSuperview addSubview: viewController.view];
}

@end