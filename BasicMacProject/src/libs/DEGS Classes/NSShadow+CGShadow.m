//
//  NSShadow+CGShadow.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 30/10/12.
//
//

#import "NSShadow+CGShadow.h"
#import "NSColor+CGColor.h"


#define IN_RUNNING_LION (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_6)
#define IN_COMPILING_LION __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070


@implementation NSShadow (CGShadow)


- (void) setInCGContext: (CGContextRef) context {
    [NSShadow setShadow: self inCGContext: context];
}

+ (void) setShadow: (NSShadow *) shadow inCGContext: (CGContextRef) context {
    CGContextSetShadowWithColor(context, CGSizeMake([shadow shadowOffset].width, [shadow shadowOffset].height), [shadow shadowBlurRadius], [[shadow shadowColor] CGColorCreate]);
}

@end
