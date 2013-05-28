//
//  JSFlexibleButtonCell.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 28/10/12.
//
//

#import "JSFlexibleButtonCell.h"
#import "NSImage+JSAdditions.h"
#import "JSButtonStyle.h"

#define VERTICAL_INSET 3.0
#define HORIZONTAL_INSET 2.0

@interface JSFlexibleButtonCell() {
    NSRect _titleRect, _imageRect;
}

@end

@implementation JSFlexibleButtonCell

# pragma mark - Setter and getters

- (JSButtonStyle *)style
{
    if (!_style) {
        _style = [JSButtonStyle defaultDarkStyle];
    }
    return _style;
}

- (void)setTitle:(NSString *)aString
{
    [super setTitle:aString];
    [self colorTitle];
}

- (void)colorTitle
{
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
											initWithAttributedString:[self attributedTitle]];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    [attrTitle addAttribute:NSForegroundColorAttributeName
                      value:self.style.textColor
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
}

# pragma mark - Initialisers

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self setHighlightsBy:NSImageCellType];
		[self setImagePosition:NSImageAbove];
    }
    return self;
}

- (id)initImageCell:(NSImage *)anImage
{
    self = [super initImageCell:anImage];
    if (self) {
        [self setHighlightsBy:NSImageCellType];
		[self setImagePosition:NSImageAbove];
    }
    return self;
}

- (id)initTextCell:(NSString *)aString
{
    self = [super initTextCell:aString];
    if (self) {
        [self setHighlightsBy:NSImageCellType];
		[self setImagePosition:NSImageAbove];
    }
    return self;
}

// this method is going to use the NSImage category to draw the binary image with a particular style (color, shadow etc.)
- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView
{
    [NSGraphicsContext saveGraphicsState];
    NSAffineTransform* xform = [NSAffineTransform transform];
    
    // here we have to add the frame y origin for the case of drawing from a NSMatrix
    [xform translateXBy:0.0 yBy:frame.size.height+frame.origin.y];
    [xform scaleXBy:1.0 yBy:-1.0];
    // Same here
    [xform translateXBy:0.0 yBy:-frame.origin.y];
    [xform concat];
    
    
    // we first grab the decoration to apply to the image from our style depending on the cell state
    JSButtonDecoration *decoration;
    if (self.style.normalDecoration)
        decoration = self.style.normalDecoration;
    else
        decoration = [JSButtonDecoration recessedDecoration];
    
    if (self.isHighlighted) {
        if (self.style.highlightDecoration) decoration = self.style.highlightDecoration;
    } else if (self.isMouseOver) {
        if (self.style.mouseOverDecoration) decoration = self.style.mouseOverDecoration;
    } else if (self.state) {
        if (self.style.selectionDecoration) decoration = self.style.selectionDecoration;
    }
    
    CGFloat buttonAlpha;
    if (self.isEnabled) buttonAlpha = 1.0; else buttonAlpha = 0.5;
    
    // we then draw the image
    if (decoration.isGradient) {
        [image drawInRect:frame withGradient:decoration.gradient innerShadow:decoration.innerShadow dropShadow:decoration.dropShadow fraction:buttonAlpha];
    } else {
        [image drawInRect:frame withColor:decoration.color innerShadow:decoration.innerShadow dropShadow:decoration.dropShadow fraction:buttonAlpha];
    }
    
    [xform invert];
    [NSGraphicsContext restoreGraphicsState];
}

@end
