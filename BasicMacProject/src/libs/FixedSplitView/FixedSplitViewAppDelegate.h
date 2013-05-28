//
//  OldAppDelegate.h
//  ColumnSplitView
//
//  Created by Matt Gallagher on 2009/09/01.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PrioritySplitViewDelegate;

@interface FixedSplitViewAppDelegate : NSObject
{
	IBOutlet NSSplitView *splitView;
	PrioritySplitViewDelegate *splitViewDelegate;
	IBOutlet NSWindow *mainWindow;

}

@end
