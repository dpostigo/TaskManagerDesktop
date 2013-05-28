//
// Created by Daniela Postigo on 5/14/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BOSidebarLabel : NSTextField {
    NSColor *highlightedShadowColor;
    NSColor *unhighlightedShadowColor;
}


@property(nonatomic, strong) NSColor *highlightedShadowColor;
@property(nonatomic, strong) NSColor *unhighlightedShadowColor;
@end