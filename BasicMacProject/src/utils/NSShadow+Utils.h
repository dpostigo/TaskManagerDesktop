//
// Created by dpostigo on 2/21/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface NSShadow (Utils)


+ (void) setShadowWithOffset: (NSSize) offset blurRadius: (CGFloat) radius color: (NSColor *) shadowColor;
+ (void) clearShadow;

@end