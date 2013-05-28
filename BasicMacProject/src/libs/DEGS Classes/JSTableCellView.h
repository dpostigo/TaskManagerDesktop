//
//  JSTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 10/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define LEFT_RECT_WIDTH 125.0f // this is the width of the grey part of the cell
#define INSETX 16.0f
#define END_OF_LEFT_RECT LEFT_RECT_WIDTH + 0.5 * INSETX // this is the position of the vertical line dividing the grey area from the rest
#define OFFSET_FROM_EDGE 10.0 // distance of the controls from the above line (this is applied to both the controls on the right and on the left)
#define SPACE_FROM_RIGHT_EDGE 20.0
#define SPACE_FROM_TOP_EDGE 8.0
#define SPACE_FROM_BOTTOM_EDGE 8.0
#define SPACE_BETWEEN_CONTROLS 5.0 // vertical spacing between the controls
#define CHECKBOX_OFFSET 15.0 // spacing of checkboxes from the divider line
// specific dimensions and layout values for the cells
#define SPACING_OF_DOMAIN_GROUP 3.0f
#define DOMAIN_TEXTFIELD_WIDTH 70.0f

// width of the subsection buttons
#define SUBSECTION_BUTTONS_WIDTH 60.0f

// utility macros
#define MACRO_VALUE_TO_STRING_( m ) #m
#define MACRO_VALUE_TO_STRING( m ) MACRO_VALUE_TO_STRING_( m )

@protocol JSTableCellViewDelegate <NSObject>

@optional

// inform the delegate that the state of the cell has changed so that it can recompute our preferred height
- (void)tableCellDidChangeUIState:(id)sender;

@end

@interface JSTableCellView : NSView

// width constraint to force the width of the cell and of its subview to a value. The subviews of the cell will then know their width and they can compute their preferred height
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

// this property provides an address suffix that is used to show the help page for a prticular cell
@property (readonly) NSString *cellHelpIdentifier;

@end
