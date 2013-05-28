//
//  AMDarkButton.m
//  Button
//
//  Created by ampatspell on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BasicButtonCell.h"


@implementation BasicButtonCell


@synthesize textColor;
@synthesize disabledTextColor;
@synthesize textShadow;
@synthesize disabledTextShadow;

- (void) setup {
    [super setup];
    textColor = [NSColor whiteColor];
    disabledTextColor = [NSColor colorWithDeviceWhite: 0.3 alpha: 1.0];

    textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = [NSColor clearColor];
    textShadow.shadowBlurRadius = 1.0;
    textShadow.shadowOffset = NSMakeSize(0, -1);

    disabledTextShadow = [[NSShadow alloc] init];
    disabledTextShadow.shadowColor = [NSColor clearColor];
    disabledTextShadow.shadowBlurRadius = 1.0;
    disabledTextShadow.shadowOffset = NSMakeSize(0, -1);

    //    [self updateTextColor];

}

- (NSRect) drawTitle: (NSAttributedString *) title withFrame: (NSRect) frame inView: (NSView *) controlView {

    [NSGraphicsContext saveGraphicsState];
    [controlView setKeyboardFocusRingNeedsDisplayInRect: frame];

    if ([self showsFirstResponder]) {
    }

    NSColor *color = self.isEnabled ? textColor: disabledTextColor;
    NSShadow *selectedShadow = self.isEnabled ? textShadow: disabledTextShadow;
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedTitle];

    NSRange titleRange = NSMakeRange(0, colorTitle.length);
    [colorTitle addAttribute: NSForegroundColorAttributeName value: color range: titleRange];
    [colorTitle addAttribute: NSShadowAttributeName value: selectedShadow range: NSMakeRange(0, self.title.length)];

    NSRect r = [super drawTitle: colorTitle withFrame: frame inView: controlView];
    [NSGraphicsContext restoreGraphicsState];
    return r;
}




@end
