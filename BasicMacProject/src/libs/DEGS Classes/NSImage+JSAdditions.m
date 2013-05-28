//
//  NSImage+JSAdditions.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 28/07/12.
//
//

#import "NSImage+JSAdditions.h"
#import "NSShadow+CGShadow.h"
#import <QuartzCore/QuartzCore.h>

#define LINE_START_POINT 2.0

@implementation NSImage (JSAdditions)

+ (NSImage *)imageWithString:(NSString *)string
{
    NSSize imageSize = NSMakeSize(105, 31);
    
    [NSGraphicsContext saveGraphicsState];
    NSImage *myImage = [[NSImage alloc] initWithSize:NSMakeSize(imageSize.width, imageSize.height)];
    [myImage lockFocus];
    
    NSGradient *gradient = gradientWithTargetColor([NSColor colorWithSRGBRed:.60 green:.60 blue:.60 alpha:1]);
    NSRect verticalRect = NSMakeRect(0.0, LINE_START_POINT, 1, imageSize.height-2*LINE_START_POINT);
    [gradient drawInRect:verticalRect angle:90];
    gradient = gradientWithTargetColor([NSColor colorWithSRGBRed:1.0 green:1.0 blue:1.0 alpha:1]);
    verticalRect = NSMakeRect(1.0, LINE_START_POINT, 1, imageSize.height-2*LINE_START_POINT);
    [gradient drawInRect:verticalRect angle:90];
    
    // white
    NSColor *textColor = [NSColor blackColor];
    NSFont *sysUIFont = [NSFont fontWithName:@"Lucida Grande Bold" size:13];
    NSDictionary *attributesDict = @{NSFontAttributeName: sysUIFont, NSForegroundColorAttributeName: textColor};
    NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:string attributes:attributesDict];
    NSSize stringSize = [stringToDraw size];
    NSPoint stringOrigin = NSMakePoint(0.5*(imageSize.width - stringSize.width), 0.5*(imageSize.height - stringSize.height));
    [stringToDraw drawAtPoint:stringOrigin];
    
    [myImage unlockFocus];
    
    [NSGraphicsContext restoreGraphicsState];
    
    return myImage;
}

static NSGradient *gradientWithTargetColor(NSColor *targetColor) {
    NSArray *colors = @[[targetColor colorWithAlphaComponent:0], targetColor, targetColor, [targetColor colorWithAlphaComponent:0]];
    const CGFloat locations[4] = { 0.0, 0.35, 0.65, 1.0 };
    return [[NSGradient alloc] initWithColors:colors atLocations:locations colorSpace:[NSColorSpace sRGBColorSpace]];
}

- (void)drawInRect:(NSRect)rect withGradient:(NSGradient *)gradient innerShadow:(NSShadow *)innerShadow dropShadow:(NSShadow *)dropShadow fraction:(CGFloat)fraction
{
    CGContextRef c = [[NSGraphicsContext currentContext] graphicsPort];
    
    //save the current graphics state
    CGContextSaveGState(c);
    CGContextSetAlpha(c, fraction);
    
    //Create mask image:
    NSRect maskRect = rect;
    CGImageRef maskImage = [self CGImageForProposedRect:&maskRect context:[NSGraphicsContext currentContext] hints:nil];
    
    //Draw image and white drop shadow:
    if (dropShadow) {
        [dropShadow setInCGContext:c];
    }
    [self drawInRect:maskRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:fraction];
    
    //Clip drawing to mask:
    CGContextClipToMask(c, NSRectToCGRect(maskRect), maskImage);
    
    //Draw gradient:
    [gradient drawInRect:maskRect angle:90.0];

    if (innerShadow) {
        //    CGContextSetShadowWithColor(c, CGSizeMake(0, -1), innerShadowBlurRadius, CGColorGetConstantColor(kCGColorBlack));
        [innerShadow setInCGContext:c];
        
        //Draw inner shadow with inverted mask:
        NSRect rectForLocalContext = maskRect;
        rectForLocalContext.origin.x = 0.0;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef maskContext = CGBitmapContextCreate(NULL, CGImageGetWidth(maskImage), CGImageGetHeight(maskImage), 8, CGImageGetWidth(maskImage) * 4, colorSpace, kCGImageAlphaPremultipliedLast);
        CGFloat scale = [[NSScreen mainScreen] backingScaleFactor];
        CGContextScaleCTM(maskContext, scale, scale);
        CGColorSpaceRelease(colorSpace);
        CGContextSetBlendMode(maskContext, kCGBlendModeXOR);
        CGContextDrawImage(maskContext, rectForLocalContext, maskImage);
        CGContextSetRGBFillColor(maskContext, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(maskContext, rectForLocalContext);
        CGImageRef invertedMaskImage = CGBitmapContextCreateImage(maskContext);
        CGContextDrawImage(c, maskRect, invertedMaskImage);
    }
    
    //restore the graphics state
    CGContextRestoreGState(c);
}

- (void)drawInRect:(NSRect)rect withColor:(NSColor *)color innerShadow:(NSShadow *)innerShadow dropShadow:(NSShadow *)dropShadow fraction:(CGFloat)fraction
{
    CGContextRef c = [[NSGraphicsContext currentContext] graphicsPort];
    
    //save the current graphics state
    CGContextSaveGState(c);
    CGContextSetAlpha(c, fraction);
    
    //Create mask image:
    NSRect maskRect = rect;
    CGImageRef maskImage = [self CGImageForProposedRect:&maskRect context:[NSGraphicsContext currentContext] hints:nil];
    
    //Draw image and white drop shadow:
    if (dropShadow) {
        //    CGContextSetShadowWithColor(c, CGSizeMake(0, dropShadowOffsetY), 0, CGColorGetConstantColor(kCGColorWhite));
        [dropShadow setInCGContext:c];
    }
    [self drawInRect:maskRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:fraction];
    
    //Clip drawing to mask:
    CGContextClipToMask(c, NSRectToCGRect(maskRect), maskImage);
    
    //Draw color:
    [color drawSwatchInRect:maskRect];
    
    if (innerShadow) {
        //    CGContextSetShadowWithColor(c, CGSizeMake(0, -1), innerShadowBlurRadius, CGColorGetConstantColor(kCGColorBlack));
        [innerShadow setInCGContext:c];
        
        //Draw inner shadow with inverted mask:
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef maskContext = CGBitmapContextCreate(NULL, CGImageGetWidth(maskImage), CGImageGetHeight(maskImage), 8, CGImageGetWidth(maskImage) * 4, colorSpace, kCGImageAlphaPremultipliedLast);
        CGFloat scale = [[NSScreen mainScreen] backingScaleFactor];
        CGContextScaleCTM(maskContext, scale, scale);
        CGColorSpaceRelease(colorSpace);
        CGContextSetBlendMode(maskContext, kCGBlendModeXOR);
        CGContextDrawImage(maskContext, maskRect, maskImage);
        CGContextSetRGBFillColor(maskContext, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(maskContext, maskRect);
        CGImageRef invertedMaskImage = CGBitmapContextCreateImage(maskContext);
        CGContextDrawImage(c, maskRect, invertedMaskImage);
    }
    
    //restore the graphics state
    CGContextRestoreGState(c);
}

@end
