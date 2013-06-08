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
@synthesize delegate;

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



#pragma mark Convenience

- (void) setText: (NSString *) string {
    self.stringValue = string;
}
#pragma mark Delegating

- (void) textDidChange: (NSNotification *) notification {
    [super textDidChange: notification];
    [self notifyDelegate: @selector(textFieldDidChange:notification:) object: self andObject: notification];
}


- (void) notifyDelegate: (SEL) selector object: (id) object1 andObject: (id) object2 {
    if (delegate != nil && [delegate respondsToSelector: selector]) {
        [delegate performSelector: selector withObject: object1 withObject: object2];
    }

}


@end