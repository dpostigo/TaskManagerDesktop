//
// Created by Daniela Postigo on 4/21/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SaveDataOperation.h"
#import "Archiver.h"


@implementation SaveDataOperation {
}


- (void) main {
    [super main];
    [[NSUserDefaults standardUserDefaults] setBool: _model.loggedIn forKey: @"loggedIn"];
    [Archiver persist: _model.currentUser key: @"currentUser"];
    [Archiver persist: _model.tasks key: @"tasks"];
    [Archiver persist: _model.jobs key: @"jobs"];
    [Archiver persist: _model.contacts key: @"contacts"];
    [Archiver persist: _model.serviceItems key: @"serviceItems"];
    [self testDearchive];
}

@end