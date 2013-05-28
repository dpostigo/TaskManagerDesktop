//
//  JSSectionViewController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/08/12.
//
//

// Super class of the view controllers for the various sections to handle common methods
// JSSectionViewController is the delegate of the bottomBar in order to handle messages for clicks on the left group of buttons (back, add, delete)
// The view controller also manages the enable and show state of these buttons through the property bottomBar

// JSPreambleViewController is a prototype of the behaviour of the section view controller. Most of the comments about the behaviour of the section view controller can be found there. The other view controller have comments only on differing methods from JSPreambleViewController

// Comments about the protoype behaviour of cells with layout that depends on state can be found in the driver cell class (JSDriverTableCellView)

#import <Cocoa/Cocoa.h>
#import "JSTreeController.h"

// drag object type
#define SectionTableViewDataType @"SectionTableViewDataType"

@interface JSSectionViewController : NSViewController

// Designated initialiser
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

// Table view present in any of the section view controller
@property (strong) IBOutlet NSTableView *mainTableView;

// reference to the tree controller so that we can talk to it and manage the states of the bottom bar and various other things
@property (nonatomic, strong) JSTreeController *treeController;

// some sections need to display some fixed cells
// biasCells is the number of these fixed cells
@property NSInteger biasCells;

// the sectionSuffix is the suffix of the address for the help page of the section.
// This is called by JSDocument to respond to clicks of the help button. It retrieves the "suffix"-address of the current section and pass it to the app delegate that shows the appropriate help page.
@property (readonly) NSString *sectionSuffix;

// Convenience method that select a row owning a specific control
- (void)updateSelectedRowToOwnerOf:(NSControl *)sender;

// placeholder methods overriden by subclasses to implement the addition and deletion of elements
// their implementation in JSSectionViewController do nothing
-(void)addElement:(id)sender;
-(void)deleteElement:(id)sender;

// insert a new row in the main table view, start editing it and scroll to it
- (void)insertNewRowInMainTable;

// notify the view controller that its view was put on screen so that it can personalise
// the defualt implementation in JSSectionViewController does nothing
- (void)viewDidAppear;

@end
