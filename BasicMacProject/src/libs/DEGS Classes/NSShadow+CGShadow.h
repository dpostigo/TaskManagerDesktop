//
//  NSShadow+CGShadow.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 30/10/12.
//
//

#import <Cocoa/Cocoa.h>

@interface NSShadow (CGShadow)

- (void)setInCGContext:(CGContextRef)context;
+ (void)setShadow:(NSShadow *)shadow inCGContext:(CGContextRef)context;

@end
