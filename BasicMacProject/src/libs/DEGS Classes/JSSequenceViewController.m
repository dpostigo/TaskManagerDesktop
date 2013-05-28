//
//  JSSequenceViewController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSSequenceViewController.h"
#import "JSFilterTableCellView.h"
#import "JSIntegrateTableCellView.h"
#import "JSBreakpointTableCellView.h"
#import "JSSequence.h"
#import "JSFilter.h"
#import "JSIntegrate.h"
#import "JSBreakpoint.h"

@interface JSSequenceViewController()

@property (nonatomic, strong) JSSequence *sequence;

@property (strong) IBOutlet NSMenu *addElementMenu;
@property (nonatomic, strong) JSSyntaxHighlighter *syntaxHighlighter;

@property (nonatomic, strong) JSIntegrateTableCellView *integrateDummyCell;
@property (nonatomic, strong) JSFilterTableCellView *filterDummyCell;
@property (nonatomic, strong) JSBreakpointTableCellView *breakpointDummyCell;

@end

@implementation JSSequenceViewController

#pragma mark - Setter and getters

// The dummy cells are used to compute the height of the cells at runtime

- (JSIntegrateTableCellView *)integrateDummyCell
{
    if (!_integrateDummyCell) {
        _integrateDummyCell = [self.mainTableView makeViewWithIdentifier:@"integrateCell" owner:self];
        _integrateDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_integrateDummyCell
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:500.0f];
        [_integrateDummyCell addConstraint:_integrateDummyCell.widthConstraint];
    }
    return _integrateDummyCell;
}

- (JSFilterTableCellView *)filterDummyCell
{
    if (!_filterDummyCell) {
        _filterDummyCell = [self.mainTableView makeViewWithIdentifier:@"filterCell" owner:self];
        _filterDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_filterDummyCell
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f
                                                                              constant:500.0f];
        [_filterDummyCell addConstraint:_filterDummyCell.widthConstraint];
    }
    return _filterDummyCell;
}

- (JSBreakpointTableCellView *)breakpointDummyCell
{
    if (!_breakpointDummyCell) {
        _breakpointDummyCell = [self.mainTableView makeViewWithIdentifier:@"breakpointCell" owner:self];
        _breakpointDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_breakpointDummyCell
                                                                                attribute:NSLayoutAttributeWidth
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.0f
                                                                                 constant:500.0f];
        [_breakpointDummyCell addConstraint:_breakpointDummyCell.widthConstraint];
    }
    return _breakpointDummyCell;
}

- (void)resizeDummyCells
{
    [self.integrateDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.integrateDummyCell layoutSubtreeIfNeeded];
    [self.filterDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.filterDummyCell layoutSubtreeIfNeeded];
    [self.breakpointDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.breakpointDummyCell layoutSubtreeIfNeeded];
}

- (id)representedObject
{
    return self.sequence;
}

- (void)setRepresentedObject:(id)representedObject
{
    if ([representedObject isKindOfClass:[JSSequence class]]) self.sequence = representedObject;
}

# pragma mark - init and destroy methods

- (id)initWithSequence:(JSSequence *)sequence
{
    self = [super initWithNibName:@"JSSequenceViewController" bundle:nil];
    if (self) {
        self.sequence = sequence;
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
    [self.treeController.bottomBar setNewLabel:@"New Element"];
    [self.treeController.bottomBar enableNewButton:YES];
    if ([self.sequence numberOfElements]>0) [self.treeController.bottomBar enableDeleteButton:YES];
    [self.treeController.bottomBar showBackButton:NO withAnimation:YES];

}

#pragma mark - Data source and delegate of the table view

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.sequence.numberOfElements;
}

- (void)fillFilterCell:(JSFilterTableCellView *)cellView atRow:(NSUInteger)row
{
    JSFilter *filter = (self.sequence.operations)[row];
    if (filter.name) cellView.nameTextField.stringValue = filter.name;
    else cellView.nameTextField.stringValue = @"";
    
    [cellView.dependenciesTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (filter.dependencies.vectors) [cellView.dependenciesTokenField setObjectValue:filter.dependencies.vectors];
    else [cellView.dependenciesTokenField setObjectValue:nil];
    
    [cellView.dependenciesBasisTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (filter.dependencies.basis) [cellView.dependenciesBasisTokenField setObjectValue:filter.dependencies.basis];
    else [cellView.dependenciesBasisTokenField setObjectValue:nil];
    
    if (filter.evaluation) cellView.definitionTextField.stringValue = filter.evaluation;
    else cellView.definitionTextField.stringValue = @"";
}

- (void)fillIntegrateCell:(JSIntegrateTableCellView *)cellView atRow:(NSUInteger)row
{
    JSIntegrate *integrate = (self.sequence.operations)[row];
    if (integrate.name) cellView.nameTextField.stringValue = integrate.name;
    else cellView.nameTextField.stringValue = @"";
    
    [cellView.algorithmButton removeAllItems];
    [cellView.algorithmButton addItemsWithTitles:integrate.algorithmOptions];
    [cellView.algorithmButton selectItemAtIndex:integrate.algorithm];
    NSString *algorithmString = (integrate.algorithmOptions)[integrate.algorithm];
    if ([algorithmString isEqualToString:@"ARK89"] || [algorithmString isEqualToString:@"ARK45"])
        [cellView setIntegrateCellState:JSIntegrateCellWithTolerance];
    else
        [cellView setIntegrateCellState:JSIntegrateCellWithoutTolerance];
    
    if (integrate.tolerance) cellView.toleranceTextField.stringValue = [integrate.tolerance stringValue];
    else cellView.toleranceTextField.stringValue = @"";
    
    if (integrate.steps) cellView.stepsTextField.stringValue = [integrate.steps stringValue];
    else cellView.stepsTextField.stringValue = @"";
    
    if (integrate.interval) cellView.intervalTextField.stringValue = integrate.interval;
    else cellView.intervalTextField.stringValue = @"";
    
    if (integrate.samples) cellView.samplesTextField.stringValue = [integrate.samples componentsJoinedByString:@" "];
    else cellView.samplesTextField.stringValue = @"";
    
    NSNumber *filtersNumber = @(integrate.filters.numberOfFilters);
    cellView.filtersButton.title = [filtersNumber stringValue];
    
    NSNumber *operatorsNumber = @(integrate.operators.numberOfOperators);
    cellView.operatorsButton.title = [operatorsNumber stringValue];
    
    NSNumber *computedVectorNumber = @(integrate.computedVectors.numberOfVectors);
    cellView.computedVectorButton.title = [computedVectorNumber stringValue];
}

- (void)fillBreakpointCell:(JSBreakpointTableCellView *)cellView atRow:(NSUInteger)row
{
    JSBreakpoint *breakpoint = (self.sequence.operations)[row];
    if (breakpoint.name) cellView.nameTextField.stringValue = breakpoint.name;
    else cellView.nameTextField.stringValue = @"";
    
    if (breakpoint.filename) cellView.filenameTextField.stringValue = breakpoint.filename;
    else cellView.filenameTextField.stringValue = @"";
    
    [cellView.formatButton removeAllItems];
    [cellView.formatButton addItemsWithTitles:breakpoint.formatOptions];
    [cellView.formatButton selectItemAtIndex:breakpoint.format];
    
    [cellView.dependenciesTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (breakpoint.dependencies.vectors) [cellView.dependenciesTokenField setObjectValue:breakpoint.dependencies.vectors];
    else [cellView.dependenciesTokenField setObjectValue:nil];
    
    [cellView.dependenciesBasisTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (breakpoint.dependencies.basis) [cellView.dependenciesBasisTokenField setObjectValue:breakpoint.dependencies.basis];
    else [cellView.dependenciesBasisTokenField setObjectValue:nil];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([(self.sequence.operations)[row] isKindOfClass:[JSFilter class]]) {
        JSFilterTableCellView *cellView = (JSFilterTableCellView *)[tableView makeViewWithIdentifier:@"filterCell" owner:self];
        cellView.definitionTextField.syntaxHighlighter = self.syntaxHighlighter;
        [self fillFilterCell:cellView atRow:row];
        cellView.definitionTextField.keepsEditingOnReturn = YES;
        return cellView;
    } else if ([(self.sequence.operations)[row] isKindOfClass:[JSIntegrate class]]) {
        JSIntegrateTableCellView *cellView = (JSIntegrateTableCellView *)[tableView makeViewWithIdentifier:@"integrateCell" owner:self];
        [self fillIntegrateCell:cellView atRow:row];
        cellView.delegate = (id)self;
        return cellView;
    } else {
        JSBreakpointTableCellView *cellView = (JSBreakpointTableCellView *)[tableView makeViewWithIdentifier:@"breakpointCell" owner:self];
        [self fillBreakpointCell:cellView atRow:row];
        return cellView;
    }
}    

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row 
{
    if ([(self.sequence.operations)[row] isKindOfClass:[JSFilter class]]) {
        [self fillFilterCell:self.filterDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.filterDummyCell fittingSize].height;
    } else if ([(self.sequence.operations)[row] isKindOfClass:[JSIntegrate class]]) {
        [self fillIntegrateCell:self.integrateDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.integrateDummyCell fittingSize].height;
    } else {
        [self fillBreakpointCell:self.breakpointDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.breakpointDummyCell fittingSize].height;
    }
}

#pragma mark - Methods to add or delete elements to the sequence section

-(void)addElement:(id)sender
{
    NSRect frame = [(NSButton *)sender frame];
    
    NSSize menuSize = [self.addElementMenu size];
    NSPoint menuOrigin = [[(NSButton *)sender superview] convertPoint:NSMakePoint(frame.origin.x, frame.origin.y+frame.size.height+menuSize.height) toView:nil];
    
    NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                         location:menuOrigin
                                    modifierFlags:NSLeftMouseDownMask // 0x100
                                        timestamp:0.0
                                     windowNumber:[[(NSButton *)sender window] windowNumber]
                                          context:[[(NSButton *)sender window] graphicsContext]
                                      eventNumber:0
                                       clickCount:1
                                         pressure:1];
    
    [NSMenu popUpContextMenu:self.addElementMenu withEvent:event forView:(NSButton *)sender];
}
                                       
- (void)addElementAndUpdateTable:(JSNode *)newElement
{
    [self.sequence addElement:newElement];
    
    [self insertNewRowInMainTable];
}

- (IBAction)addFilterElement:(id)sender
{
    JSFilter *newElement = [[JSFilter alloc] init];
    [self addElementAndUpdateTable:newElement];
}

- (IBAction)addIntegrateElement:(id)sender
{
    JSIntegrate *newElement = [[JSIntegrate alloc] init];
    [self addElementAndUpdateTable:newElement];
}

- (IBAction)addBreakPointElement:(id)sender
{
    JSBreakpoint *newElement = [[JSBreakpoint alloc] init];
    [self addElementAndUpdateTable:newElement];
}

-(void)deleteElement:(id)sender
{
    NSInteger row = [self.mainTableView selectedRow];
    [self.sequence deleteElementAtIndex:row-self.biasCells];
    [self.mainTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
    if ([self.sequence numberOfElements]==0) [self.treeController.bottomBar enableDeleteButton:NO];
}

#pragma mark - Cell editing methods

// FIXME: Maybe it's appropriate to move the samples field a token field, move it's editing method to the shouldAddTokens: method and validate the entries

// We use key value coding to assign changes in the various controls to the model
// The identifier of the controls are equal to the keyPath of the properties we want to set
- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *sender = [obj object];
    NSString *senderIdentifier = [sender identifier];
    
    // the entries in the token field gets handled in another method so we have to make sure we are only setting the properties we want here
    if ([senderIdentifier isEqualToString:@"name"] || [senderIdentifier isEqualToString:@"evaluation"] || [senderIdentifier isEqualToString:@"filename"] || [senderIdentifier isEqualToString:@"interval"] || [senderIdentifier isEqualToString:@"samples"]) {
    
        NSString *enteredString = [sender.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSInteger row = [self.mainTableView rowForView:sender];
    
        id value = nil;
        if ([enteredString length]) value = enteredString;
        
        // if we need to set the samples we need to convert the entered string into an array of strings
        if ([senderIdentifier isEqualToString:@"samples"]) value = [enteredString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
        id element = (self.sequence.operations)[row];
        [element setValue:value forKeyPath:senderIdentifier];
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSString *senderIdentifier = [control identifier];
    
    if ([senderIdentifier isEqualToString:@"tolerance"] || [senderIdentifier isEqualToString:@"steps"]) {
        NSUInteger rowOfEditedField = [self.mainTableView rowForView:control];
        JSIntegrate *integrate = (self.sequence.operations)[rowOfEditedField-self.biasCells];
    
        double value = [fieldEditor.string doubleValue];    
        if ([[control stringValue] length] ==0) [integrate setValue:nil forKeyPath:senderIdentifier];
        else [integrate setValue:@(value) forKeyPath:senderIdentifier];
    }
    return YES;
}

# pragma mark - Popup buttons method

- (IBAction)popUpButtonPressed:(id)sender
{
    NSInteger row = [self.mainTableView rowForView:sender];
    if (row != -1) {
        NSInteger selection = [sender indexOfSelectedItem];
        NSString *senderIdentifier = [sender identifier];
        
        id element = (self.sequence.operations)[row];
        [element setValue:[NSNumber numberWithInteger:selection] forKeyPath:senderIdentifier];
        if ([senderIdentifier isEqualToString:@"algorithm"]) {
            NSString *algorithmString = [(JSIntegrate *)element algorithmOptions][selection];
            JSIntegrateTableCellView *changedCell = [self.mainTableView viewAtColumn:0 row:row makeIfNecessary:NO];
            if ([algorithmString isEqualToString:@"ARK45"] || [algorithmString isEqualToString:@"ARK89"]) [changedCell setIntegrateCellState:JSIntegrateCellWithTolerance];
            else [changedCell setIntegrateCellState:JSIntegrateCellWithoutTolerance];
        }
        if (row != [self.mainTableView selectedRow]) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}

# pragma mark - Filters and Operators buttons

-(IBAction)subsectionButtonPressed:(id)sender
{
    NSInteger row = [self.mainTableView rowForView:sender];
    if (row != -1) {
        NSString *senderIdentifier = [sender identifier];
        JSIntegrate *integrate = (self.sequence.operations)[row];
        JSNode *newObject = [integrate valueForKey:senderIdentifier];
        [self.treeController showSubsectionForObject:newObject];
    }
}

#pragma mark - Tokenfields completion delegate method

- (NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex
{
    NSString *senderIdentifier = [tokenField identifier];
    if ([senderIdentifier isEqualToString:@"dependencies.basis"]) {
        return [self.sequence.root listOfBasisForSubstring:substring];
    } else if ([senderIdentifier isEqualToString:@"dependencies.vectors"]) {
        return [self.sequence.root listOfVectorsForSubstring:substring];
    }
    return nil;
}

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
        
        id element = (self.sequence.operations)[row];
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
    
    id element = (self.sequence.operations)[row];
    [element setValue:[tokenField objectValue] forKeyPath:tokenFieldIdentifier];
}

#pragma mark - Syntax highlighter delegate

-(NSArray *)userIdentifiersForKeywordComponentName:(NSString *)inModeName
{
    NSMutableArray *identifiers = [[self.sequence.root listOfDimensionsIdentifiersForBasis] mutableCopy];
    [identifiers addObjectsFromArray:[self.sequence.root listOfVectorComponentsIdentifiers]];
    [identifiers addObjectsFromArray:[self.sequence.root listOfArgumentsIdentifiers]];
    return identifiers;
}

# pragma mark - Section title

- (NSString *)title
{
    return self.sequence.description;
}

- (NSString *)sectionSuffix
{
    return @"sequenceelement";
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
    
    NSArray *draggedObjects = [self.sequence.operations objectsAtIndexes:rowIndexes];
    [self.sequence deleteElementsAtIndexes:rowIndexes];
    
    for (id draggedObject in draggedObjects) {
        [self.sequence addElement:draggedObject atIndex:insertIndex];
        insertIndex++;
    }
    
    [self.mainTableView reloadData];
    
    return YES;
}

@end
