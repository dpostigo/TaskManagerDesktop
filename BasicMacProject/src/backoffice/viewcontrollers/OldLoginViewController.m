//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OldLoginViewController.h"
#import "LoginOperation.h"
#import "SaveDataOperation.h"


@implementation OldLoginViewController {
}


- (void) loadView {
    backgroundView = [[UIView alloc] init];
    [super loadView];
}






#pragma mark UITableView


#pragma mark IBActions
- (IBAction) handleSubmitButton: (id) sender {
    [super handleSubmitButton: sender];

    [_queue addOperation: [[LoginOperation alloc] initWithUsername: username password: password]];
}



#pragma mark Callbacks


@end