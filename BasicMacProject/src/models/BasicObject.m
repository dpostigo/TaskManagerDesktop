//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicObject.h"
#import "NSObject+NSCoding.h"


@implementation BasicObject {
}


@synthesize id;
@synthesize title;

- (id) initWithCoder: (NSCoder *) coder {
    self = [super init];
    if (self) {
        [self autoDecode: coder];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *) coder {
    [self autoEncodeWithCoder: coder];
}

@end