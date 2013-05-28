//
//  JSOperatorViewController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSOperatorViewController.h"
#import "JSOperatorCellView.h"
#import "JSOperatorStack.h"
#import "JSOperator.h"

@interface JSOperatorViewController ()

@property (nonatomic, strong) JSSyntaxHighlighter *syntaxHighlighter;

@property (nonatomic, strong) JSOperatorStack *operators;

@property (nonatomic, strong) JSOperatorCellView *operatorDummyCell;

@end

@implementation JSOperatorViewController

#pragma mark - Setter and getters

// The dummy cells are used to compute the height of the cells at runtime

- (JSOperatorCellView *)operatorDummyCell
{
    if (!_operatorDummyCell) {
        _operatorDummyCell = [self.mainTableView makeViewWithIdentifier:@"operatorCell" owner:self];
        _operatorDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_operatorDummyCell
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:500.0f];
        [_operatorDummyCell addConstraint:_operatorDummyCell.widthConstraint];
    }
    return _operatorDummyCell;
}

- (void)resizeDummyCells
{
    [self.operatorDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.operatorDummyCell layoutSubtreeIfNeeded];
}

- (id)representedObject
{
    return self.operators;
}

- (void)setRepresentedObject:(id)representedObject
{
    if ([representedObject isKindOfClass:[JSOperatorStack class]]) self.operators = representedObject;
}

# pragma mark - init and destroy methods

- (id)initWithOperator:(JSOperatorStack *)operators
{
    self = [super initWithNibName:@"JSOperatorViewController" bundle:nil];
    if (self) {
        self.operators = operators;
        self.syntaxHighlighter = [[JSSyntaxHighlighter alloc] init];
        [self.syntaxHighlighter setDelegate:self];
        self.biasCells = 0;
    }
    return self;
}

-(void)dealloc
{
    if (self.syntaxHighlighter.delegate == self) self.syntaxHighlighter.delegate = nil;
}

- (void)viewDidAppear
{
    [self.treeController.bottomBar setNewLabel:@"New Operator"];
    [self.treeController.bottomBar enableNewButton:YES];
    if ([self.operators numberOfOperators]>0) [self.treeController.bottomBar enableDeleteButton:YES];
    [self.treeController.bottomBar showBackButton:YES withAnimation:YES];
}

#pragma mark - Data source and delegate of the table view

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.operators.numberOfOperators + self.biasCells;
}

- (void)fillOperatorCell:(JSOperatorCellView *)cellView atRow:(NSUInteger)row
{
    JSOperator *operator = (self.operators.operators)[row];
    if (operator.name) cellView.nameTextField.stringValue = operator.name;
    else cellView.nameTextField.stringValue = @"";
    
    [cellView.kindButton removeAllItems];
    [cellView.kindButton addItemsWithTitles:operator.kindOptions];
    [cellView.kindButton selectItemAtIndex:operator.kind];
    
    NSString *kindString = (operator.kindOptions)[operator.kind];
    if ([kindString isEqualToString:@"functions"]) [cellView setOperatorCellState:JSOperatorCellFunctionState];
    else [cellView setOperatorCellState:JSOperatorCellDifferentialState];
    
    [cellView.typeButton removeAllItems];
    [cellView.typeButton addItemsWithTitles:operator.typeOptions];
    [cellView.typeButton selectItemAtIndex:operator.type];
    
    cellView.constantCheckBox.state = operator.constant;
    
    [cellView.namesTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (operator.names) [cellView.namesTokenField setObjectValue:operator.names];
    else [cellView.namesTokenField setObjectValue:nil];
    
    if (operator.definition) cellView.definitionTextField.stringValue = operator.definition;
    else cellView.definitionTextField.stringValue = @"";
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    JSOperatorCellView *cellView = (JSOperatorCellView *)[tableView makeViewWithIdentifier:@"operatorCell" owner:self];
    cellView.definitionTextField.syntaxHighlighter = self.syntaxHighlighter;
    [self fillOperatorCell:cellView atRow:row];
    cellView.definitionTextField.keepsEditingOnReturn = YES;
    cellView.delegate = (id)self;
    return cellView;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    [self fillOperatorCell:self.operatorDummyCell atRow:row];
    [self resizeDummyCells];
    return [self.operatorDummyCell fittingSize].height;
}

#pragma mark - Methods to add or delete elements to the section

- (void)addElement:(id)sender
{
    JSOperator *newElement = [[JSOperator alloc] init];
    [self.operators addOperator:newElement];
    
    [self insertNewRowInMainTable];
}

-(void)deleteElement:(id)sender
{
    NSInteger row = [self.mainTableView selectedRow];
    [self.operators deleteOperatorAtIndex:row-self.biasCells];
    [self.mainTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
}

#pragma mark - Cell editing methods

// We use key value coding to assign changes in the various controls to the model
// The identifier of the controls are equal to the keyPath of the properties we want to set
- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *sender = [obj object];
    NSString *senderIdentifier = [sender identifier];
    
    // the entries in the token field gets handled in another method so we have to make sure we are only setting the properties we want here
    if ([senderIdentifier isEqualToString:@"name"] || [senderIdentifier isEqualToString:@"definition"]) {
        
        NSString *enteredString = [sender.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSInteger row = [self.mainTableView rowForView:sender];
        
        id value = nil;
        if ([enteredString length]) value = enteredString;
        
        id element = (self.operators.operators)[row];
        [element setValue:value forKeyPath:senderIdentifier];
    }
}

# pragma mark - check box method

- (IBAction)constantCheckedBoxPressed:(id)sender
{
    NSNumber *buttonState = @( [sender state] );
    NSInteger row = [self.mainTableView rowForView:sender];
    id element = (self.operators.operators)[row];
    [element setValue:buttonState forKey:[sender identifier]];
    if (row != [self.mainTableView selectedRow]) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
}

# pragma mark - Popup buttons method

- (IBAction)popUpButtonPressed:(id)sender
{
    NSInteger row = [self.mainTableView rowForView:sender];
    if (row != -1) {
        NSInteger selection = [sender indexOfSelectedItem];
        NSString *senderIdentifier = [sender identifier];
        
        id element = (self.operators.operators)[row];
        [element setValue:[NSNumber numberWithInteger:selection] forKeyPath:senderIdentifier];
        if ([senderIdentifier isEqualToString:@"kind"]) {
            NSString *kindString = [(JSOperator *)element kindOptions][selection];
            JSOperatorCellView *changedCell = [self.mainTableView viewAtColumn:0 row:row makeIfNecessary:NO];
            if ([kindString isEqualToString:@"functions"]) [changedCell setOperatorCellState:JSOperatorCellFunctionState];
            else [changedCell setOperatorCellState:JSOperatorCellDifferentialState];
        }
        if (row != [self.mainTableView selectedRow]) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}

#pragma mark - Tokenfields completion delegate method

- (NSArray *)tokenField:(NSTokenField *)tokenField shouldAddTokens:(NSArray *)tokens
{
    NSMutableArray *tokensToBeAdded = [NSMutableArray array];
    NSArray *currentTokens = [tokenField objectValue];
    // For some stupid reason when cocoa calls this method it has already added the candidate tokens to the toeknfield tokens list
    // For every token in the candidate list we count how many times it appears in the tokenfield tokens list and if it appears twice than it's a duplicate and we reject it
    for (NSString *candidateToken in tokens) {
        int appearance = 0;
        for (NSString *token in currentTokens) {
            if ([candidateToken isEqualToString:token]) appearance++;
        }
        if (appearance<2) [tokensToBeAdded addObject:candidateToken];
    }
    
    // if we have any valid token let's add it to the model
    if ([tokensToBeAdded count]) {
        // Let's add the new tokens to the appropriate fields
        NSInteger row = [self.mainTableView rowForView:tokenField];
        NSString *tokenFieldIdentifier = [tokenField identifier];
        
        id element = (self.operators.operators)[row];
        id value = [element valueForKeyPath:tokenFieldIdentifier];
        if (value) value = [(NSArray *)value arrayByAddingObjectsFromArray:tokensToBeAdded];
        else value = [tokensToBeAdded copy];
        [element setValue:value forKeyPath:tokenFieldIdentifier];
    }
    return [tokensToBeAdded copy];
}

- (NSArray *)tokenField:(NSTokenField *)tokenField shouldAddObjects:(NSArray *)tokens atIndex:(NSUInteger)index
{
    return [self tokenField:tokenField shouldAddTokens:tokens];
}

// This method is called by the token field when the tab key button is pressed
// this method is not called if I press the tokenizing character in the token field

// the control is the tokenField and at the moment of invocation the token has already been added
// object is the proposed token to be added
- (BOOL)control:(NSControl *)control isValidObject:(id)object
{
    // we want to make sure we were called by a token field and not just a textField
    if ([control isKindOfClass:[NSTokenField class]]) {
        
        // the NSMutableString passed as object has invisible characters as tokens
        // These characters are associated to the unsigned short 65532 which is out of bounds of the UTF range NSCharacterSet handles
        // These characters are called "Object Replacement Character"
        NSCharacterSet *characterset = [NSCharacterSet characterSetWithCharactersInString:@"\uFFFC"];
        NSString *tokenString = [(NSMutableString *)object stringByTrimmingCharactersInSet:characterset];
        if ([tokenString length]) {
            
            // object is passed as a mutable string so before handling it to our internal validation method we want to package it in an array
            // also the NSMutableString passed as object gets emptied after the insertion happen so we need to copy it
            NSArray *tokens = [NSArray arrayWithObject:tokenString];
            if ([[self tokenField:(NSTokenField *)control shouldAddTokens:tokens] count] == 0) return NO;
        }
    }
    return YES;
}

- (void)tokenFieldDidRemoveTokens:(id)sender
{
    JSTokenField *tokenField = (JSTokenField *)sender;
    NSInteger row = [self.mainTableView rowForView:tokenField];
    NSString *tokenFieldIdentifier = [tokenField identifier];
    
    id element = (self.operators.operators)[row];
    [element setValue:[tokenField objectValue] forKeyPath:tokenFieldIdentifier];
}

#pragma mark - Syntax highlighter delegate

-(NSArray *)userIdentifiersForKeywordComponentName:(NSString *)inModeName
{
    NSMutableArray *identifiers = [[self.operators.root listOfDimensionsIdentifiersForBasis] mutableCopy];
    [identifiers addObjectsFromArray:[self.operators.root listOfVectorComponentsIdentifiers]];
    [identifiers addObjectsFromArray:[self.operators.root listOfArgumentsIdentifiers]];
    return identifiers;
}

# pragma mark - Section title

- (NSString *)title
{
    return self.operators.description;
}

- (NSString *)sectionSuffix
{
    return @"operatorelement";
}

# pragma mark - Drop operation

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
    NSPasteboard *pasteboard = [info draggingPasteboard];
    NSData *rowData = [pasteboard dataForType:SectionTableViewDataType];
    NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    NSUInteger dropIndex = row - self.biasCells;
    
    // insertIndex is the index where we are going to insert back the data in the model array
    // dropIndex is the index at which the user chose to insert the data but that's before we remove the objects from the model array
    // we compute the new index by looping through the indexes of the dragged rows and decrease insertIndex for every dragged row that was above the drop index
    NSUInteger __block insertIndex = dropIndex;
    [rowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
        if (idx < dropIndex) insertIndex--;
    }];
    
    NSArray *draggedObjects = [self.operators.operators objectsAtIndexes:rowIndexes];
    [self.operators deleteOperatorsAtIndexes:rowIndexes];
    
    for (id draggedObject in draggedObjects) {
        [self.operators addOperator:draggedObject atIndex:insertIndex];
        insertIndex++;
    }
    
    [self.mainTableView reloadData];
    
    return YES;
}

@end
