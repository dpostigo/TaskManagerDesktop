//
// Created by Daniela Postigo on 5/14/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOSidebarLabel.h"


@implementation BOSidebarLabel {
}


@synthesize unhighlightedShadowColor;

- (void) setShadowColor: (NSColor *) shadowColor {
//    [super setShadowColor: shadowColor];
}

- (void) setHighlighted: (BOOL) highlighted {
//    [super setHighlighted: highlighted];
    if (!unhighlightedShadowColor && !highlighted) {
//        self.unhighlightedShadowColor = self.shadowColor;
    }

    self.shadowColor = highlighted ? self.highlightedShadowColor: self.unhighlightedShadowColor;
}

@end