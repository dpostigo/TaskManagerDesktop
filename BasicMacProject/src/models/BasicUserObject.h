//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicObject.h"


@interface BasicUserObject : BasicObject {
    NSString *firstName;
    NSString *lastName;
    NSString *username;
    NSString *displayName;
    NSString *thumbnailURL;
}


@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;
@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *displayName;
@property(nonatomic, retain) NSString *thumbnailURL;
@end