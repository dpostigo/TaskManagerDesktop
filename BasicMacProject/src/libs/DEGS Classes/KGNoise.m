//
//  KGNoise.m
//  KGNoise
//
//  Created by David Keegan on 9/11/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "KGNoise.h"
#import "NSBezierPath+Additions.h"
#import "NSColor+CGColor.h"

static NSUInteger const kKGNoiseImageSize = 128;

#if TARGET_OS_IPHONE
static inline CGFloat *gradientComponentsForColors(UIColor *color1, UIColor *color2){
#else
static inline CGFloat *gradientComponentsForColors(NSColor *color1, NSColor *color2){
#endif
    CGFloat *components = malloc(8*sizeof(CGFloat));
    const CGFloat *alternateBackgroundComponents = CGColorGetComponents([color1 CGColorCreate]);
    if(CGColorGetNumberOfComponents([color1 CGColorCreate]) == 2){
        components[0] = alternateBackgroundComponents[0];
        components[1] = alternateBackgroundComponents[0];
        components[2] = alternateBackgroundComponents[0];
        components[3] = alternateBackgroundComponents[1];
    }else{
        components[0] = alternateBackgroundComponents[0];
        components[1] = alternateBackgroundComponents[1];
        components[2] = alternateBackgroundComponents[2];
        components[3] = alternateBackgroundComponents[3];
    }

    const CGFloat *backgroundComponents = CGColorGetComponents([color2 CGColorCreate]);
    if(CGColorGetNumberOfComponents([color2 CGColorCreate]) == 2){
        components[4] = backgroundComponents[0];
        components[5] = backgroundComponents[0];
        components[6] = backgroundComponents[0];
        components[7] = backgroundComponents[1];
    }else{
        components[4] = backgroundComponents[0];
        components[5] = backgroundComponents[1];
        components[6] = backgroundComponents[2];
        components[7] = backgroundComponents[3];
    }
    return components;
}

#pragma mark - KGNoise

@implementation KGNoise

+ (void)drawNoiseWithOpacity:(CGFloat)opacity{
    [self drawNoiseWithOpacity:opacity andBlendMode:kCGBlendModeScreen];
}

+ (void)drawNoiseWithOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode{
    static CGImageRef noiseImageRef = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSUInteger width = kKGNoiseImageSize, height = width;
        NSUInteger size = width*height;
        char *rgba = (char *)malloc(size); srand(115);
        for(NSUInteger i=0; i < size; ++i){rgba[i] = rand()%256;}
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef bitmapContext =
        CGBitmapContextCreate(rgba, width, height, 8, width, colorSpace, kCGImageAlphaNone);
        CFRelease(colorSpace);
        noiseImageRef = CGBitmapContextCreateImage(bitmapContext);
        CFRelease(bitmapContext);
        free(rgba);
    });

#if TARGET_OS_IPHONE
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
#endif

    CGContextSaveGState(context);
    CGContextSetAlpha(context, opacity);
    CGContextSetBlendMode(context, blendMode);

#if TARGET_OS_IPHONE
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        CGFloat scaleFactor = [[UIScreen mainScreen] scale];
        CGContextScaleCTM(context, 1/scaleFactor, 1/scaleFactor);
    }
#else
    if([[NSScreen mainScreen] respondsToSelector:@selector(backingScaleFactor)]){
        CGFloat scaleFactor = [[NSScreen mainScreen] backingScaleFactor];
        CGContextScaleCTM(context, 1/scaleFactor, 1/scaleFactor);
    }
#endif

    CGRect imageRect = (CGRect){CGPointZero, CGImageGetWidth(noiseImageRef), CGImageGetHeight(noiseImageRef)};
    CGContextDrawTiledImage(context, imageRect, noiseImageRef);
    CGContextRestoreGState(context);
}

@end

#pragma mark - KGNoise Color

#if TARGET_OS_IPHONE
@implementation UIColor(KGNoise)
- (UIColor *)colorWithNoiseWithOpacity:(CGFloat)opacity{
    return [self colorWithNoiseWithOpacity:opacity andBlendMode:kCGBlendModeScreen];
}
- (UIColor *)colorWithNoiseWithOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode{
    CGRect rect = {CGPointZero, kKGNoiseImageSize, kKGNoiseImageSize};
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self setFill]; CGContextFillRect(context, rect);
    [KGNoise drawNoiseWithOpacity:opacity andBlendMode:blendMode];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}
@end
#else
@implementation NSColor(KGNoise)
- (NSColor *)colorWithNoiseWithOpacity:(CGFloat)opacity{
    return [self colorWithNoiseWithOpacity:opacity andBlendMode:kCGBlendModeScreen];    
}
- (NSColor *)colorWithNoiseWithOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode{
    CGRect rect = {CGPointZero, kKGNoiseImageSize, kKGNoiseImageSize};
    NSImage *image = [[NSImage alloc] initWithSize:rect.size];
    [image lockFocus];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];  
    [self setFill]; CGContextFillRect(context, rect);
    [KGNoise drawNoiseWithOpacity:opacity andBlendMode:blendMode];
    [image unlockFocus];
    return [NSColor colorWithPatternImage:image];
}
@end
#endif

#pragma mark - KGNoiseView

@implementation KGNoiseView

#if TARGET_OS_IPHONE
- (id)initWithFrame:(CGRect)frameRect{
#else
- (id)initWithFrame:(NSRect)frameRect{
#endif
    if((self = [super initWithFrame:frameRect])){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super initWithCoder:aDecoder])){
        [self setup];
    }
    return self;
}

- (void)setup{
#if TARGET_OS_IPHONE
    self.backgroundColor = [UIColor grayColor];
#else
    self.backgroundColor = [NSColor grayColor];
#endif
    self.noiseOpacity = 0.1;
    self.noiseBlendMode = kCGBlendModeScreen;
}

#if TARGET_OS_IPHONE
#else
- (void)setBackgroundColor:(NSColor *)backgroundColor{
    if(_backgroundColor != backgroundColor){
        _backgroundColor = backgroundColor;
        [self setNeedsDisplay:YES];
    }
}
#endif

- (void)setNoiseOpacity:(CGFloat)noiseOpacity{
    if(_noiseOpacity != noiseOpacity){
        _noiseOpacity = noiseOpacity;
#if TARGET_OS_IPHONE        
        [self setNeedsDisplay];
#else
        [self setNeedsDisplay:YES];
#endif
    }
}

- (void)setNoiseBlendMode:(CGBlendMode)noiseBlendMode{
    if(_noiseBlendMode != noiseBlendMode){
        _noiseBlendMode = noiseBlendMode;
#if TARGET_OS_IPHONE
        [self setNeedsDisplay];
#else
        [self setNeedsDisplay:YES];
#endif
    }
}

#if TARGET_OS_IPHONE
- (void)drawRect:(CGRect)dirtyRect{
    CGContextRef context = UIGraphicsGetCurrentContext();    
#else
- (void)drawRect:(NSRect)dirtyRect{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];    
#endif
    [self.backgroundColor setFill];
    CGContextFillRect(context, self.bounds);
    [KGNoise drawNoiseWithOpacity:self.noiseOpacity andBlendMode:self.noiseBlendMode];
    
#if !TARGET_OS_IPHONE
    if (_shadow) {
        
//        [NSGraphicsContext saveGraphicsState];        
//        [self.shadow set];
//        
//        NSColor *backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:1.0];
//        [backgroundColor setFill];
//        
//        if (self.shadow.shadowOffset.width!=0) {
//            CGFloat horShadowOrigin;
//            if (self.shadow.shadowOffset.width > 0) horShadowOrigin = -self.shadow.shadowOffset.width;
//            else horShadowOrigin = self.bounds.size.width;
//            NSRect horShadowRect = NSMakeRect(horShadowOrigin, 0.0, abs(self.shadow.shadowOffset.width), [self bounds].size.height);
//            [[NSBezierPath bezierPathWithRect:horShadowRect] fill];
//        }
//        if (self.shadow.shadowOffset.height!=0) {
//            CGFloat verShadowOrigin;
//            if (self.shadow.shadowOffset.height > 0) verShadowOrigin = -self.shadow.shadowOffset.height;
//            else verShadowOrigin = self.bounds.size.height;
//            NSRect verShadowRect = NSMakeRect(verShadowOrigin, 0.0, [self bounds].size.width, abs(self.shadow.shadowOffset.height));
//            [[NSBezierPath bezierPathWithRect:verShadowRect] fill];
//        }
//        
//        [NSGraphicsContext restoreGraphicsState];
        [[NSColor clearColor] setFill];
        [[NSBezierPath bezierPathWithRect:dirtyRect] fillWithInnerShadow:self.shadow];
    }
#endif
}

@end

#pragma mark - KGNoiseLinearGradientView

@implementation KGNoiseLinearGradientView
    
- (void)setup{
    [super setup];
    self.gradientDirection = KGLinearGradientDirection270Degrees;
}

#if TARGET_OS_IPHONE
- (void)setAlternateBackgroundColor:(UIColor *)alternateBackgroundColor{
    if(_alternateBackgroundColor != alternateBackgroundColor){
        _alternateBackgroundColor = alternateBackgroundColor;
        [self setNeedsDisplay];
    }
}
#else
- (void)setAlternateBackgroundColor:(NSColor *)alternateBackgroundColor{
    if(_alternateBackgroundColor != alternateBackgroundColor){
        _alternateBackgroundColor = alternateBackgroundColor;
        [self setNeedsDisplay:YES];
    }
}
#endif

#if TARGET_OS_IPHONE
- (void)drawRect:(CGRect)dirtyRect{
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
- (void)drawRect:(NSRect)dirtyRect{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
#endif
    // if we don't have an alternate color draw solid
    if(self.alternateBackgroundColor == nil){
        [super drawRect:dirtyRect];
        return;
    }
    
    CGRect bounds = self.bounds;
    CGContextSaveGState(context);    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat *components = gradientComponentsForColors(self.alternateBackgroundColor, self.backgroundColor);    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, components, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGPoint startPoint;
    CGPoint endPoint;
    switch (self.gradientDirection) {
        case KGLinearGradientDirection0Degrees:
            startPoint = CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds));
            endPoint = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds));
            break;
        case KGLinearGradientDirection90Degrees:
            startPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
            endPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds));
            break;
        case KGLinearGradientDirection180Degrees:
            startPoint = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds));
            endPoint = CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds));
            break;
        case KGLinearGradientDirection270Degrees:
        default:
            startPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds));
            endPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
            break;
    }
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    free(components);
    
    [KGNoise drawNoiseWithOpacity:self.noiseOpacity andBlendMode:self.noiseBlendMode];
}
    
@end

#pragma mark - KGNoiseRadialGradientView

@implementation KGNoiseRadialGradientView

#if TARGET_OS_IPHONE
- (void)setAlternateBackgroundColor:(UIColor *)alternateBackgroundColor{
    if(_alternateBackgroundColor != alternateBackgroundColor){
        _alternateBackgroundColor = alternateBackgroundColor;
        [self setNeedsDisplay];
    }
}
#else
- (void)setAlternateBackgroundColor:(NSColor *)alternateBackgroundColor{
    if(_alternateBackgroundColor != alternateBackgroundColor){
        _alternateBackgroundColor = alternateBackgroundColor;
        [self setNeedsDisplay:YES];
    }
}
#endif

#if TARGET_OS_IPHONE
- (void)drawRect:(CGRect)dirtyRect{
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
- (void)drawRect:(NSRect)dirtyRect{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
#endif
    // if we don't have an alternate color draw solid
    if(self.alternateBackgroundColor == nil){
        [super drawRect:dirtyRect];
        return;
    }
    
    CGRect bounds = self.bounds;
    CGContextSaveGState(context);
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat *components = gradientComponentsForColors(self.alternateBackgroundColor, self.backgroundColor);
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace), colorSpace = NULL;
    CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(bounds)), round(CGRectGetMidY(bounds)));
    CGFloat gradRadius = sqrt(pow((CGRectGetHeight(bounds)/2), 2) + pow((CGRectGetWidth(bounds)/2), 2));
    CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    free(components);
    
    [KGNoise drawNoiseWithOpacity:self.noiseOpacity andBlendMode:self.noiseBlendMode];
}
@end
