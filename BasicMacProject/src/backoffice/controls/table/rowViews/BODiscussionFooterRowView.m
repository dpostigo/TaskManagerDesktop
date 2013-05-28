//
// Created by Daniela Postigo on 5/24/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BODiscussionFooterRowView.h"


@implementation BODiscussionFooterRowView {

}


- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {


        gradientColor = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceWhite: 0.55f alpha: 1.0f], 0.0f,
                [NSColor colorWithDeviceWhite: 0.60f alpha: 1.0f], 0.2f,
                [NSColor colorWithDeviceWhite: 0.63f alpha: 1.0f], 0.5f,
                [NSColor colorWithDeviceWhite: 0.60f alpha: 1.0f], 0.7f,
                [NSColor colorWithDeviceWhite: 0.55f alpha: 1.0f], 1.0f,
                nil];

        borderColor = [NSColor darkGrayColor];
        cornerRadius = 5.0;
        shadow.shadowColor = [NSColor whiteColor];

    }

    return self;
}


- (void) drawBackgroundInRect: (NSRect) dirtyRect {

    NSRect rect = self.bounds;
    rect.size.width -= 60;
    rect.origin.x += 60;
    rect.size.height -= 10;

    [self drawBackgroundInRect: rect selected: self.selected];
}

@end