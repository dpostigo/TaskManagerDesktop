//
//  JSOperatorsViewController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSSectionViewController.h"
#import "JSSyntaxHighlighter.h"

@class JSOperatorsStack;

@interface JSOperatorsViewController : JSSectionViewController <JSSyntaxHighlighterDelegate>

- (id)initWithOperators:(JSOperatorsStack *)operators;

@end
