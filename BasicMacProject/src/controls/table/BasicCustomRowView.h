//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "NSBezierPath+Additions.h"
#import "BasicTableRowView.h"


@interface BasicCustomRowView : BasicTableRowView {

    NSShadow *shadow;
    NSColor *borderColor;
    NSGradient *gradient;
    NSGradient *selectedGradient;

    CGFloat cornerRadius;
    CGFloat borderWidth;
    JSRoundedCornerOptions cornerOptions;


    CGFloat shadowOpacity;


    NSRect insetRect;
}


@property(nonatomic) JSRoundedCornerOptions cornerOptions;
@property(nonatomic) CGFloat cornerRadius;

@property(nonatomic, strong) NSColor *borderColor;
@property(nonatomic, strong) NSGradient *gradient;

@property(nonatomic) CGFloat shadowOpacity;
@property(nonatomic, strong) NSShadow *shadow;

@property(nonatomic) NSRect insetRect;
@property(nonatomic) CGFloat borderWidth;
@property(nonatomic, strong) NSGradient *selectedGradient;
- (NSRect) modifiedRect: (NSRect) rect;
- (void) drawBackgroundInRect: (NSRect) dirtyRect selected: (BOOL) selected;
@end