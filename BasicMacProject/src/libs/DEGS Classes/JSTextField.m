//
//  JSTextField.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 5/04/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSTextField.h"

NSString * const JSTextFieldDidBecomeFirstResponderNotification = @"JSTextFieldDidBecomeFirstResponderNotification";

@implementation JSTextField

@dynamic delegate;

- (BOOL)becomeFirstResponder;
{
    // If the control's delegate responds to controlDidBecomeFirstResponder, invoke it. Also post a notification.
    BOOL didBecomeFirstResponder = [super becomeFirstResponder];
    NSNotification *notification = [NSNotification notificationWithName:JSTextFieldDidBecomeFirstResponderNotification object:self];
    if ( [self delegate] && [[self delegate] respondsToSelector:@selector(textFieldDidBecomeFirstResponder:)] ) {
        [[self delegate] textFieldDidBecomeFirstResponder:notification];
    }
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    return didBecomeFirstResponder;
}

@end
