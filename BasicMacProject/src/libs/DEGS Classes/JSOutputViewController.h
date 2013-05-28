//
//  JSOutputViewController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 16/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSSectionViewController.h"
#import "JSSyntaxHighlighter.h"

@class JSOutput;

@interface JSOutputViewController : JSSectionViewController <JSSyntaxHighlighterDelegate, NSPopoverDelegate>

- (id)initWithOutput:(JSOutput *)output;

@end
