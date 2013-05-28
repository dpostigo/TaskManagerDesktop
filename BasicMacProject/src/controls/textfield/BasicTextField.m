//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicTextField.h"


@implementation BasicTextField {
}


@synthesize rowObject;
@synthesize tableSection;
@synthesize shadow;

@synthesize text;

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        self.shadow = [[NSShadow alloc] init];
        self.shadowBlurRadius = 0;
        self.shadowColor = [NSColor clearColor];
        self.shadowOffset = NSMakeSize(0, 0);
    }

    return self;
}

- (NSColor *) shadowColor {
    return shadow.shadowColor;
}

- (NSSize) shadowOffset {
    return shadow.shadowOffset;
}

- (CGFloat) shadowBlurRadius {
    return shadow.shadowBlurRadius;
}

- (void) setShadowColor: (NSColor *) color {
    shadow.shadowColor = color;
    [self updateShadow];
}

- (void) setShadowOffset: (NSSize) size {
    shadow.shadowOffset = size;
    [self updateShadow];
}

- (void) setShadowBlurRadius: (CGFloat) blurRadius {
    shadow.shadowBlurRadius = blurRadius;
    [self updateShadow];
}

- (void) updateShadow {
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedStringValue];
//    NSRange range = NSMakeRange(0, string.string.length);
//    [string addAttribute: NSShadowAttributeName value: shadow range: range];
//    self.attributedStringValue = string;
}

- (void) updateShadowWithString: (NSString *) string {
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString: text];
    NSRange range = NSMakeRange(0, mutableString.string.length);

    [mutableString addAttribute: NSShadowAttributeName value: shadow range: range];
    self.attributedStringValue = mutableString;
}

@end