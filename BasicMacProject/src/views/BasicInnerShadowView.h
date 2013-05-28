//
// Created by dpostigo on 2/20/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BasicInnerShadowView : NSView {

    CGFloat cornerRadius;
    CGFloat shadowRadius;
    NSColor *fillColor;
    NSColor *borderColor;
    NSColor *shadowColor;
}


@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic, strong) NSColor *fillColor;
@property(nonatomic, strong) NSColor *borderColor;
@property(nonatomic, strong) NSColor *shadowColor;
@property(nonatomic) CGFloat shadowRadius;

@end