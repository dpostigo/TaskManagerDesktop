//
//  JSVectorViewController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSSectionViewController.h"
#import "JSSyntaxHighlighter.h"

@class JSVectors;

@interface JSVectorViewController : JSSectionViewController <JSSyntaxHighlighterDelegate>

- (id)initWithVectors:(JSVectors *)vectors;

@end
