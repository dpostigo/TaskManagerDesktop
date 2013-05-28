//
//  JSColorfulTextField.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 27/02/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSExpandingTextField.h"

@class JSSyntaxHighlighter;

@interface JSColorfulTextField : JSExpandingTextField

// we get assigned a syntaxHighlighter. If the reference is nil the control behaves like a normal JSExpandingTextField
@property (nonatomic, weak) JSSyntaxHighlighter *syntaxHighlighter;

@end
