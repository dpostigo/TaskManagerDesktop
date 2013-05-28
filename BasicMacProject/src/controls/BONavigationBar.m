//
// Created by Daniela Postigo on 5/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BONavigationBar.h"
#import "BOSilverButtonCell.h"
#import "NSButton+TextColor.h"
#import "BOSilverButton.h"


@implementation BONavigationBar {
}


- (void) setup {
    [super setup];
    //
    //    self.borderColor = [NSColor blackColor];
    //    self.gradientFill = [[NSGradient alloc] initWithColorsAndLocations:
    //            [NSColor colorWithDeviceWhite: 0.15f alpha: 1.0f], 0.0f,
    //            [NSColor colorWithDeviceWhite: 0.19f alpha: 1.0f], 0.5f,
    //            [NSColor colorWithDeviceWhite: 0.20f alpha: 1.0f], 0.5f,
    //            [NSColor colorWithDeviceWhite: 0.25f alpha: 1.0f], 1.0f,
    //            nil];


}

- (void) awakeFromNib {
    [super awakeFromNib];

    //
    //    if (backButtonItem != nil && backButtonItem.superview) [backButtonItem removeFromSuperview];
    //
    //
    //    //
    //    backButtonItem = [[BOSilverButton alloc] initWithFrame: NSZeroRect];
    //    backButtonItem.bezelStyle = NSRoundRectBezelStyle;
    //    backButtonItem.width = 100;
    //    backButtonItem.height = self.barButtonHeight;
    //    [backButtonItem setCell: [[BOSilverButtonCell alloc] initTextCell: @"Hello"]];
    //    backButtonItem.title = @"Back";
    //    [self addSubview: backButtonItem];
    //
    //    backButtonItem.top = (self.height - backButtonItem.height) / 2;
    //    backButtonItem.left = 10;
}

- (BOOL) isFlipped {
    return YES;
}

@end