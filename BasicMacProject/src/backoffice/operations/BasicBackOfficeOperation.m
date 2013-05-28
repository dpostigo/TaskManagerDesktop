//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CommonCrypto/CommonDigest.h>
#import "BasicBackOfficeOperation.h"


@implementation BasicBackOfficeOperation {
}


@synthesize url;

@synthesize urlString;

- (id) initWithURL: (NSString *) aURL {
    self = [super init];
    if (self) {
        url = [NSURL URLWithString: aURL];
    }

    return self;
}

- (void) main {
    [super main];
}

- (NSString *) sha1: (NSString *) input {
    const char *cstr = [input cStringUsingEncoding: NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes: cstr length: input.length];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity: CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat: @"%02x", digest[i]];

    return output;
}

@end