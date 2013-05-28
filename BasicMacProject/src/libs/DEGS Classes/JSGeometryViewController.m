//
//  JSGeometryViewController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSGeometryViewController.h"
#import "JSGeometry.h"
#import "JSDimension.h"
#import "JSTransverseDimensionCellView.h"
#import "JSPropagationDimensionTableCellView.h"

@interface JSGeometryViewController ()

@property (nonatomic, strong) JSGeometry *geometry;

@property (nonatomic, strong) JSPropagationDimensionTableCellView *propagationDimensionDummyCell;
@property (nonatomic, strong) JSTransverseDimensionCellView *transverseDimensionDummyCell;

@end

@implementation JSGeometryViewController

#pragma mark - Setter and getters

// The dummy cells are used to compute the height of the cells at runtime

- (JSPropagationDimensionTableCellView *)propagationDimensionDummyCell
{
    if (!_propagationDimensionDummyCell) {
        _propagationDimensionDummyCell = [self.mainTableView makeViewWithIdentifier:@"propagationDimensionCell" owner:self];
        _propagationDimensionDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_propagationDimensionDummyCell
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f
                                                                           constant:500.0f];
        [_propagationDimensionDummyCell addConstraint:_propagationDimensionDummyCell.widthConstraint];
    }
    return _propagationDimensionDummyCell;
}

- (JSTransverseDimensionCellView *)transverseDimensionDummyCell
{
    if (!_transverseDimensionDummyCell) {
        _transverseDimensionDummyCell = [self.mainTableView makeViewWithIdentifier:@"transverseDimensionCell" owner:self];
        _transverseDimensionDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_transverseDimensionDummyCell
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f
                                                                           constant:500.0f];
        [_transverseDimensionDummyCell addConstraint:_transverseDimensionDummyCell.widthConstraint];
    }
    return _transverseDimensionDummyCell;
}

- (void)resizeDummyCells
{
    if (self.propagationDimensionDummyCell.frame.size.width != self.mainTableView.frame.size.width) {
        [self.propagationDimensionDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
        [self.propagationDimensionDummyCell layoutSubtreeIfNeeded];
        [self.transverseDimensionDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
        [self.transverseDimensionDummyCell layoutSubtreeIfNeeded];
    }
}

- (id)representedObject
{
    return self.geometry;
}

- (void)setRepresentedObject:(id)representedObject
{
    if ([representedObject isKindOfClass:[JSGeometry class]]) self.geometry = representedObject;
}

# pragma mark - cell state methods

- (void)changeCell:(JSTransverseDimensionCellView *)cellView stateWithDimension:(JSDimension *)dimension
{
    NSString *transformString = (dimension.transformOptions)[dimension.transform];
    if ([transformString isEqualToString:@"hermite-gauss"])
        [cellView setTransverseDimensionCellState:JSTransverseDimensionCellHermiteGaussState];
    else if ([transformString isEqualToString:@"bessel"] || [transformString isEqualToString:@"spherical-bessel"])
        [cellView setTransverseDimensionCellState:JSTransverseDimensionCellBesselState];
    else
        [cellView setTransverseDimensionCellState:JSTransverseDimensionCellNormalState];
}

#pragma mark - Init and destroy methods


- (id)initWithGeometry:(JSGeometry *)geometry
{
    self = [super initWithNibName:@"JSGeometryViewController" bundle:nil];
    if (self) {
        self.geometry = geometry;
        self.biasCells = 1;
    }
    return self;
}

- (void)viewDidAppear
{
    // set the appeareance of the left group of buttons in the bottom bar
    [self.treeController.bottomBar enableDeleteButton:NO];
    [self.treeController.bottomBar enableNewButton:YES];
    [self.treeController.bottomBar setNewLabel:@"New Dimension"];
    [self.treeController.bottomBar showBackButton:NO withAnimation:YES];
}

#pragma mark - NSTableView delegate and datasource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.geometry.numberOfTransverseDimensions + self.biasCells;
}

- (void)fillPropagationDimensionCell:(JSPropagationDimensionTableCellView *)cellView
{
    if (self.geometry.propagationDimension) cellView.nameTextField.stringValue = self.geometry.propagationDimension;
    else cellView.nameTextField.stringValue = @"";
}

- (void)fillTransverseDimensionCell:(JSTransverseDimensionCellView *)cellView atRow:(NSInteger)row
{
    JSDimension *transverseDimension = (self.geometry.transverseDimension)[row-self.biasCells];
    
    if (transverseDimension.name) cellView.nameTextField.stringValue = transverseDimension.name;
    else cellView.nameTextField.stringValue = @"";
    
    if (transverseDimension.lattice) cellView.latticeTextField.stringValue = transverseDimension.lattice;
    else cellView.latticeTextField.stringValue = @"";
    
    if (transverseDimension.domainStart) cellView.domainStartTextField.stringValue = transverseDimension.domainStart;
    else cellView.domainStartTextField.stringValue = @"";
    
    if (transverseDimension.domainEnd) cellView.domainEndTextField.stringValue = transverseDimension.domainEnd;
    else cellView.domainEndTextField.stringValue = @"";
    
    [cellView.aliasesTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (transverseDimension.aliases) [cellView.aliasesTokenField setObjectValue:transverseDimension.aliases];
    else [cellView.aliasesTokenField setObjectValue:nil];
    
    [cellView.typeButton removeAllItems];
    [cellView.typeButton addItemsWithTitles:transverseDimension.typeOptions];
    [cellView.typeButton selectItemAtIndex:transverseDimension.type];
    
    [cellView.transformButton removeAllItems];
    [cellView.transformButton addItemsWithTitles:transverseDimension.transformOptions];
    [cellView.transformButton selectItemAtIndex:transverseDimension.transform];
    
    if (transverseDimension.order) cellView.orderTextField.stringValue = [@(transverseDimension.order) stringValue];
    else cellView.orderTextField.stringValue = @"";
    
    if (transverseDimension.spectralLattice) cellView.spectralLatticeTextField.stringValue = [transverseDimension.spectralLattice stringValue];
    else cellView.spectralLatticeTextField.stringValue = @"";
    
    if (transverseDimension.lengthScale) cellView.lengthScaleTextField.stringValue = transverseDimension.lengthScale;
    else cellView.lengthScaleTextField.stringValue = @"";
    
    if (transverseDimension.volumePrefactor) cellView.volumePrefactorTextField.stringValue = transverseDimension.volumePrefactor;
    else cellView.volumePrefactorTextField.stringValue = @"";
    
    [self changeCell:cellView stateWithDimension:transverseDimension];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row == 0) {
        JSPropagationDimensionTableCellView  *cellView = (JSPropagationDimensionTableCellView *)[tableView makeViewWithIdentifier:@"propagationDimensionCell" owner:self];
        [self fillPropagationDimensionCell:cellView];
        return cellView;
    } else {
        JSTransverseDimensionCellView *cellView = (JSTransverseDimensionCellView *)[tableView makeViewWithIdentifier:@"transverseDimensionCell" owner:self];
        [self fillTransverseDimensionCell:cellView atRow:row];
        cellView.delegate = (id)self;
        return cellView;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if (row == 0) {
        [self fillPropagationDimensionCell:self.propagationDimensionDummyCell];
        [self resizeDummyCells];
        return [self.propagationDimensionDummyCell fittingSize].height;
    } else {
        [self fillTransverseDimensionCell:self.transverseDimensionDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.transverseDimensionDummyCell fittingSize].height;
    }
}

#pragma mark - Methods to add or remove a dimension

-(void)addElement:(id)sender
{
    JSDimension *newDimension = [[JSDimension alloc] init];
    [self.geometry addTransverseDimension:newDimension];

    [self insertNewRowInMainTable];
}

-(void)deleteElement:(id)sender
{
    NSInteger row = [self.mainTableView selectedRow];
    [self.geometry deleteTransverseDimensionAtIndex:row-self.biasCells];
    [self.mainTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
}

#pragma mark - Cell editing methods

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *sender = [obj object];
    NSString *enteredString = [sender.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *senderIdentifier = [sender identifier];
    
    id value = nil;
    if ([enteredString length]) value = enteredString;
    
    if ([senderIdentifier isEqualToString:@"propagationDimension"]) [self.geometry setValue:value forKeyPath:senderIdentifier];
    
    else if ([senderIdentifier isEqualToString:@"name"] || [senderIdentifier isEqualToString:@"domainStart"] || [senderIdentifier isEqualToString:@"domainEnd"] || [senderIdentifier isEqualToString:@"volumePrefactor"] || [senderIdentifier isEqualToString:@"lengthScale"] || [senderIdentifier isEqualToString:@"lattice"] || [senderIdentifier isEqualToString:@"spectralLattice"] || [senderIdentifier isEqualToString:@"order"]) {
        
        NSInteger row = [self.mainTableView rowForView:sender];
        JSDimension *transverseDimension = (self.geometry.transverseDimension)[row-self.biasCells];
        if ([senderIdentifier isEqualToString:@"spectralLattice"] || [senderIdentifier isEqualToString:@"order"])
            [transverseDimension setValue:@([value integerValue]) forKeyPath:senderIdentifier];
        else
            [transverseDimension setValue:value forKeyPath:senderIdentifier];
    }
}

- (IBAction)popUpButtonPressed:(id)sender
{
    NSInteger row = [self.mainTableView rowForView:sender];
    if (row > self.biasCells-1) {
        NSInteger selection = [sender indexOfSelectedItem];
        NSString *senderIdentifier = [sender identifier];
        JSDimension *modifiedDimension = (self.geometry.transverseDimension)[row-self.biasCells];
        if ([senderIdentifier isEqualToString:@"transformButton"]) {
            modifiedDimension.transform = selection;
            JSTransverseDimensionCellView *cellView = (JSTransverseDimensionCellView *)[self.mainTableView viewAtColumn:0 row:row makeIfNecessary:NO];
            [self changeCell:cellView stateWithDimension:modifiedDimension];
        } else if ([senderIdentifier isEqualToString:@"typeButton"]) {
            modifiedDimension.type = selection;
        }
        if (row != [self.mainTableView selectedRow]) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}

#pragma mark - Tokenfield delegate methods

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
    if ([tokensToBeAdded count]) {
        // Let's add the new aliases to the appropriate dimension
        NSInteger row = [self.mainTableView rowForView:tokenField];
        JSDimension *modifiedDimension = (self.geometry.transverseDimension)[row-self.biasCells];
        if (modifiedDimension.aliases) modifiedDimension.aliases = [modifiedDimension.aliases arrayByAddingObjectsFromArray:tokensToBeAdded];
        else modifiedDimension.aliases = [tokensToBeAdded copy];
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
    JSDimension *modifiedDimension = (self.geometry.transverseDimension)[row-self.biasCells];
    modifiedDimension.aliases = [tokenField objectValue];
}

# pragma mark - Section title

- (NSString *)title
{
    return self.geometry.description;
}

- (NSString *)sectionSuffix
{
    return @"geometryelement";
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
    
    NSArray *draggedObjects = [self.geometry.transverseDimension objectsAtIndexes:rowIndexes];
    [self.geometry deleteTransverseDimensionsAtIndexes:rowIndexes];
    
    for (id draggedObject in draggedObjects) {
        [self.geometry addTransverseDimension:draggedObject atIndex:insertIndex];
        insertIndex++;
    }
    
    [self.mainTableView reloadData];
    
    return YES;
}

@end
