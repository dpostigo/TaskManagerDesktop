//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "NSBezierPath+Additions.h"
#import "BasicTableRowView.h"


@interface BasicCustomRowView : BasicTableRowView {

    CGFloat cornerRadius;
    NSColor *borderColor;
    CGFloat borderWidth;
    NSGradient *gradientColor;
    NSColor *backgroundFillColor;
    JSRoundedCornerOptions cornerOptions;

    NSShadow *shadow;

    CGFloat shadowOpacity;
    CGFloat noiseOpacity;
    CGFloat selectedNoiseOpacity;


    NSRect insetRect;
}


@property(nonatomic) JSRoundedCornerOptions cornerOptions;
@property(nonatomic) CGFloat cornerRadius;

@property(nonatomic, strong) NSColor *borderColor;
@property(nonatomic, strong) NSGradient *gradientColor;
@property(nonatomic, strong) NSColor *backgroundFillColor;

@property(nonatomic) CGFloat shadowOpacity;
@property(nonatomic, strong) NSShadow *shadow;

@property(nonatomic) CGFloat noiseOpacity;
@property(nonatomic) CGFloat selectedNoiseOpacity;

@property(nonatomic) NSRect insetRect;
@property(nonatomic) CGFloat borderWidth;
- (NSRect) modifiedRect: (NSRect) rect;
- (void) drawBackgroundInRect: (NSRect) dirtyRect selected: (BOOL) selected;
@end