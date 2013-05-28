//
//  JSExpandingTextField.m
//  ExpandingTextField
//
//  Created by Jacopo Sabbatini on 27/12/12.
//  Copyright (c) 2012 Jacopo Sabbatini. All rights reserved.
//

#import "JSExpandingTextField.h"

#define FIELD_EDITOR_PADDING 5.0
#define TEXT_EDITOR_INSET 4.0
#define LINE_FRAGMENT_PADDING 2.0

@implementation JSExpandingTextField

@dynamic delegate;

// the height and the intrinsicContentSize of the control is based on its width so we need to invalidate the intrinsic content size every time our width change. This will force the layout system to recompute the intrinsic constraints for the control
- (void)setFrame:(NSRect)frameRect
{
    if (self.frame.size.width != frameRect.size.width) [self invalidateIntrinsicContentSize];
    [super setFrame:frameRect];
}

// in order to compute the height of the control we instantiate a layout manager, set its key properties and ask it for the height of the text given the width
- (NSSize)sizeFromLayoutManager
{
    NSSize textContainerSize = self.frame.size;
    textContainerSize.width -= TEXT_EDITOR_INSET;
    textContainerSize.height = 10000000;
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:textContainerSize];
    
    // if the TextField has no text then it's height is slightly smaller so we pass it the placeholder string to the text storage in the case there is no string from the text field
    NSAttributedString *stringToMeasure = [[self cell] placeholderAttributedString];
    if ([self.attributedStringValue length]!=0) stringToMeasure = self.attributedStringValue;
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:stringToMeasure];
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textContainer setLineFragmentPadding:LINE_FRAGMENT_PADDING];
    [layoutManager setTypesetterBehavior:NSTypesetterBehavior_10_2_WithCompatibility];
    [layoutManager glyphRangeForTextContainer:textContainer];
    NSSize newSize = [layoutManager usedRectForTextContainer:textContainer].size;
    newSize.height += FIELD_EDITOR_PADDING;
    
    return newSize;
}

- (NSSize)sizeToFitContent
{
    float width = [self frame].size.width;
    float height = 0.0;
    
    height = [self sizeFromLayoutManager].height;
    
    return NSMakeSize(width, height);
}

- (void)textDidChange:(NSNotification *)aNotification
{
    [super textDidChange:aNotification];
    
    NSSize newSize = [self sizeToFitContent];
    if (newSize.height != self.frame.size.height) {
        [self invalidateIntrinsicContentSize];
        if ([self.delegate respondsToSelector:@selector(textFieldDidResize:)]) [self.delegate textFieldDidResize:self];
    }
}

- (NSSize)intrinsicContentSize
{
    if ( ![self.cell wraps] ) {
        return [super intrinsicContentSize];
    }
    return [self sizeToFitContent];
}

// in order to deny the end editing on return we intercept the textView:doCommandBySelctor: editing method sent by the field editor
- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector
{
    BOOL result = NO;
    
    if (aSelector == @selector(insertNewline:) && _keepsEditingOnReturn )
    {
        // new line action:
        // always insert a line-break character and don’t cause the receiver to end editing
        [aTextView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    }
    
    return result;
}

@end
