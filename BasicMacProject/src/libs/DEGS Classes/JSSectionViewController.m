//
//  JSSectionViewController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/08/12.
//
//

#import "JSSectionViewController.h"
#import "JSBinaryTableRowView.h"
#import "JSAppDelegate.h"
#import "JSTableCellView.h"

NSString *JSTableViewDidResizeNotification = @"JSTableViewDidResizeNotification";

@implementation JSSectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        // The table view has cells with heights that depends on their content. The height of some of the content (textFields and tokenFields) depends on the width of the cells so we want to be notified every time the table view is resized so that we can adjust the height of the cells if necessary
        // See JSPreambleViewController.m for a more detailed explanation of the 
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewDidResize:)
                                                     name:JSTableViewDidResizeNotification
                                                   object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidChangeFrame:) name:NSViewFrameDidChangeNotification object:self.mainTableView];
    
    [self.mainTableView registerForDraggedTypes:[NSArray arrayWithObject:SectionTableViewDataType]];
    
    [self.mainTableView setFloatsGroupRows:NO];
 
    // set up the constarints between the scroll view containing the table view and the view controller view
    NSView *tableView = [self.mainTableView enclosingScrollView];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(tableView);
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|" options:0 metrics:nil views:viewDict]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:viewDict]];
    
    // set up the double action method for the cells that will show the help for that cell
    [self.mainTableView setTarget:self];
    [self.mainTableView setDoubleAction:@selector(doubleAction:)];
    
    // make sure that the table view is scrolled to the top
    [self.mainTableView scrollRowToVisible:0];
}

# pragma mark - table view delegate

- (void)tableViewColumnDidResize:(NSNotification *)aNotification
{
    NSTableView *aTableView = aNotification.object;
    if (aTableView == self.mainTableView) {
        // coalesce all column resize notifications into one -- calls viewDidResize: below
        NSNotification *repostNotification = [NSNotification notificationWithName:JSTableViewDidResizeNotification object:self];
        [[NSNotificationQueue defaultQueue] enqueueNotification:repostNotification postingStyle:NSPostWhenIdle];
    }
    [self.mainTableView scrollRowToVisible:[self.mainTableView selectedRow]];
}

// common methods to set up the behaviour and look of the table view
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    return YES;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    return NO;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSInteger selectedRow = [self.mainTableView selectedRow];
    // if the selected cell is greater than biasCells it means that the cell is not a fixed cell and it can be deleted
    if (selectedRow>=self.biasCells) [self.treeController.bottomBar enableDeleteButton:YES]; else [self.treeController.bottomBar enableDeleteButton:NO];
    [self.mainTableView scrollRowToVisible:selectedRow];
}

# pragma mark - view resizing method that triggers the tableview to redraw its cells

- (void)viewDidResize:(NSNotification *)notification
{
    // update the height of the cells in response to a resize
    if ([self.mainTableView numberOfRows])
        [self.mainTableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.mainTableView numberOfRows])]];
}

# pragma mark - cell delegate method for change of state and redraw

// delegate method of JSTableCellView
// we respond to change in the state of a cell by recomputing its height
- (void)tableCellDidChangeUIState:(id)sender
{
    NSTableCellView *cellView = (NSTableCellView *)sender;
    NSUInteger editedRow = [self.mainTableView rowForView:cellView];
    [self.mainTableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:editedRow]];
}

# pragma mark - Textfield and token field resize delegate method

// delegate method of JSExpandingTextField
// we respond to change in the size by recomputing the height of the cell it's in
- (void)textFieldDidResize:(id)sender
{
    NSTextField *resizedTextField = sender;
    NSUInteger editedRow = [self.mainTableView rowForView:resizedTextField];
    [self.mainTableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:editedRow]];
}

// delegate method of JSTokenField
// we respond to change in the size by recomputing the height of the cell it's in
- (void)tokenFieldDidResize:(id)sender
{
    NSTokenField *resizedTokenField = sender;
    NSUInteger editedRow = [self.mainTableView rowForView:resizedTokenField];
    [self.mainTableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:editedRow]];
}

# pragma mark - Control editing delegate method

// when a JSTextField began editing we want to make its cell the selected cell
- (void)textFieldDidBecomeFirstResponder:(NSNotification *)aNotification
{
    [self updateSelectedRowToOwnerOf:[aNotification object]];
}

- (void)tokenFieldDidBecomeFirstResponder:(NSNotification *)aNotification
{
    [self updateSelectedRowToOwnerOf:[aNotification object]];
}

- (void)updateSelectedRowToOwnerOf:(NSControl *)sender
{
    NSInteger row = [self.mainTableView rowForView:sender];
    if (row != [self.mainTableView selectedRow]) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
}

# pragma mark - table view delegate method

// tableView delegate method to provide views for the rows
- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    JSBinaryTableRowView *rowView = [[JSBinaryTableRowView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    return rowView;
}

# pragma mark - cell help method

- (void)doubleAction:(id)sender
{
    // we grab the modifier to the event to check that the user double clicked the cell while holding the command key
    BOOL commandKeyDown = (([[NSApp currentEvent] modifierFlags] & NSCommandKeyMask) == NSCommandKeyMask);
    NSInteger clickedRow = self.mainTableView.clickedRow;
    if (commandKeyDown) {
        JSTableCellView *cellView = (JSTableCellView *)[self.mainTableView viewAtColumn:0 row:clickedRow makeIfNecessary:NO];
        
        // we ask the app delegate to show the help with the suffix address coming from the clicked cell (cellHelpIdentifier)
        NSString *elementIdentifier = cellView.cellHelpIdentifier;
        [(JSAppDelegate *)[[NSApplication sharedApplication] delegate] showHelpPageForElementWithName:elementIdentifier];
    }
}

# pragma mark - Elements management

- (void)addElement:(id)sender
{
    return;
}

- (void)deleteElement:(id)sender
{
    return;
}

- (void)insertNewRowInMainTable
{
    NSUInteger lastRow = self.mainTableView.numberOfRows;
    [self.mainTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:lastRow] withAnimation:NSTableViewAnimationEffectFade];
    [self.mainTableView editColumn:0 row:lastRow withEvent:nil select:YES];
}

# pragma mark - notification methods

- (void)viewDidAppear
{
    return;
}

// when the table view resize the height of the cells might change so we want to keep the selected cell on screen
-(void)tableViewDidChangeFrame:(id)sender
{
    if (self.mainTableView.selectedRow >= 0) [self.mainTableView scrollRowToVisible:self.mainTableView.selectedRow];
}

# pragma mark - Dragging methods

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pasteboard
{
    NSMutableIndexSet *draggedRows = [rowIndexes mutableCopy];
    [draggedRows shiftIndexesStartingAtIndex:0 by:-self.biasCells];
    // bias cells cannot be dragged hence we validate the action only if non of them is part of rowIndexes
    if ([draggedRows count]) {
        // Copy the row numbers to the pasteboard.
        NSData *indexSetData = [NSKeyedArchiver archivedDataWithRootObject:[draggedRows copy]];
        [pasteboard declareTypes:[NSArray arrayWithObject:SectionTableViewDataType] owner:self];
        [pasteboard setData:indexSetData forType:SectionTableViewDataType];
        return YES;
    }
    return NO;
}

- (NSDragOperation)tableView:(NSTableView*)tableView validateDrop:(id)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
    if (operation == NSTableViewDropOn) return NSDragOperationNone;
    if (row < self.biasCells) return NSDragOperationNone;
    return NSDragOperationMove;
}

@end
