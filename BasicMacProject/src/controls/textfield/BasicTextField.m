//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicTextField.h"
#import "NSTextField+DPUtils.h"


@implementation BasicTextField {
}


@synthesize rowObject;
@synthesize tableSection;
@synthesize shadow;

@synthesize text;

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
    }

    return self;
}


- (NSShadow *) shadow {
    if (shadow == nil) {
        shadow = [[NSShadow alloc] init];
        [shadow addObserver: self forKeyPath: @"shadowColor" options: (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context: NULL];

    }
    return shadow;
}


- (void) updateShadow {
    [self setAttributedShadow: shadow];
}

- (void) updateShadowWithString: (NSString *) string {
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString: text];
    NSRange range = NSMakeRange(0, mutableString.string.length);

    [mutableString addAttribute: NSShadowAttributeName value: shadow range: range];
    self.attributedStringValue = mutableString;
}


- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    if (object == shadow) {
        [self updateShadow];
    }
}

- (void) dealloc {
    [shadow removeObserver: self forKeyPath: @"shadowColor"];
}


@end