//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AgendaHeaderCell.h"


@implementation AgendaHeaderCell {
}


@synthesize font;


- (id) initTextCell: (NSString *) aString {
    self = [super initTextCell: aString];
    if (self) {

        self.font = [NSFont boldSystemFontOfSize: 11.0];
    }

    return self;
}


- (void) drawWithFrame: (NSRect) inFrame inView: (NSView *) inView {
    /* Draw metalBg lowest pixel along the bottom of inFrame. */

    NSRect tempSrc = NSZeroRect;
    tempSrc.size = [metalBg size];
    tempSrc.origin.y = tempSrc.size.height - 1.0;
    tempSrc.size.height = 1.0;

    NSRect tempDst = inFrame;
    tempDst.origin.y = inFrame.size.height - 1.0;
    tempDst.size.height = 1.0;

    [metalBg drawInRect: tempDst fromRect: tempSrc operation: NSCompositeSourceOver fraction: 1.0];

    /* Draw rest of metalBg along width of inFrame. */
    tempSrc.origin.y = 0.0;
    tempSrc.size.height = [metalBg size].height - 1.0;

    tempDst.origin.y = 1.0;
    tempDst.size.height = inFrame.size.height - 2.0;

    [metalBg drawInRect: tempDst fromRect: tempSrc operation: NSCompositeSourceOver fraction: 1.0];

    /* Draw white text centered, but offset down-left. */
    float offset = 0.5;

    [attrs setObject: self.font forKey: NSFontAttributeName];
    [attrs setValue: [NSColor colorWithCalibratedWhite: 1.0 alpha: 0.7] forKey: @"NSColor"];

    NSRect centeredRect = inFrame;
    centeredRect.size = [self.stringValue sizeWithAttributes: attrs];
    centeredRect.origin.x +=
            ((inFrame.size.width - centeredRect.size.width) / 2.0) - offset;
    centeredRect.origin.y =
            ((inFrame.size.height - centeredRect.size.height) / 2.0) + offset;
    [self.stringValue drawInRect: centeredRect withAttributes: attrs];

    /* Draw black text centered. */
    [attrs setValue: [NSColor blackColor] forKey: @"NSColor"];
    centeredRect.origin.x += offset;
    centeredRect.origin.y -= offset;
    [self.stringValue drawInRect: centeredRect withAttributes: attrs];
}

@end