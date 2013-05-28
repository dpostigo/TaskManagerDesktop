//
//  JSFiltersViewController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSSectionViewController.h"
#import "JSSyntaxHighlighter.h"

@class JSFilters;

@interface JSFiltersViewController : JSSectionViewController <JSSyntaxHighlighterDelegate>

- (id)initWithFilters:(JSFilters *)filters;

@end
