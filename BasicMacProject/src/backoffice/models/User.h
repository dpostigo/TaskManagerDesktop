//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicObject.h"
#import "BasicUserObject.h"


#define USERTYPE_MANAGER @"Manager"
#define USERTYPE_PRODUCER @"Producer"
#define USERTYPE_ACCOUNTANT @"Accountant"
#define USERTYPE_ARTIST @"Artist"
#define USERTYPE_FERELANCER @"Freelancer"
#define USERTYPE_CLIENT @"Client"


@interface User : BasicUserObject {
    NSString *userType;
}


@property(nonatomic, retain) NSString *userType;
- (id) initWithDictionary: (NSDictionary *) dictionary;
@end