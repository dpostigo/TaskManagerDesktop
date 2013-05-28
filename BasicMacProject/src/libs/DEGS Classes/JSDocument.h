//
//  JSDocument.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 19/02/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSSideBar.h"
#import "JSTreeController.h"

// TODO: add the operators to the syntax highlighter

// The document window is composed of a sideBar on the left. The contentView is the core of the app that host the view controllers of the various sections and slide their views in and out as we move through the sections. The bottomBar host the buttons for adding or deleting elements and for moving back in the tree of view controllers representing the sections.

// The sideBar host the buttons representing the main sections of an XMDS script and has a delegate method informing us that the current selection of those buttons has changed so that we can load and put on screen the appropriate view controller.

@interface JSDocument : NSDocument <JSSideBarDelegate, JSTreeControllerDelegate>

// side view that allows the user to switch section
@property (strong) IBOutlet JSSideBar *sideBar;

// tree controller
@property (nonatomic, strong) JSTreeController *treeController;

// compile the open document and handles eventual errors
- (IBAction)compileScript:(id)sender;

// run the compiled executable of the open document
- (IBAction)runScript:(id)sender;

// process the output of the script execution
- (IBAction)processOutputOfScript:(id)sender;

@end
