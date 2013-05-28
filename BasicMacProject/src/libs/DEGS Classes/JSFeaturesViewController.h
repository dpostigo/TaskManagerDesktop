//
//  JSFeaturesViewController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSSectionViewController.h"
#import "JSSyntaxHighlighter.h"

@class JSFeatures, JSDriver;

@interface JSFeaturesViewController : JSSectionViewController <JSSyntaxHighlighterDelegate>

// designated initialiser
- (id)initWithFeatures:(JSFeatures *)features driver:(JSDriver *)driver;

@end
