//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableRowObject.h"
#import "TableSection.h"


@interface BasicTextField : NSTextField {
    __unsafe_unretained TableRowObject *rowObject;
    __unsafe_unretained TableSection *tableSection;
    NSShadow *shadow;
    NSString *text;
}


@property(nonatomic, assign) TableRowObject *rowObject;
@property(nonatomic, assign) TableSection *tableSection;
@property(nonatomic, strong) NSShadow *shadow;
@property(nonatomic, copy) NSString *text;
- (NSColor *) shadowColor;
- (NSSize) shadowOffset;
- (CGFloat) shadowBlurRadius;
- (void) setShadowColor: (NSColor *) color;
- (void) setShadowOffset: (NSSize) size1;
- (void) setShadowBlurRadius: (CGFloat) blurRadius;
- (void) setText: (NSString *) string;
- (NSString *) text;
@end