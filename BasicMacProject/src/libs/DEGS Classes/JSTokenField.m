//
//  JSTokenField.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 6/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSTokenField.h"

NSString * const JSTokenFieldDidBecomeFirstResponderNotification = @"JSTokenFieldDidBecomeFirstResponderNotification";

// constants to determine the preferred size of the token field
#define TOKENS_SPACING 7.0f
#define TOKENS_ROUNDED_BOUNDS_WIDTH 34.0f
#define TOKENS_VERTICAL_SPACING 2.0f

@interface JSTokenField ()

// this is a uitlity property that helps us track when a token is deleted
@property NSUInteger previousNumberOfTokens;

@end

@implementation JSTokenField

// we extended the delegate protocol of NSTokenField but we want to use the super ivar for the delegate
@dynamic delegate;

// the preferred height for the control is based on its width. Invalidating the intrinsicContentSize when the width changes forces the layout system to recompute the intrinsic size constraints
- (void)setFrame:(NSRect)frameRect
{
    if (self.frame.size.width != frameRect.size.width) [self invalidateIntrinsicContentSize];
    [super setFrame:frameRect];
}

- (void)setObjectValue:(id<NSCopying>)obj
{
    [super setObjectValue:obj];
    self.previousNumberOfTokens = [[self objectValue] count];
}


- (CGFloat)preferredHeightForWidth:(CGFloat)width
{
    // get the tokens
    NSArray *tokens = [self objectValue];
    
    // The height of a token is initialised from a test string. This is also the height of a line in the tokenField
    // this variable is updated in the loop through the tokens if we find any taller token
    CGFloat maxRowHeight = [@"testString" boundingRectWithSize:NSMakeSize(1000.0,1000.0) options:0 attributes:nil].size.height;
    
    //Loop through tokens and increment the line count every time we break the boundaries
    int rows = 1;
    int index = 0;
	while (index < [tokens count]) {
		float x = TOKENS_SPACING;
		while (x < width) {
            NSString *token = [tokens objectAtIndex:index];
            NSRect tokenRect = [token boundingRectWithSize:NSMakeSize(1000.0, 1000.0) options:0 attributes:nil];
            tokenRect.size.width += TOKENS_ROUNDED_BOUNDS_WIDTH;
            
			x += tokenRect.size.width + TOKENS_SPACING;
            
            if (tokenRect.size.height > maxRowHeight) maxRowHeight = tokenRect.size.height;
			
            //If this button puts us over the width of the view then break and move to the next line, if the button's bounding rect is greater than the size of the view then draw anyway and trim.
			if (x > width && tokenRect.size.width + TOKENS_SPACING < width) {
				rows++;
				break;
			}
			index++;
			if (index >= [tokens count]) break;
		}
	}
    // add the spacing between lines
    maxRowHeight += TOKENS_VERTICAL_SPACING;
    
    return rows*maxRowHeight;
}

- (NSSize)sizeToFitContent
{
    float width = [self frame].size.width;
    float height = 0.0;
    
    height = [self preferredHeightForWidth:width];
    
    return NSMakeSize(width, height);
}

- (void)textDidChange:(NSNotification *)aNotification
{
    [super textDidChange:aNotification];
    
    // check if any token has been deleted and if so inform the delegate
    NSUInteger currentNumberOfTokens = [[self objectValue] count];
    if (currentNumberOfTokens < self.previousNumberOfTokens) {
        if ([self.delegate respondsToSelector:@selector(tokenFieldDidRemoveTokens:)]) [self.delegate tokenFieldDidRemoveTokens:self];
        _previousNumberOfTokens = currentNumberOfTokens;
    }
    if (currentNumberOfTokens > self.previousNumberOfTokens) _previousNumberOfTokens = currentNumberOfTokens;
 
    // recompute the preferred size
    NSSize newSize = [self sizeToFitContent];
    if (newSize.height != self.frame.size.height) {
        [self invalidateIntrinsicContentSize];
        if ([self.delegate respondsToSelector:@selector(tokenFieldDidResize:)]) [self.delegate tokenFieldDidResize:self];
    }
}

- (NSSize)intrinsicContentSize
{
    if ( ![self.cell wraps] ) {
        return [super intrinsicContentSize];
    }
    return [self sizeToFitContent];
}

- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector
{
    BOOL result = NO;
    
    NSEvent *event = [[NSApplication sharedApplication] currentEvent];
    
    // we use ctrl+space as keyboard shortcut for enetering empty tokens
    if ([event type] == NSKeyDown && [event keyCode] == 49 && ([event modifierFlags] & NSControlKeyMask) && _allowsEmptyTokens) {
        
        // we compute the insertion point by looping through the characters of the string from the begging to the current selection location and count the number of tokens represented in cocoa by the special character with code 65532
        NSUInteger index = 0;
        NSUInteger insertionPoint = [aTextView selectedRange].location;
        for (int i = 0; i < insertionPoint; i++) {
            if ([aTextView.string characterAtIndex:i] == 65532) index++;
        }
        
        // we then use the delegate method to ask wheter or not we should add the empty token at the insertion point
        BOOL shouldAddEmptyToken = YES;
        if ([self.delegate respondsToSelector:@selector(tokenField:shouldAddEmptyTokenAtIndex:)]) shouldAddEmptyToken = [self.delegate tokenField:self shouldAddEmptyTokenAtIndex:index];
        
        if (shouldAddEmptyToken) {
            // finally we add the empty token
            NSMutableArray *newTokens = [NSMutableArray array];
            if (self.objectValue) newTokens = [self.objectValue mutableCopy];
            [newTokens insertObject:@"" atIndex:index];
            self.objectValue = [newTokens copy];
        }
        
        result = YES;
    }
    
    return result;
}

// inform the delegate that we just became first responder so that it can put up tooltips, hints etc.
- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (result && [self.delegate respondsToSelector:@selector(tokenFieldDidBecomeFirstResponder:)]) {
        NSNotification *notification = [NSNotification notificationWithName:JSTokenFieldDidBecomeFirstResponderNotification object:self];
        [self.delegate tokenFieldDidBecomeFirstResponder:notification];
    }
    return result;
}


@end
