//
//  NSImage+JSAdditions.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 28/07/12.
//
//

#import <Cocoa/Cocoa.h>

@interface NSImage (JSAdditions)

+ (NSImage *)imageWithString:(NSString *)string;
- (void)drawInRect:(NSRect)rect withGradient:(NSGradient *)gradient innerShadow:(NSShadow *)innerShadow dropShadow:(NSShadow *)dropShadow fraction:(CGFloat)fraction;
- (void)drawInRect:(NSRect)rect withColor:(NSColor *)color innerShadow:(NSShadow *)innerShadow dropShadow:(NSShadow *)dropShadow fraction:(CGFloat)fraction;

@end