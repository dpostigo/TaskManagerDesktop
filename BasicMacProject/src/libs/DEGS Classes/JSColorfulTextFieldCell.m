//
//  JSColorfulTextFieldCell.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 10/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSColorfulTextFieldCell.h"

@implementation JSColorfulTextFieldCell

// editing is starting and we want to pass the colored attrbiuted string to the field editor not the plain NSString
- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj
{
    NSTextView *fieldEditor = (NSTextView *)[super setUpFieldEditorAttributes:textObj];
    [[fieldEditor textStorage] setAttributedString:self.attributedStringValue];
    return fieldEditor;
}

// This is the method that gets called when the user presses the esc key and prevents the control from stripping the string from its attributes when editing ends
- (void)endEditing:(NSText *)textObj
{    
    NSTextView *fieldEditor = (NSTextView *)textObj;
    
    // Once we call endEditing: on super the string on the field editor might be emptied hence we want to hold onto it with a copy
    NSAttributedString *stringToCopy = [[fieldEditor textStorage] copy];
    
    [super endEditing:textObj];
    
    // We use the super implementation so that we can bypass the recoloring happening when we use the local implementation
    [self setAttributedStringValue:stringToCopy];
}

@end
