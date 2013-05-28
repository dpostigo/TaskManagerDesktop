//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicBackOfficeOperation.h"


@interface LoginOperation : BasicBackOfficeOperation {

    NSString *username;
    NSString *password;
}


@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *password;
- (id) initWithUsername: (NSString *) username password: (NSString *) aPassword;

@end