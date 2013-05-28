//
//  JSTokenField.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 6/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const JSTokenFieldDidBecomeFirstResponderNotification;

@class JSTokenField;

@protocol JSTokenFieldDelegate <NSTextFieldDelegate>

// inform the delegate that the control's preferred height has changed
- (void)tokenFieldDidResize:(id)sender;

// inform the delegate that one of the tokens has been deleted.
// This method is missing from the NSTokenField API for some reason.
- (void)tokenFieldDidRemoveTokens:(id)sender;

// This method is slightly different from the normal NSTokenField delegate methods in the sense that it adds the empty token only after the delegate method returns YES. Unlike the tokenField:shouldAddObjects:atIndex: that adds the tokens before calling the delegate method
// FIXME: do we want to fix this behaviour?
- (BOOL)tokenField:(JSTokenField *)tokenField shouldAddEmptyTokenAtIndex:(NSUInteger)index;

// We notify our delegate that we became first responder so that someone could put up a hint for example
- (void)tokenFieldDidBecomeFirstResponder:(NSNotification *)aNotification;

@end

@interface JSTokenField : NSTokenField

// do we want the tokenField to handle empty tokens (empty strings)?
// this might be useful in the case where we need the tokens in the objectValue property of the tokenField to be empty strings
@property (nonatomic) BOOL allowsEmptyTokens;

@property (nonatomic,weak) id <JSTokenFieldDelegate> delegate;

@end
