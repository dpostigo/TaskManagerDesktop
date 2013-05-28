//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Model.h"


@interface BasicAppDelegate : NSObject <NSApplicationDelegate> {
    Model *_model;
}

@property(nonatomic, strong) Model *model;
- (void) applicationDelegateDidFinishLaunching: (NSNotification *) notification;
- (void) embedViewController: (NSViewController *) viewController inView: (NSView *) aSuperview;
@end