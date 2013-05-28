//
//  BasicCell.m
//  TaskManager
//
//  Created by Daniela Postigo on 5/27/13.
//  Copyright 2013 Dani Postigo. All rights reserved.
//

#import "BasicImageCell.h"
#import "NSBezierPath+DPUtils.h"
#import "NSImage+NiceScaling.h"


@implementation BasicImageCell {

}


@synthesize cornerRadius;

@synthesize shadow;

@synthesize borderColor;

@synthesize borderWidth;

- (void) setup {

    cornerRadius = 4.0;

    shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [NSColor blackColor];
    shadow.shadowBlurRadius = 2.0;
    shadow.shadowOffset = NSMakeSize(0, -1);

    borderColor = [NSColor colorWithDeviceWhite: 1.0 alpha: 0.1];
    borderWidth = 0.5;


}

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        [self setup];
    }

    return self;
}

- (id) initTextCell: (NSString *) aString {
    self = [super initTextCell: aString];
    if (self) {
        [self setup];
    }

    return self;
}

- (id) initImageCell: (NSImage *) image {
    self = [super initImageCell: image];
    if (self) {
        [self setup];

    }

    return self;
}


- (void) drawWithFrame: (NSRect) cellFrame inView: (NSView *) controlView {


    CGFloat offset = shadow.shadowBlurRadius + 1.0;


    NSRect pathRect = cellFrame;

    //    rect = imageRect;

    pathRect.size.height -= offset;
    pathRect.size.width -= offset;
    pathRect.origin.y += (offset - 0.5);


    NSImage *scaledImage = [self.image scaledImageToCoverSize: pathRect.size withInterpolation: NSImageInterpolationDefault andBox: YES];


    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: pathRect xRadius: cornerRadius yRadius: cornerRadius];

    [path drawShadow: shadow shadowOpacity: 0.5];
    [path drawImage: scaledImage];
    [path drawStroke: borderColor width: borderWidth];

}


- (BOOL) isOpaque {
    return NO;
}


@end