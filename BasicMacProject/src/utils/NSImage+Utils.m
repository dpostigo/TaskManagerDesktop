//
//  NSImage+Addons.m
//  NewsToons
//
//  Created by Daniela Postigo on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSImage+Utils.h"
#import <QuartzCore/QuartzCore.h>


@implementation NSImage (Utils)

//
//+ (NSImage *) newImageCopy: (NSImage *) image {
//    NSImage *imageToCopy = image;
//    UIGraphicsBeginImageContext(imageToCopy.size);
//    [imageToCopy drawInRect: CGRectMake(0, 0, imageToCopy.size.width, imageToCopy.size.height)];
//    NSImage *copiedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return copiedImage;
//}


//+ (NSImage *) maskImage: (NSImage *) image withMask: (NSImage *) maskImage {
//
//    CGImageRef maskRef = maskImage.CGImage;
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
//            CGImageGetHeight(maskRef),
//            CGImageGetBitsPerComponent(maskRef),
//            CGImageGetBitsPerPixel(maskRef),
//            CGImageGetBytesPerRow(maskRef),
//            CGImageGetDataProvider(maskRef), NULL, false);
//    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
//    return [NSImage imageWithCGImage: masked];
//}


+ (NSImage *) newImageFromURL: (NSURL *) imageURL {
    NSData *data = [NSData dataWithContentsOfURL: imageURL];
    NSImage *image = [[NSImage alloc] initWithData: data];
    return image;
}


+ (NSImage *) newImageFromResource: (NSString *) filename {
    NSString *imageFile = [[NSString alloc] initWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    NSImage *image = nil;
    image = [[NSImage alloc] initWithContentsOfFile: imageFile];
    return image;
}

//
//- (NSImage *) scale: (NSImage *) image toSize: (CGSize) size {
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect: CGRectMake(0, 0, size.width, size.height)];
//    NSImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return scaledImage;
//}


- (NSImage *) crop: (NSImage *) image toSize: (CGSize) size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    return [self crop: image toRect: rect];
}


- (NSImage *) crop: (NSImage *) image toSize: (CGSize) size centered: (BOOL) center {
    CGRect rect = CGRectMake((image.size.width - size.width) / 2,
            (image.size.height - size.height) / 2,
            size.width,
            size.height);
    return [self crop: image toRect: rect];
}


//- (NSImage *) crop: (NSImage *) image toRect: (CGRect) rect {
//
//
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
//    NSImage *newImage = [NSImage imageWithCGImage: imageRef];
//    CGImageRelease(imageRef);
//    return newImage;
//}

//
//+ (NSImage *) optimize: (NSImage *) image {
//
//    NSImage *newImage;
//    CGFloat toWidth = image.size.width * 2.85;
//    CGFloat prop = toWidth / image.size.width;
//    CGSize newSize = CGSizeMake(toWidth, image.size.height * prop);
//
//    UIGraphicsBeginImageContext(newSize);
//    [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return newImage;
//}
@end
