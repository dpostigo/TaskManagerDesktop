//
//  NSColor+CGColor.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 10/04/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "NSColor+CGColor.h"


@implementation NSColor (CGColor)


- (CGColorRef) CGColorCreate {
    NSColor *rgbColor = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
    CGFloat components[4];
    [rgbColor getComponents: components];

    CGColorSpaceRef theColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGColorRef theColor = CGColorCreate(theColorSpace, components);
    CGColorSpaceRelease(theColorSpace);
    return theColor;
}

@end
