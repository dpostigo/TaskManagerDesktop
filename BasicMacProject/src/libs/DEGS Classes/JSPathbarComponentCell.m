//
//  JSPathbarComponentCell.m
//  JSPathbar

#import "JSPathbarComponentCell.h"

#define TOP_BOTTOM_BARS_TEXTCOLOR [NSColor colorWithCalibratedWhite:0.17f alpha:1.0f]
#define PATHBAR_SIZE_XOFFSET 22.0f

@implementation JSPathbarComponentCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self setTextColor:TOP_BOTTOM_BARS_TEXTCOLOR];
    [super drawInteriorWithFrame:cellFrame inView:controlView];
    
    NSImage *rightArrow;
    
    rightArrow = [NSImage imageNamed:@"Separator"];
    
    NSRect rightArrowRect = NSMakeRect(cellFrame.origin.x + cellFrame.size.width - rightArrow.size.width, 0, rightArrow.size.width, cellFrame.size.height);
    [rightArrow drawInRect:rightArrowRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self drawInteriorWithFrame:cellFrame inView:controlView];
}

- (NSRect)titleRectForBounds:(NSRect)theRect
{
    NSRect titleFrame = [super titleRectForBounds:theRect];
    NSSize titleSize = [[self attributedStringValue] size];
    titleFrame.origin.y = theRect.origin.y + (theRect.size.height - titleSize.height) / 2.0;
    return titleFrame;
}

- (NSSize)cellSize
{
    // The horizontal size of the cell is computed from the size of the title plus an offest defined in the visual constant
    
    NSSize size = [[self attributedStringValue] size];
    size.height = 40000;
    size.width += PATHBAR_SIZE_XOFFSET;
    return size;
}

@end
