//
//  JSColorfulTextField.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 27/02/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSColorfulTextField.h"
#import "JSSyntaxHighlighter.h"
#import "JSColorfulTextFieldCell.h"

@implementation JSColorfulTextField

// we use a custom cell to prevent the control from stripping the string off its attributes when editing starts or ends
+ (Class)cellClass
{
    return [JSColorfulTextFieldCell class];
}

// everytime someone changes the stringValue or the attributedStringValue of the control we want to recolor the neew string first
- (void)setStringValue:(NSString *)aString
{
    if (self.syntaxHighlighter) [super setAttributedStringValue:[self.syntaxHighlighter recolorString:aString]];
    else [super setStringValue:aString];
}

- (void)setAttributedStringValue:(NSAttributedString *)obj
{
    if (self.syntaxHighlighter) [super setAttributedStringValue:[self.syntaxHighlighter recolorString:[obj string]]];
    else [super setAttributedStringValue:obj];
}

- (BOOL)textShouldBeginEditing:(NSText *)textObject
{
    NSTextView *fieldEditor = (NSTextView *)textObject;
    // We register for the notifications from the textStorage in order to be able to process the edited part of the string (textStorage.editedRange)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processEditing:)
                                                 name:NSTextStorageDidProcessEditingNotification
                                               object:[fieldEditor textStorage]];
    return [super textShouldBeginEditing:textObject];
}

- (void)processEditing:(NSNotification*)notification
{
    if (self.syntaxHighlighter) {
        NSTextStorage *textStorage = [notification object];
        
        // the syntax highlighter is going to tell us which part needs to be recolored
        NSRange rangeToProcess = [self.syntaxHighlighter rangeToProcessChange:textStorage];
        
        if (rangeToProcess.location != NSNotFound) {
            NSAttributedString *coloredString = [self.syntaxHighlighter recolorString:textStorage forRange:rangeToProcess];
            [textStorage setAttributedString:coloredString];
        }
    }
}


- (BOOL)textShouldEndEditing:(NSText *)textObject
{
    BOOL shouldEndEditing = [super textShouldEndEditing:textObject];
    
    // If the user press enter or return we enter this method but we may want to keep editing so we don't remove ourselves as orbserver right away
    if (shouldEndEditing) {
        NSTextView *fieldEditor = (NSTextView *)textObject;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextStorageDidProcessEditingNotification object:[fieldEditor textStorage]];
    }
    
    return shouldEndEditing;
}

// This method gets called every time the user click outside the textfield or presses the tab key but not when he/she presses the esc key
- (void)textDidEndEditing:(NSNotification *)notification
{
    NSTextView *fieldEditor = (NSTextView *)[notification object];
    
    // Once we call the super textDidEndEditing: the string on the field editor is going to be emptied hence we want to hold onto it with a copy
    NSAttributedString *stringToCopy = [[fieldEditor textStorage] copy];
    
    // We want to call the super implementation in case it's going to erase the string from the fieldEditor and/or the textField
    [super textDidEndEditing:notification];
    
    // We use the super implementation so that we can bypass the recoloring happening when we use the local implementation
    [super setAttributedStringValue:stringToCopy];
}

@end
