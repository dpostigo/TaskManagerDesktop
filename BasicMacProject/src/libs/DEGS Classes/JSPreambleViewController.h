//
//  JSPreambleViewController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// TODO: Insert gradient as background of the preambleView

#import <Cocoa/Cocoa.h>
#import "JSSectionViewController.h"

@class JSPreamble;

@interface JSPreambleViewController : JSSectionViewController

// designated initialiser
// Preamble must be specified at initialisation
- (id)initWithPreamble:(JSPreamble *)preamble;

@end
