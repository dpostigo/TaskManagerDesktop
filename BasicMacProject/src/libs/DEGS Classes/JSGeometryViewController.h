//
//  JSGeometryViewController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSSectionViewController.h"

@class JSGeometry;

@interface JSGeometryViewController : JSSectionViewController

- (id)initWithGeometry:(JSGeometry *)geometry;

@end
