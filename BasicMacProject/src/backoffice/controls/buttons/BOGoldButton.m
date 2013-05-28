//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BOGoldButton.h"
#import "NSButton+TextColor.h"


@implementation BOGoldButton {
}


- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        //        self.textColor = [NSColor whiteColor];
        //        self.font = [NSFont fontWithName: @"HelveticaNeue-Bold" size: 12.0];

        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [NSColor blackColor];
        shadow.shadowBlurRadius = 0.0;
        shadow.shadowOffset = NSMakeSize(0, -1);
        self.shadow = shadow;
    }

    return self;
}

@end