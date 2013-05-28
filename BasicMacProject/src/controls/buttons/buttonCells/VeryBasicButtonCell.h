//
// Created by Daniela Postigo on 5/22/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface VeryBasicButtonCell : NSButtonCell {

    NSColor *imageColor;
    NSColor *imageShadowColor;

    CGFloat cornerRadius;
    NSColor *strokeColor;
    NSColor *innerStrokeColor;
    NSGradient *gradientColor;


    BOOL autoAdjustsCornerRadius;

    NSColor *disabledStrokeColor;
    NSColor *disabledInnerStrokeColor;
    NSGradient *disabledGradientColor;
}


@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic, strong) NSColor *strokeColor;
@property(nonatomic, strong) NSColor *innerStrokeColor;
@property(nonatomic, strong) NSColor *highlightedColor;
@property(nonatomic, strong) NSColor *imageColor;
@property(nonatomic, strong) NSColor *imageShadowColor;
@property(nonatomic) BOOL autoAdjustsCornerRadius;
@property(nonatomic, strong) NSGradient *gradientColor;
@property(nonatomic, strong) NSGradient *disabledGradientColor;
@property(nonatomic, strong) NSColor *disabledStrokeColor;
@property(nonatomic, strong) NSColor *disabledInnerStrokeColor;
- (void) setup;
- (void) drawOuter: (NSGraphicsContext *) context frame: (NSRect) frame;
- (void) drawStroke: (NSGraphicsContext *) context frame: (NSRect) frame;
- (void) drawInnerStroke: (NSGraphicsContext *) context frame: (NSRect) frame;
- (void) drawBackgroundFill: (NSGraphicsContext *) context frame: (NSRect) frame;
- (void) drawHighlight: (NSGraphicsContext *) context frame: (NSRect) frame;
@end
