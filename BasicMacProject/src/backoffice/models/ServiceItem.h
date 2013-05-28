//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicObject.h"


@interface ServiceItem : BasicObject {
    CGFloat hourlyRate;
}


@property(nonatomic) CGFloat hourlyRate;
- (id) initWithDictionary: (NSDictionary *) dictionary;
@end