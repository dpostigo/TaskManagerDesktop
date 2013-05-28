//
// Created by Daniela Postigo on 5/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EtchedButtonCell.h"
#import "NSImage+EtchedImageDrawing.h"


@implementation EtchedButtonCell {
}


- (void) drawImage: (NSImage *) image withFrame: (NSRect) frame inView: (NSView *) controlView {
    [super drawImage: image withFrame: frame inView: controlView];

    [[NSColor colorWithDeviceWhite: 0.8 alpha: 1.0] set];
    NSRectFill(frame);

    [image drawEtchedInRect: frame];
}

@end