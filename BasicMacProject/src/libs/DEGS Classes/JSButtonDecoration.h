//
//  JSButtonDecoration.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/11/12.
//
//

#import <Foundation/Foundation.h>

@interface JSButtonDecoration : NSObject

// properties applied to the image of a JSFlexibleButtonCell
@property (nonatomic, strong) NSColor *color;
@property (nonatomic, strong) NSGradient *gradient;
@property (nonatomic, strong) NSShadow *innerShadow;
@property (nonatomic, strong) NSShadow *dropShadow;

// convenience property that returns YES if self.gradient is not nil
@property (readonly) BOOL isGradient;

// initialiasers
- (id)initWithColor:(NSColor *)color;
- (id)initWithGradient:(NSGradient *)gradient;

// convenience class methods to create default decorations
// look at their implementations in the .m for the details of the decoration they describe
+ (JSButtonDecoration *)recessedDecoration;
+ (JSButtonDecoration *)mouseOverDecoration;
+ (JSButtonDecoration *)highlightDecoration;

@end
