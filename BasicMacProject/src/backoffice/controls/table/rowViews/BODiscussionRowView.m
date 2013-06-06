//
// Created by Daniela Postigo on 5/24/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BODiscussionRowView.h"
#import "NSColor+Utils.h"


@implementation BODiscussionRowView {

}


- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {

        NSColor *yellow = [NSColor colorWithString: PALE_YELLOW];
        NSColor *darkColor = [NSColor colorWithString: @"be955b"];

        gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [yellow blendedColorWithFraction: 0.45f ofColor: darkColor], 0.0f,
                [yellow blendedColorWithFraction: 0.44f ofColor: darkColor], 0.2f,
                [yellow blendedColorWithFraction: 0.43f ofColor: darkColor], 0.5f,
                [yellow blendedColorWithFraction: 0.40f ofColor: darkColor], 0.7f,
                [yellow blendedColorWithFraction: 0.35f ofColor: darkColor], 1.0f,
                nil];


        //        borderColor = [NSColor colorWithDeviceWhite: 1.0 alpha: 0.8];
        borderColor = [yellow colorWithAlphaComponent: 0.5];
        cornerRadius = 5.0;
    }

    return self;
}


- (void) drawBackgroundInRect: (NSRect) dirtyRect {

    NSRect rect = self.bounds;
    rect.size.width -= 60;
    rect.size.height -= 10;

    [self drawBackgroundInRect: rect selected: self.selected];
}


@end