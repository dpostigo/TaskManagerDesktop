//
//  JSTextField.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 5/04/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const JSTextFieldDidBecomeFirstResponderNotification;

@protocol JSTextFieldDelegate <NSTextFieldDelegate>

// We notify our delegate that we became first responder (used for scrolling cells to visible when the user tab between textfields)
- (void)textFieldDidBecomeFirstResponder:(NSNotification *)aNotification;

@end

@interface JSTextField : NSTextField

@property (nonatomic,weak) id <JSTextFieldDelegate> delegate;

@end
