//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSButton (TextColor)


- (NSColor *) textColor;
- (void) setTextColor: (NSColor *) textColor;
- (void) setFont: (NSFont *) font;
- (NSColor *) shadowColor;
- (void) setShadowColor: (NSColor *) shadowColor;
@end