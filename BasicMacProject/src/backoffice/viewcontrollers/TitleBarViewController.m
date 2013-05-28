//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TitleBarViewController.h"


@implementation TitleBarViewController {
}


- (IBAction) handleAddButton: (id) sender {
    [_model notifyDelegates: @selector(shouldAddTask) object: nil];
}

@end