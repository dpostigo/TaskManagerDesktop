//
// Created by Daniela Postigo on 5/13/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOSilverButton.h"
#import "BOSilverButtonCell.h"


@implementation BOSilverButton {
}



- (void) setup {
    [super setup];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

+ (Class) cellClass {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [BOSilverButtonCell class];
}

@end