//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSTextField+Utils.h"


@implementation NSTextField (Utils)

//
//- (NSShadow *) shadow {
//    NSAttributedString *attrTitle = [self attributedStringValue];
//    int len = [attrTitle length];
//    NSRange range = NSMakeRange(0, MIN(len, 1)); // take color from first char
//    NSDictionary *attrs = [attrTitle fontAttributesInRange: range];
//    NSShadow *shadow;
//    if (attrs) {
//        shadow = [attrs objectForKey: NSShadowAttributeName];
//    }
//    return shadow;
//}
//
//- (void) setShadow: (NSShadow *) shadow {
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedStringValue];
//    int len = [attributedString length];
//    NSRange range = NSMakeRange(0, len);
//
//    [attributedString addAttribute: NSShadowAttributeName value: shadow range: range];
//    [attributedString fixAttributesInRange: range];
//    [self setAttributedStringValue: attributedString];
//}
//
//- (void) setShadowColor: (NSColor *) color {
//    NSShadow *shadow = self.shadow;
//    if (shadow == nil) shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = color;
//    [self setShadow: shadow];
//}
//
//- (NSColor *) shadowColor {
//    NSShadow *shadow = self.shadow;
//    return shadow.shadowColor;
//}
//
//- (NSSize) shadowOffset {
//    NSShadow *shadow = self.shadow;
//    return shadow.shadowOffset;
//}
//
//- (void) setShadowOffset: (NSSize) offset {
//    NSShadow *shadow = self.shadow;
//    if (shadow == nil) shadow = [[NSShadow alloc] init];
//    shadow.shadowOffset = offset;
//    [self setShadow: shadow];
//}
//
//- (void) setText: (NSString *) string {
//    self.stringValue = string;
//}
//
//- (NSString *) text {
//    return self.stringValue;
//}

@end