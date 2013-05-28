//
//  JSPreambleViewController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// The table view needs to know the height of the cell before calling tableView:viewForTableColumn:row: and layout the cell.
// Unfortunately in a table view where cells have dynamic height we need the cell first, then fill it and then compute the height.
// We circumvent the problem by keeping a copy of each kind of cell (the dummy cells), fill them with the content from the model in the tableView:heightOfRow: method and compute their height from their fittingSize

#import "JSPreambleViewController.h"
#import "JSPreamble.h"
#import "JSPreambleTableCellView.h"

@interface JSPreambleViewController()

// the model for this section view controller
@property (nonatomic, strong) JSPreamble *preamble;

// The dummy cell is used to compute the height of the cell at runtime
@property (nonatomic, strong) JSPreambleTableCellView *dummyCell;

@end

@implementation JSPreambleViewController

#pragma mark - Setter and getters

// The dummyCell is used to compute the height of the cell at runtime
// The width constraint, inhereited from JSTableCellView, is set to an initial arbitrary value of 500.0
- (JSPreambleTableCellView *)dummyCell
{
    if (!_dummyCell) {
        _dummyCell = [self.mainTableView makeViewWithIdentifier:@"preambleCell" owner:self];
        _dummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_dummyCell
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0f
                                                         constant:500.0f];
        [_dummyCell addConstraint:_dummyCell.widthConstraint];
    }
    return _dummyCell;
}

- (void)resizeDummyCell
{
    // we set the cell width constraint
    [self.dummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    // we layout its subviews so that they know their width and they can compute their height correctly
    [self.dummyCell layoutSubtreeIfNeeded];
}

- (id)representedObject
{
    return self.preamble;
}

- (void)setRepresentedObject:(id)representedObject
{
    if ([representedObject isKindOfClass:[JSPreamble class]]) self.preamble = representedObject;
}

# pragma mark - Initialiser and dealloc

// Simplified initialiser that knows the name of its xib file
- (id)initWithPreamble:(JSPreamble *)preamble
{
    self = [super initWithNibName:@"JSPreambleViewController" bundle:nil];
    if (self) {
        self.preamble = preamble;
        self.biasCells = 1;
    }
    return self;
}

- (void)viewDidAppear
{
    // set the appeareance of the left group of buttons in the bottom bar
    // we can't add or delete any element in this section
    [self.treeController.bottomBar enableDeleteButton:NO];
    [self.treeController.bottomBar enableNewButton:NO];
    [self.treeController.bottomBar setNewLabel:@"New"];
    [self.treeController.bottomBar showBackButton:NO withAnimation:YES];
}

#pragma mark - Data source and delegate of the table view

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 1;
}

- (void)fillCell:(JSPreambleTableCellView *)cell
{
    if (self.preamble.name) cell.nameTextField.stringValue = self.preamble.name;
    if (self.preamble.author) cell.authorTextField.stringValue = self.preamble.author;
    if (self.preamble.scriptDescription) cell.descriptionTextField.stringValue = self.preamble.scriptDescription;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    JSPreambleTableCellView *cellView = [tableView makeViewWithIdentifier:@"preambleCell" owner:self];
    [self fillCell:cellView];
    
    // NSTextField ends editing when return is pressed. keepsEditingOnReturn is a property of JSExpandingTextField that prevent the textField from end editing when return is pressed
    cellView.descriptionTextField.keepsEditingOnReturn = YES;
    
    return cellView;
}

// Each cell has a constraint on their width. When we compute the height of the cell we
// 1) fill the dummy cell with the model
// 2) call the method resizseDummyCells. This method set the constant on the width constraint and layout the subviews of the cell if needed. In this way all the subviews (the textFields and tokenFields mostly) of the cell can correctly compute their width because they know their width.
// 3) return the fitting size of the dummy cell
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    [self fillCell:self.dummyCell];
    [self resizeDummyCell];
    return [self.dummyCell fittingSize].height;
}

#pragma mark - Editing methods

// textFields delegate method. When a textField is edited this method will save the content of the textField to the appropriate property of the model
// we use the key-value pattern to set the properties of the model
// the identifiers of the textFields correspond to the key of the model that they set
- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *sender = [obj object];
    NSString *enteredString = [sender.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *senderIdentifier = [sender identifier];
    
    // we assign a meaning to value only if the user entered a string
    // in this way if the user delete the string in the textField we actually set the property of the model to nil
    id value = nil;
    if ([enteredString length]) value = enteredString;
    
    [self.preamble setValue:value forKeyPath:senderIdentifier];
}

# pragma mark - Section identifier

// the title of the view controller is used by JSDocument to retrive the path of the currentt view controller and display it in the pathBar
- (NSString *)title
{
    return self.preamble.description;
}

// the sectionSuffix is requested by JSDocument and passed to the app delegate to compose the address of the help page and open it
- (NSString *)sectionSuffix
{
    return @"nameelement";
}

@end
