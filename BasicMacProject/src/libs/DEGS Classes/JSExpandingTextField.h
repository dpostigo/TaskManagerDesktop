//
//  JSExpandingTextField.h
//  ExpandingTextField
//
//  Created by Jacopo Sabbatini on 27/12/12.
//  Copyright (c) 2012 Jacopo Sabbatini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSTextField.h"

@class JSExpandingTextField;

@protocol JSExpandingTextFieldDelegate <JSTextFieldDelegate>

// inform the delegate that the preferred height of the control has changed
- (void)textFieldDidResize:(id)sender;

@end

@interface JSExpandingTextField : JSTextField

// NStextField ends editing when return is pressed because textFields are supposed to be single line. Since we allow for multi-line textFields it makes sense to have return characters in the text of a textFields. When this property is YES we allow the user to enter return without ending the editing.
@property BOOL keepsEditingOnReturn;

@property (nonatomic,weak) id <JSExpandingTextFieldDelegate> delegate;

// utility method that returns the size of the control instantiating a layout manager.
- (NSSize)sizeFromLayoutManager;

@end
