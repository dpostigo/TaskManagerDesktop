//
//  JSVectorViewController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSVectorViewController.h"
#import "JSVectors.h"
#import "JSVector.h"
#import "JSComputedVector.h"
#import "JSNoiseVector.h"
#import "JSNoiseVectorTableCellView.h"
#import "JSComputedVectorTableCellView.h"
#import "JSVectorTableCellView.h"
#import "NSPopover+Message.h"

@interface JSVectorViewController ()

@property (nonatomic, strong) JSVectors *vectors;

@property (strong) IBOutlet NSMenu *addElementMenu;
@property (nonatomic, strong) JSSyntaxHighlighter *syntaxHighlighter;

@property (nonatomic, strong) JSVectorTableCellView *vectorDummyCell;
@property (nonatomic, strong) JSNoiseVectorTableCellView *noiseVectorDummyCell;
@property (nonatomic, strong) JSComputedVectorTableCellView *computedVectorDummyCell;

@end

@implementation JSVectorViewController

#pragma mark - Setter and getters

// The dummy cells are used to compute the height of the cells at runtime

- (JSVectorTableCellView *)vectorDummyCell
{
    if (!_vectorDummyCell) {
        _vectorDummyCell = [self.mainTableView makeViewWithIdentifier:@"vectorCell" owner:self];
        _vectorDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_vectorDummyCell
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:500.0f];
        [_vectorDummyCell addConstraint:_vectorDummyCell.widthConstraint];
    }
    return _vectorDummyCell;
}

- (JSNoiseVectorTableCellView *)noiseVectorDummyCell
{
    if (!_noiseVectorDummyCell) {
        _noiseVectorDummyCell = [self.mainTableView makeViewWithIdentifier:@"noiseVectorCell" owner:self];
        _noiseVectorDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_noiseVectorDummyCell
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f
                                                                              constant:500.0f];
        [_noiseVectorDummyCell addConstraint:_noiseVectorDummyCell.widthConstraint];
    }
    return _noiseVectorDummyCell;
}

- (JSComputedVectorTableCellView *)computedVectorDummyCell
{
    if (!_computedVectorDummyCell) {
        _computedVectorDummyCell = [self.mainTableView makeViewWithIdentifier:@"computedVectorCell" owner:self];
        _computedVectorDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_computedVectorDummyCell
                                                                                attribute:NSLayoutAttributeWidth
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.0f
                                                                                 constant:500.0f];
        [_computedVectorDummyCell addConstraint:_computedVectorDummyCell.widthConstraint];
    }
    return _computedVectorDummyCell;
}

- (void)resizeDummyCells
{
    [self.vectorDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.vectorDummyCell layoutSubtreeIfNeeded];
    [self.noiseVectorDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.noiseVectorDummyCell layoutSubtreeIfNeeded];
    [self.computedVectorDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.computedVectorDummyCell layoutSubtreeIfNeeded];
}

- (id)representedObject
{
    return self.vectors;
}

- (void)setRepresentedObject:(id)representedObject
{
    if ([representedObject isKindOfClass:[JSVectors class]]) self.vectors = representedObject;
}

#pragma mark - init and destroy methods

- (id)initWithVectors:(JSVectors *)vectors
{
    self = [super initWithNibName:@"JSVectorViewController" bundle:nil];
    if (self) {
        self.vectors = vectors;
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
    // set the appeareance of the left group of buttons in the bottom bar
    [self.treeController.bottomBar enableNewButton:YES];
    [self.treeController.bottomBar setNewLabel:@"New Vector"];
    if ([self.vectors numberOfVectors]>0)
        [self.treeController.bottomBar enableDeleteButton:YES];
    else
        [self.treeController.bottomBar enableDeleteButton:NO];
    if (self.vectors.allowsComputedVectorsOnly) [self.treeController.bottomBar showBackButton:YES withAnimation:YES];
    else [self.treeController.bottomBar showBackButton:NO withAnimation:YES];
}


#pragma mark - Data source and delegate of the table view

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.vectors.numberOfVectors;
}

- (void)fillVectorCell:(JSVectorTableCellView *)cellView atRow:(NSUInteger)row
{
    JSVector *vector = (self.vectors.vectors)[row];
    if (vector.name) cellView.nameTextField.stringValue = vector.name;
    else cellView.nameTextField.stringValue = @"";
    
    [cellView.typeButton removeAllItems];
    [cellView.typeButton addItemsWithTitles:vector.typeOptions];
    [cellView.typeButton selectItemAtIndex:vector.type];
    
    [cellView.componentsTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.components) [cellView.componentsTokenField setObjectValue:vector.components];
    else [cellView.componentsTokenField setObjectValue:nil];
    
    [cellView.dimensionsTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.dimensions) [cellView.dimensionsTokenField setObjectValue:vector.dimensions];
    else [cellView.dimensionsTokenField setObjectValue:nil];
    
    [cellView.initialBasisTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.initialBasis) [cellView.initialBasisTokenField setObjectValue:vector.initialBasis];
    else [cellView.initialBasisTokenField setObjectValue:nil];
    
    [cellView.initialisationButton removeAllItems];
    [cellView.initialisationButton addItemsWithTitles:vector.initialisationOptions];
    [cellView.initialisationButton selectItemAtIndex:vector.initialisation];
    
    if (vector.filename) cellView.filenameTextField.stringValue = vector.filename;
    else cellView.filenameTextField.stringValue = @"";
    
    [cellView.dependenciesTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.dependencies.vectors) [cellView.dependenciesTokenField setObjectValue:vector.dependencies.vectors];
    else [cellView.dependenciesTokenField setObjectValue:nil];
    
    [cellView.dependenciesBasisTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.dependencies.basis) [cellView.dependenciesBasisTokenField setObjectValue:vector.dependencies.basis];
    else [cellView.dependenciesBasisTokenField setObjectValue:nil];
    
    if (vector.cdataString) cellView.initialisationTextField.stringValue = vector.cdataString;
    else cellView.initialisationTextField.stringValue = @"";
    
    NSString *initialisationString = (vector.initialisationOptions)[vector.initialisation];
    
    if ([initialisationString isEqualToString:@"xsil"] || [initialisationString isEqualToString:@"hdf5"])
        [cellView setVectorCellState:JSVectorCellInFilenameState];
    else if ([initialisationString isEqualToString:@"cdata"])
        [cellView setVectorCellState:JSVectorCellInCDATAState];
    else [cellView setVectorCellState:JSVectorCellInZeroState];
    
}

- (void)fillNoiseVectorCell:(JSNoiseVectorTableCellView *)cellView atRow:(NSUInteger)row
{
    JSNoiseVector *vector = (self.vectors.vectors)[row];
    if (vector.name) cellView.nameTextField.stringValue = vector.name;
    else cellView.nameTextField.stringValue = @"";
    
    [cellView.typeButton removeAllItems];
    [cellView.typeButton addItemsWithTitles:vector.typeOptions];
    [cellView.typeButton selectItemAtIndex:vector.type];
    
    [cellView.componentsTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.components) [cellView.componentsTokenField setObjectValue:vector.components];
    else [cellView.componentsTokenField setObjectValue:nil];
    
    [cellView.dimensionsTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.dimensions) [cellView.dimensionsTokenField setObjectValue:vector.dimensions];
    else [cellView.dimensionsTokenField setObjectValue:nil];
    
    [cellView.initialBasisTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.initialBasis) [cellView.initialBasisTokenField setObjectValue:vector.initialBasis];
    else [cellView.initialBasisTokenField setObjectValue:nil];
    
    [cellView.methodButton removeAllItems];
    [cellView.methodButton addItemsWithTitles:vector.methodOptions];
    [cellView.methodButton selectItemAtIndex:vector.method];
    
    if ([(vector.kindOptions)[vector.kind] isEqualToString:@"poissonian"] || [(vector.kindOptions)[vector.kind] isEqualToString:@"jump"]) [cellView setNoiseVectorCellState:JSNoiseVectorCellWithMeanState];
    else [cellView setNoiseVectorCellState:JSNoiseVectorCellWithoutMeanState];
    
    if (vector.mean) cellView.meanTextField.stringValue = vector.mean;
    else cellView.meanTextField.stringValue = @"";
    
    [cellView.kindButton removeAllItems];
    [cellView.kindButton addItemsWithTitles:vector.kindOptions];
    [cellView.kindButton selectItemAtIndex:vector.kind];
    
    if (vector.seed) cellView.seedTextField.stringValue = vector.seed;
    else cellView.seedTextField.stringValue = @"";
}

- (void)fillComputedVectorCell:(JSComputedVectorTableCellView *)cellView atRow:(NSUInteger)row
{
    JSComputedVector *vector = (self.vectors.vectors)[row];
    if (vector.name) cellView.nameTextField.stringValue = vector.name;
    else cellView.nameTextField.stringValue = @"";
    
    [cellView.typeButton removeAllItems];
    [cellView.typeButton addItemsWithTitles:vector.typeOptions];
    [cellView.typeButton selectItemAtIndex:vector.type];
    
    [cellView.componentsTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.components) [cellView.componentsTokenField setObjectValue:vector.components];
    else [cellView.componentsTokenField setObjectValue:nil];
    
    [cellView.dimensionsTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.dimensions) [cellView.dimensionsTokenField setObjectValue:vector.dimensions];
    else [cellView.dimensionsTokenField setObjectValue:nil];
    
    [cellView.dependenciesTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.dependencies.vectors) [cellView.dependenciesTokenField setObjectValue:vector.dependencies.vectors];
    else [cellView.dependenciesTokenField setObjectValue:nil];
    
    [cellView.dependenciesBasisTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (vector.dependencies.basis) [cellView.dependenciesBasisTokenField setObjectValue:vector.dependencies.basis];
    else [cellView.dependenciesBasisTokenField setObjectValue:nil];
    
    if (vector.definition) cellView.evaluationTextField.stringValue = vector.definition;
    else cellView.evaluationTextField.stringValue = @"";
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    if ([(self.vectors.vectors)[row] isKindOfClass:[JSVector class]]) {
        JSVectorTableCellView *cellView = (JSVectorTableCellView *)[tableView makeViewWithIdentifier:@"vectorCell" owner:self];
        cellView.initialisationTextField.syntaxHighlighter = self.syntaxHighlighter;
        [self fillVectorCell:cellView atRow:row];
        cellView.delegate = (id)self;
        cellView.dimensionsTokenField.allowsEmptyTokens = YES;
        cellView.initialisationTextField.keepsEditingOnReturn = YES;
        return cellView;
    } else if ([(self.vectors.vectors)[row] isKindOfClass:[JSNoiseVector class]]) {
        JSNoiseVectorTableCellView *cellView = (JSNoiseVectorTableCellView *)[tableView makeViewWithIdentifier:@"noiseVectorCell" owner:self];
        [self fillNoiseVectorCell:cellView atRow:row];
        cellView.delegate = (id)self;
        cellView.dimensionsTokenField.allowsEmptyTokens = YES;
        return cellView;
    } else {
        JSComputedVectorTableCellView *cellView = (JSComputedVectorTableCellView *)[tableView makeViewWithIdentifier:@"computedVectorCell" owner:self];
        cellView.evaluationTextField.syntaxHighlighter = self.syntaxHighlighter;
        [self fillComputedVectorCell:cellView atRow:row];
        cellView.evaluationTextField.keepsEditingOnReturn = YES;
        cellView.dimensionsTokenField.allowsEmptyTokens = YES;
        return cellView;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if ([(self.vectors.vectors)[row] isKindOfClass:[JSVector class]]) {
        [self fillVectorCell:self.vectorDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.vectorDummyCell fittingSize].height;
    } else if ([(self.vectors.vectors)[row] isKindOfClass:[JSNoiseVector class]]) {
        [self fillNoiseVectorCell:self.noiseVectorDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.noiseVectorDummyCell fittingSize].height;
    } else {
        [self fillComputedVectorCell:self.computedVectorDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.computedVectorDummyCell fittingSize].height;
    }
}

#pragma mark - Show dimensions shortcut hint

- (void)tokenFieldDidBecomeFirstResponder:(NSNotification *)aNotification
{
    JSTokenField *tokenField = [aNotification object];
    [super updateSelectedRowToOwnerOf:tokenField];
    if ([[tokenField identifier] isEqualToString:@"dimensions"]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:@"HasShownDimensionsHint"]) {
            [NSPopover showRelativeToRect:[tokenField bounds]
                                   ofView:tokenField
                            preferredEdge:NSMaxXEdge
                                   string:@"Use ctrl+space to enter an empty token indicating a vector with no dimensions."
                                 maxWidth:250.0];
            [defaults setBool:YES forKey:@"HasShownDimensionsHint"];
        }
    }
}

#pragma mark - Methods to add or delete vectors to the array

-(void)addElement:(id)sender
{
    if (self.vectors.allowsComputedVectorsOnly) {
        [self addComputedVector:nil];
    } else {
        NSRect frame = [(NSButton *)sender frame];
        
        NSSize menuSize = [self.addElementMenu size];
        NSPoint menuOrigin = [[(NSButton *)sender superview] convertPoint:NSMakePoint(frame.origin.x, frame.origin.y+frame.size.height+menuSize.height) toView:nil];
        
        NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                             location:menuOrigin
                                        modifierFlags:NSLeftMouseDownMask
                                            timestamp:0.0
                                         windowNumber:[[(NSButton *)sender window] windowNumber]
                                              context:[[(NSButton *)sender window] graphicsContext]
                                          eventNumber:0
                                           clickCount:1
                                             pressure:1];
        
        [NSMenu popUpContextMenu:self.addElementMenu withEvent:event forView:(NSButton *)sender];
    }
}

- (void)addAndSelectVector:(JSGeneralVector *)vector
{
    [self.vectors addVector:vector];
    
    [self insertNewRowInMainTable];
}

- (IBAction)addVector:(id)sender
{
    JSVector *newVector = [[JSVector alloc] init];
    [self addAndSelectVector:newVector];
}

- (IBAction)addComputedVector:(id)sender
{
    JSComputedVector *newVector = [[JSComputedVector alloc] init];
    [self addAndSelectVector:newVector];
}

- (IBAction)addNoiseVector:(id)sender
{
    JSNoiseVector *newVector = [[JSNoiseVector alloc] init];
    [self addAndSelectVector:newVector];
}

-(void)deleteElement:(id)sender
{
    NSInteger row = [self.mainTableView selectedRow];
    [self.vectors deleteVectorAtIndex:row-self.biasCells];
    [self.mainTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
    if ([self.vectors numberOfVectors]==0) [self.treeController.bottomBar enableDeleteButton:NO];
}

#pragma mark - Cell editing methods

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *sender = [obj object];
    //    NSString *enteredString = [sender.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *senderIdentifier = [sender identifier];
    //    NSInteger row = [self.mainTableView rowForView:sender];
    
    if ([senderIdentifier isEqualToString:@"name"] || [senderIdentifier isEqualToString:@"cdataString"] || [senderIdentifier isEqualToString:@"filename"] || [senderIdentifier isEqualToString:@"seed"] || [senderIdentifier isEqualToString:@"definition"] || [senderIdentifier isEqualToString:@"mean"]) {
        
        NSString *enteredString = [sender.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSInteger row = [self.mainTableView rowForView:sender];
        
        id value = nil;
        if ([enteredString length]) value = enteredString;
        
        id element = (self.vectors.vectors)[row];
        [element setValue:value forKeyPath:senderIdentifier];
    }
}

#pragma mark - Tokenfields completion delegate method

- (NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex
{
    NSString *senderIdentifier = [tokenField identifier];
    if ([senderIdentifier isEqualToString:@"dimensions"]) {
        return [self.vectors.root listOfDimensionsForSubstring:substring];
    } else if (([senderIdentifier isEqualToString:@"initialBasis"]) || ([senderIdentifier isEqualToString:@"dependencies.basis"])) {
        return [self.vectors.root listOfBasisForSubstring:substring];
    } else if ([senderIdentifier isEqualToString:@"dependencies.vectors"]) {
        return [self.vectors.root listOfVectorsForSubstring:substring];
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
        
        id element = (self.vectors.vectors)[row];
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
    
    id element = (self.vectors.vectors)[row];
    [element setValue:[tokenField objectValue] forKeyPath:tokenFieldIdentifier];
}

- (BOOL)tokenField:(JSTokenField *)tokenField shouldAddEmptyTokenAtIndex:(NSUInteger)index
{
    if ([[tokenField identifier] isEqualToString:@"dimensions"]) {
        if ([[tokenField objectValue] count] == 0) {
            NSInteger row = [self.mainTableView rowForView:tokenField];
            id element = (self.vectors.vectors)[row];
            [element setValue:[NSArray arrayWithObject:@""] forKeyPath:@"dimensions"];
            return YES;
        }
        NSAlert *invalidemptyAlert = [NSAlert alertWithMessageText:@"Vector has already dimensions" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"This vector is already defined with dimensions. In order to make it have no dimensions delete first the current dimensions."];
        [invalidemptyAlert beginSheetModalForWindow:[[self view] window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
    return NO;
}

# pragma mark - Popup buttons method

- (IBAction)popUpButtonPressed:(id)sender
{
    NSInteger row = [self.mainTableView rowForView:sender];
    if (row != -1) {
        NSInteger selection = [sender indexOfSelectedItem];
        NSString *senderIdentifier = [sender identifier];
        if ([(self.vectors.vectors)[row] isKindOfClass:[JSVector class]]) {
            JSVector *vector = (self.vectors.vectors)[row];
            if ([senderIdentifier isEqualToString:@"initialisationButton"]) {
                vector.initialisation = selection;
                NSString *initialisationString = (vector.initialisationOptions)[selection];
                
                JSVectorTableCellView *changedCell = [self.mainTableView viewAtColumn:0 row:row makeIfNecessary:NO];
                
                if ([initialisationString isEqualToString:@"xsil"] || [initialisationString isEqualToString:@"hdf5"])
                    [changedCell setVectorCellState:JSVectorCellInFilenameState];
                else if ([initialisationString isEqualToString:@"cdata"])
                    [changedCell setVectorCellState:JSVectorCellInCDATAState];
                else [changedCell setVectorCellState:JSVectorCellInZeroState];
            }
        } else if ([(self.vectors.vectors)[row] isKindOfClass:[JSNoiseVector class]]) {
            JSNoiseVector *vector = (self.vectors.vectors)[row];
            if ([senderIdentifier isEqualToString:@"kindButton"]) {
                vector.kind = selection;
                NSString *kindString = (vector.kindOptions)[vector.kind];
                JSNoiseVectorTableCellView *changedCell = [self.mainTableView viewAtColumn:0 row:row makeIfNecessary:NO];
                if ([kindString isEqualToString:@"jump"] || [kindString isEqualToString:@"poissonian"])
                    [changedCell setNoiseVectorCellState:JSNoiseVectorCellWithMeanState];
                else
                    [changedCell setNoiseVectorCellState:JSNoiseVectorCellWithoutMeanState];
            } else if ([senderIdentifier isEqualToString:@"methodButton"]) {
                vector.method = selection;
            }
        }
        if ([senderIdentifier isEqualToString:@"typeButton"]) {
            JSGeneralVector *vector = (self.vectors.vectors)[row];
            vector.type = selection;
        }
        if (row != [self.mainTableView selectedRow]) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}

#pragma mark - Syntax highlighter delegate

-(NSArray *)userIdentifiersForKeywordComponentName:(NSString *)inModeName
{
    NSMutableArray *identifiers = [[self.vectors.root listOfDimensionsIdentifiersForBasis] mutableCopy];
    [identifiers addObjectsFromArray:[self.vectors.root listOfVectorComponentsIdentifiers]];
    [identifiers addObjectsFromArray:[self.vectors.root listOfArgumentsIdentifiers]];
    return identifiers;
}

# pragma mark - Section title

- (NSString *)title
{
    return self.vectors.description;
}

- (NSString *)sectionSuffix
{
    return @"vectorelement";
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
    
    NSArray *draggedObjects = [self.vectors.vectors objectsAtIndexes:rowIndexes];
    [self.vectors deleteVectorsAtIndexes:rowIndexes];
    
    for (id draggedObject in draggedObjects) {
        [self.vectors addVector:draggedObject atIndex:insertIndex];
        insertIndex++;
    }
    
    [self.mainTableView reloadData];
    
    return YES;
}


@end
