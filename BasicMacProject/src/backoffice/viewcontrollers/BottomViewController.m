//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "BottomViewController.h"
#import "SaveDataOperation.h"
#import "YRKSpinningProgressIndicator.h"
#import "NSView+Animation.h"


@implementation BottomViewController {
}


- (void) loadView {
    [super loadView];

    indicatorColor = [NSColor whiteColor];
    indicator.color = indicatorColor;
    statusLabel.textColor = [NSColor whiteColor];
    [self progressStatusEnded: NO];


}


- (void) progressStatusBegan: (NSString *) string {
    statusLabel.stringValue = string;
    [indicator startAnimation: self];

    [statusIndicatorContainer setHidden: NO];


    [statusIndicatorContainer animateInDirection: NSViewAnimationDirectionToTop amount: statusIndicatorContainer.height duration: 0.3 completionHandler: ^{
    }];
}


- (void) progressStatusEndedWithString: (NSString *) string {
    statusLabel.stringValue = string;
    [indicator stopAnimation: self];

    [self performSelector: @selector(progressStatusEnded) withObject: nil afterDelay: 1.0];

}


- (void) progressStatusEnded {
    [self progressStatusEnded: YES];
}


- (void) progressStatusEnded: (BOOL) animated {
    if (animated) {
        [statusIndicatorContainer animateInDirection: NSViewAnimationDirectionToBottom amount: statusIndicatorContainer.height duration: 0.5 completionHandler: ^{
            [statusIndicatorContainer setHidden: YES];
        }];
    }
    else {
        [statusIndicatorContainer setHidden: YES];
        statusIndicatorContainer.top = -statusIndicatorContainer.height;
    }
}

- (IBAction) handleSettingsButton: (id) sender {
    _model.tasks = nil;
    _model.jobs = nil;
    _model.loggedIn = NO;
    [_queue addOperation: [[SaveDataOperation alloc] init]];
    [_model notifyDelegates: @selector(shouldSignOut) object: nil];
}

@end