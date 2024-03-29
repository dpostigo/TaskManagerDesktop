//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicTableView.h"


@implementation BasicTableView {
}


- (void) awakeFromNib {
    [super awakeFromNib];
}

- (void) highlightSelectionInClipRect: (NSRect) clipRect {
    // this method is asking us to draw the hightlights for
    // all of the selected rows that are visible inside theClipRect

    // 1. get the range of row indexes that are currently visible
    // 2. get a list of selected rows
    // 3. iterate over the visible rows and if their index is selected
    // 4. draw our custom highlight in the rect of that row.

    NSRange aVisibleRowIndexes = [self rowsInRect: clipRect];
    NSIndexSet *aSelectedRowIndexes = [self selectedRowIndexes];
    int aRow = aVisibleRowIndexes.location;
    int anEndRow = aRow + aVisibleRowIndexes.length;
    NSGradient *gradient;
    NSColor *pathColor;

    // if the view is focused, use highlight color, otherwise use the out-of-focus highlight color
    if (self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow]) {
        gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceRed: (float) 62 / 255 green: (float) 133 / 255 blue: (float) 197 / 255 alpha: 1.0], 0.0,
                [NSColor colorWithDeviceRed: (float) 48 / 255 green: (float) 95 / 255 blue: (float) 152 / 255 alpha: 1.0], 1.0, nil]; //160 80

        pathColor = [NSColor colorWithDeviceRed: (float) 48 / 255 green: (float) 95 / 255 blue: (float) 152 / 255 alpha: 1.0];
    }
    else {
        gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithDeviceRed: (float) 190 / 255 green: (float) 190 / 255 blue: (float) 190 / 255 alpha: 1.0], 0.0,
                [NSColor colorWithDeviceRed: (float) 150 / 255 green: (float) 150 / 255 blue: (float) 150 / 255 alpha: 1.0], 1.0, nil];

        pathColor = [NSColor colorWithDeviceRed: (float) 150 / 255 green: (float) 150 / 255 blue: (float) 150 / 255 alpha: 1.0];
    }

    // draw highlight for the visible, selected rows
    for (aRow; aRow < anEndRow; aRow++) {
        if ([aSelectedRowIndexes containsIndex: aRow]) {
            NSRect aRowRect = NSInsetRect([self rectOfRow: aRow], 1, 4); //first is horizontal, second is vertical
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: aRowRect xRadius: 4.0 yRadius: 4.0]; //6.0
            [path setLineWidth: 2];
            //            [pathColor set];
            [path stroke];

            [gradient drawInBezierPath: path angle: 90];
        }
    }
}

- (NSRect) adjustScroll: (NSRect) newVisible {
    NSRect modifiedRect = newVisible;
    modifiedRect.origin.x = 0;
    modifiedRect.origin.y = 0;

    // snap to 72 pixel increments
    //    modifiedRect.origin.x = (int) (modifiedRect.origin.x / 72.0) * 72.0;
    //    modifiedRect.origin.y = (int) (modifiedRect.origin.y / 72.0) * 72.0;

    // return the modified rectangle
    return modifiedRect;
}

@end