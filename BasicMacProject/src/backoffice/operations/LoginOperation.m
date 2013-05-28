//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LoginOperation.h"
#import "ASIFormDataRequest.h"
#import "ASIDataDecompressor.h"
#import <YAJL/YAJL.h>


@implementation LoginOperation {
}


@synthesize username;

@synthesize password;


// Encode a string to embed in an URL.
NSString *encodeToPercentEscapeString(NSString *string) {
    return (NSString *)
            CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                    (__bridge CFStringRef) string,
                    NULL,
                    (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                    kCFStringEncodingUTF8));
}

// Decode a percent escape encoded string.
NSString *decodeFromPercentEscapeString(NSString *string) {
    return (NSString *)
            CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                    (__bridge CFStringRef) string,
                    CFSTR(""),
                    kCFStringEncodingUTF8));
}



- (id) initWithUsername: (NSString *) aUser password: (NSString *) aPassword {
    self = [super init];
    if (self) {
        self.username = aUser;
        self.password = aPassword;
    }

    return self;
}

- (void) main {
    [super main];
    NSLog(@"%s", __PRETTY_FUNCTION__);

    //    if (DEBUG) {
//        username = @"caitlin@elasticcreative.com";
//        password = @"caitlin";
//    }

    username = encodeToPercentEscapeString(username);
    self.urlString = [NSString stringWithFormat: @"%@/access/attempt_login.json?primary_email=%@&hashed_password=%@", STAGING_URL, username, [self sha1: password]];
    self.url = [NSURL URLWithString: urlString];

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL: url];
    request.requestMethod = @"GET";
    [request addRequestHeader: @"Content-Type" value: @ "application/json"];
    [request startSynchronous];

    if (!request.error) {

        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData: request.responseData options: kNilOptions error: &error];

        if (dictionary == nil) {
            NSLog(@"%@ failed.", NSStringFromClass([self class]));
            _model.currentUser = nil;
            _model.loggedIn = NO;
            [_model notifyDelegates: @selector(loginFailedWithMessage:) object: @"Login failed."];
        } else {
            NSLog(@"%@ succeeded.", NSStringFromClass([self class]));
            _model.currentUser = [[User alloc] initWithDictionary: dictionary];
            _model.loggedIn = YES;
            [_model notifyDelegates: @selector(loginSucceeded:) object: nil];
        }
    }
}

@end