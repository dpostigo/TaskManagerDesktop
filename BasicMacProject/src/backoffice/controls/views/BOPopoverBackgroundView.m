//
// Created by Daniela Postigo on 5/14/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOPopoverBackgroundView.h"


// Predefined arrow image width and height
#define ARROW_WIDTH 35.0
#define ARROW_HEIGHT 5.0

// Predefined content insets
#define TOP_CONTENT_INSET 8
#define LEFT_CONTENT_INSET 8
#define BOTTOM_CONTENT_INSET 8
#define RIGHT_CONTENT_INSET 8

#pragma mark - Private interface

@interface BOPopoverBackgroundView () {
    UIImage *_topArrowImage;
    UIImage *_leftArrowImage;
    UIImage *_rightArrowImage;
    UIImage *_bottomArrowImage;
}

@end

#pragma mark - Implementation

@implementation BOPopoverBackgroundView


@synthesize arrowOffset = _arrowOffset, arrowDirection = _arrowDirection, popoverBackgroundImageView = _popoverBackgroundImageView, arrowImageView = _arrowImageView;

#pragma mark - Overriden class methods

+ (CGFloat) arrowBase {
    return ARROW_WIDTH;
}

+ (CGFloat) arrowHeight {
    return ARROW_HEIGHT;
}

+ (UIEdgeInsets) contentViewInsets {
    return UIEdgeInsetsMake(TOP_CONTENT_INSET, LEFT_CONTENT_INSET, BOTTOM_CONTENT_INSET, RIGHT_CONTENT_INSET);
}

#pragma mark - Custom setters for updating layout

- (void) setArrowOffset: (CGFloat) arrowOffset {
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

- (void) setArrowDirection: (UIPopoverArrowDirection) arrowDirection {
    _arrowDirection = arrowDirection;
    [self setNeedsLayout];
}

#pragma mark - Initialization

- (id) initWithFrame: (CGRect) frame {
    if (self = [super initWithFrame: frame]) {
        _topArrowImage = [UIImage imageNamed: @"popover-black-top-arrow-image.png"];
        _leftArrowImage = [UIImage imageNamed: @"popover-black-left-arrow-image.png"];
        _bottomArrowImage = [UIImage imageNamed: @"popover-black-bottom-arrow-image.png"];
        _rightArrowImage = [UIImage imageNamed: @"popover-black-right-arrow-image.png"];

        UIImage *popoverBackgroundImage = [[UIImage imageNamed: @"popover-black-bcg-image.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(49, 46, 49, 45)];
        self.popoverBackgroundImageView = [[UIImageView alloc] initWithImage: popoverBackgroundImage];
        [self addSubview: self.popoverBackgroundImageView];

        self.arrowImageView = [[UIImageView alloc] init];
        [self addSubview: self.arrowImageView];
    }

    return self;
}

#pragma mark - Layout subviews

- (void) layoutSubviews {
    //    [super layoutSubviews];

    CGFloat popoverImageOriginX = 0;
    CGFloat popoverImageOriginY = 0;

    CGFloat popoverImageWidth = self.bounds.size.width;
    CGFloat popoverImageHeight = self.bounds.size.height;

    CGFloat arrowImageOriginX = 0;
    CGFloat arrowImageOriginY = 0;

    CGFloat arrowImageWidth = ARROW_WIDTH;
    CGFloat arrowImageHeight = ARROW_HEIGHT;

    // Radius value you used to make rounded corners in your popover background image
    CGFloat cornerRadius = 9;

    switch (self.arrowDirection) {

        case UIPopoverArrowDirectionUp:

            popoverImageOriginY = ARROW_HEIGHT - 2;
            popoverImageHeight = self.bounds.size.height - ARROW_HEIGHT;

            // Calculating arrow x position using arrow offset, arrow width and popover width
            arrowImageOriginX = roundf((self.bounds.size.width - ARROW_WIDTH) / 2 + self.arrowOffset);

            // If arrow image exceeds rounded corner arrow image x postion is adjusted
            if (arrowImageOriginX + ARROW_WIDTH > self.bounds.size.width - cornerRadius) {
                arrowImageOriginX -= cornerRadius;
            }

            if (arrowImageOriginX < cornerRadius) {
                arrowImageOriginX += cornerRadius;
            }

            // Setting arrow image for current arrow direction
            self.arrowImageView.image = _topArrowImage;

            break;

        case UIPopoverArrowDirectionDown:

            popoverImageHeight = self.bounds.size.height - ARROW_HEIGHT + 2;

            arrowImageOriginX = roundf((self.bounds.size.width - ARROW_WIDTH) / 2 + self.arrowOffset);

            if (arrowImageOriginX + ARROW_WIDTH > self.bounds.size.width - cornerRadius) {
                arrowImageOriginX -= cornerRadius;
            }

            if (arrowImageOriginX < cornerRadius) {
                arrowImageOriginX += cornerRadius;
            }

            arrowImageOriginY = popoverImageHeight - 2;

            self.arrowImageView.image = _bottomArrowImage;

            break;

        case UIPopoverArrowDirectionLeft:

            popoverImageOriginX = ARROW_HEIGHT - 2;
            popoverImageWidth = self.bounds.size.width - ARROW_HEIGHT;

            arrowImageOriginY = roundf((self.bounds.size.height - ARROW_WIDTH) / 2 + self.arrowOffset);

            if (arrowImageOriginY + ARROW_WIDTH > self.bounds.size.height - cornerRadius) {
                arrowImageOriginY -= cornerRadius;
            }

            if (arrowImageOriginY < cornerRadius) {
                arrowImageOriginY += cornerRadius;
            }

            arrowImageWidth = ARROW_HEIGHT;
            arrowImageHeight = ARROW_WIDTH;

            self.arrowImageView.image = _leftArrowImage;

            break;

        case UIPopoverArrowDirectionRight:

            popoverImageWidth = self.bounds.size.width - ARROW_HEIGHT + 2;

            arrowImageOriginX = popoverImageWidth - 2;
            arrowImageOriginY = roundf((self.bounds.size.height - ARROW_WIDTH) / 2 + self.arrowOffset);

            if (arrowImageOriginY + ARROW_WIDTH > self.bounds.size.height - cornerRadius) {
                arrowImageOriginY -= cornerRadius;
            }

            if (arrowImageOriginY < cornerRadius) {
                arrowImageOriginY += cornerRadius;
            }

            arrowImageWidth = ARROW_HEIGHT;
            arrowImageHeight = ARROW_WIDTH;

            self.arrowImageView.image = _rightArrowImage;

            break;

        default:
            // For popovers without arrows (Thanks Martin!)
            popoverImageHeight = self.bounds.size.height - ARROW_HEIGHT + 2;
            break;
    }

    self.popoverBackgroundImageView.frame = CGRectMake(popoverImageOriginX, popoverImageOriginY, popoverImageWidth, popoverImageHeight);
    self.arrowImageView.frame = CGRectMake(arrowImageOriginX, arrowImageOriginY, arrowImageWidth, arrowImageHeight);
}

@end