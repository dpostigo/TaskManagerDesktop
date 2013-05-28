//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicOperation.h"


@interface BasicBackOfficeOperation : BasicOperation {

    NSString *urlString;
    NSURL *url;
}


@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSString *urlString;

- (id) initWithURL: (NSString *) URL;
- (NSString *) sha1: (NSString *) input;


@end