//
//  JSOperatorViewController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSSectionViewController.h"
#import "JSSyntaxHighlighter.h"

@class JSOperatorStack;

@interface JSOperatorViewController : JSSectionViewController <JSSyntaxHighlighterDelegate>

- (id)initWithOperator:(JSOperatorStack *)operators;

@end
