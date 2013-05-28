//
// Created by Daniela Postigo on 5/14/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BOPopoverBackgroundView : UIPopoverBackgroundView {
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
    UIImageView *_arrowImageView;
    UIImageView *_popoverBackgroundImageView;
}


@property(nonatomic, readwrite) CGFloat arrowOffset;
@property(nonatomic, readwrite) UIPopoverArrowDirection arrowDirection;
@property(nonatomic, readwrite, strong) UIImageView *arrowImageView;
@property(nonatomic, readwrite, strong) UIImageView *popoverBackgroundImageView;

+ (CGFloat) arrowHeight;
+ (CGFloat) arrowBase;
+ (UIEdgeInsets) contentViewInsets;

@end