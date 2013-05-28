//
//  JSButtonDecoration.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/11/12.
//
//

#import "JSButtonDecoration.h"

@implementation JSButtonDecoration

- (id)init
{
    self = [super init];
    if (self) {
        self.color = [NSColor whiteColor];
    }
    return self;
}

- (id)initWithColor:(NSColor *)color
{
    self = [super init];
    if (self) {
        self.color = color;
    }
    return self;
}

- (id)initWithGradient:(NSGradient *)gradient
{
    self = [super init];
    if (self) {
        self.gradient = gradient;
    }
    return self;
}

- (BOOL)isGradient
{
    if (_gradient) return YES; else return NO;
}

+ (JSButtonDecoration *)recessedDecoration
{
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.45 alpha:1.0] endingColor:[NSColor colorWithDeviceWhite:0.3 alpha:1.0]];
    JSButtonDecoration *decoration = [[self alloc] initWithGradient:gradient];
    NSShadow *dropShadow = [[NSShadow alloc] init];
    dropShadow.shadowColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.95];
    dropShadow.shadowOffset = NSMakeSize(0.0, -1.0);
    NSShadow *innerShadow = [[NSShadow alloc] init];
    innerShadow.shadowColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.7];
    innerShadow.shadowOffset = NSMakeSize(0.0, -1.0);
    innerShadow.shadowBlurRadius = 2.0;
    decoration.dropShadow = dropShadow;
    decoration.innerShadow = innerShadow;
    return decoration;
}

+ (JSButtonDecoration *)mouseOverDecoration
{
    NSColor *startColor = [NSColor colorWithDeviceRed:0.6 green:0.0 blue:0.0 alpha:1.0];
    NSColor *endColor = [NSColor colorWithDeviceRed:0.45 green:0.0 blue:0.0 alpha:1.0];
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
    JSButtonDecoration *decoration = [[self alloc] initWithGradient:gradient];
    NSShadow *dropShadow = [[NSShadow alloc] init];
    dropShadow.shadowColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.95];
    dropShadow.shadowOffset = NSMakeSize(0.0, -1.0);
    NSShadow *innerShadow = [[NSShadow alloc] init];
    innerShadow.shadowColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.7];
    innerShadow.shadowOffset = NSMakeSize(0.0, -1.0);
    innerShadow.shadowBlurRadius = 2.0;
    decoration.dropShadow = dropShadow;
    decoration.innerShadow = innerShadow;
    return decoration;
}

+ (JSButtonDecoration *)highlightDecoration
{
    NSColor *startColor = [NSColor colorWithDeviceRed:0.45 green:0.0 blue:0.0 alpha:1.0];
    NSColor *endColor = [NSColor colorWithDeviceRed:0.3 green:0.0 blue:0.0 alpha:1.0];
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
    JSButtonDecoration *decoration = [[self alloc] initWithGradient:gradient];
    NSShadow *dropShadow = [[NSShadow alloc] init];
    dropShadow.shadowColor = [NSColor colorWithDeviceWhite:1.0 alpha:0.95];
    dropShadow.shadowOffset = NSMakeSize(0.0, -1.0);
    NSShadow *innerShadow = [[NSShadow alloc] init];
    innerShadow.shadowColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.7];
    innerShadow.shadowOffset = NSMakeSize(0.0, -1.0);
    innerShadow.shadowBlurRadius = 2.0;
    decoration.dropShadow = dropShadow;
    decoration.innerShadow = innerShadow;
    return decoration;
}

@end
