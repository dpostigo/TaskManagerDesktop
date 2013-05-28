//
// Created by dpostigo on 2/21/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSShadow+Utils.h"


@implementation NSShadow (Utils)



+ (void) setShadowWithOffset: (NSSize) offset blurRadius: (CGFloat) radius color: (NSColor *) shadowColor {
    NSShadow *aShadow = [[self alloc] init];
    [aShadow setShadowOffset: offset];
    [aShadow setShadowBlurRadius: radius];
    [aShadow setShadowColor: shadowColor];
    [aShadow set];
}


+ (void) clearShadow {
    NSShadow *aShadow = [[self alloc] init];
    [aShadow set];
}

@end