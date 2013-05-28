//
//  NSImage+Addons.h
//  NewsToons
//
//  Created by Daniela Postigo on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface NSImage (Utils)


+ (NSImage *) newImageFromResource: (NSString *) filename;
+ (NSImage *) newImageFromURL: (NSURL *) imageURL;
+ (NSImage *) newImageCopy: (NSImage *) image;
+ (NSImage *) maskImage: (NSImage *) image withMask: (NSImage *) maskImage;
- (NSImage *) scale: (NSImage *) image toSize: (CGSize) size;
- (NSImage *) crop: (NSImage *) image toSize: (CGSize) size centered: (BOOL) center;
- (NSImage *) crop: (NSImage *) image toRect: (CGRect) rect;
+ (NSImage *) optimize: (NSImage *) image;

@end
