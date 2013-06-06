//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BottomViewController.h"
#import "SaveDataOperation.h"


@implementation BottomViewController {
}


- (IBAction) handleSettingsButton: (id) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _model.tasks = nil;
    _model.jobs = nil;
    _model.loggedIn = NO;


    [_queue addOperation: [[SaveDataOperation alloc] init]];
    [_model notifyDelegates: @selector(shouldSignOut) object: nil];
}

@end