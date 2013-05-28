//
//  JSFlexibleButtonCell.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 28/10/12.
//
//

// The JSFlexibleButtonCell is can display a binary image and it applies several styles to the image depending on its state. It can also track mouseOver events

#import <Cocoa/Cocoa.h>

@class JSButtonStyle;

@interface JSFlexibleButtonCell : NSButtonCell

// this property is updated by the control of the cell and decides the look of the cell
@property (nonatomic) BOOL isMouseOver;

// look of the cell
@property (nonatomic, strong) JSButtonStyle *style;

@end
