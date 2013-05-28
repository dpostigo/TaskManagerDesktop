//
//  JSFiltersViewController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSFiltersViewController.h"
#import "JSFilterTableCellView.h"
#import "JSWhereTableCellView.h"
#import "JSFilter.h"
#import "JSFilters.h"

@interface JSFiltersViewController()

@property (nonatomic, strong) JSFilters *filters;

@property (strong) IBOutlet NSMenu *addElementMenu;
@property (nonatomic, strong) JSSyntaxHighlighter *syntaxHighlighter;

@property (nonatomic, strong) JSFilterTableCellView *filterDummyCell;
@property (nonatomic, strong) JSWhereTableCellView *whereDummyCell;

@end

@implementation JSFiltersViewController

#pragma mark - Setter and getters

// The dummy cells are used to compute the height of the cells at runtime

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

- (JSWhereTableCellView *)whereDummyCell
{
    if (!_whereDummyCell) {
        _whereDummyCell = [self.mainTableView makeViewWithIdentifier:@"whereCell" owner:self];
        _whereDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_whereDummyCell
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:500.0f];
        [_whereDummyCell addConstraint:_whereDummyCell.widthConstraint];
    }
    return _whereDummyCell;
}

- (void)resizeDummyCells
{
    [self.filterDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.filterDummyCell layoutSubtreeIfNeeded];
    [self.whereDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.whereDummyCell layoutSubtreeIfNeeded];
}

- (id)representedObject
{
    return self.filters;
}

- (void)setRepresentedObject:(id)representedObject
{
    if ([representedObject isKindOfClass:[JSFilters class]]) self.filters = representedObject;
}

# pragma mark - init and destroy methods

- (id)initWithFilters:(JSFilters *)filters
{
    self = [super initWithNibName:@"JSFiltersViewController" bundle:nil];
    if (self) {
        self.filters = filters;
        self.syntaxHighlighter = [[JSSyntaxHighlighter alloc] init];
        [self.syntaxHighlighter setDelegate:self];
        self.biasCells = 1;
    }
    return self;
}

-(void)dealloc
{
    if (self.syntaxHighlighter.delegate == self) self.syntaxHighlighter.delegate = nil;
}

- (void)viewDidAppear
{
    [self.treeController.bottomBar setNewLabel:@"New Filter"];
    [self.treeController.bottomBar enableNewButton:YES];
    [self.treeController.bottomBar showBackButton:YES withAnimation:YES];
    [self.treeController.bottomBar enableDeleteButton:NO];
}

#pragma mark - Data source and delegate of the table view

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.filters.numberOfFilters + self.biasCells;
}

- (void)fillFilterCell:(JSFilterTableCellView *)cellView atRow:(NSUInteger)row
{
    JSFilter *filter = (self.filters.filters)[row-self.biasCells];
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

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row == 0) {
        JSWhereTableCellView *cellView = (JSWhereTableCellView *)[tableView makeViewWithIdentifier:@"whereCell" owner:self];
        [cellView.whereButton removeAllItems];
        [cellView.whereButton addItemsWithTitles:self.filters.whereOptions];
        [cellView.whereButton selectItemAtIndex:self.filters.where];
        return cellView;
    } else {
        JSFilterTableCellView *cellView = (JSFilterTableCellView *)[tableView makeViewWithIdentifier:@"filterCell" owner:self];
        cellView.definitionTextField.syntaxHighlighter = self.syntaxHighlighter;
        [self fillFilterCell:cellView atRow:row];
        cellView.definitionTextField.keepsEditingOnReturn = YES;
        return cellView;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row 
{
    if (row == 0) {
        return [self.whereDummyCell fittingSize].height;
    } else {
        [self fillFilterCell:self.filterDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.filterDummyCell fittingSize].height;
    }
}

#pragma mark - Bottom bar delegate methods

-(void)addElement:(id)sender
{
    JSFilter *newFilter = [[JSFilter alloc] init];
    [self.filters addFilter:newFilter];

    [self insertNewRowInMainTable];
}

-(void)deleteElement:(id)sender
{
    NSInteger row = [self.mainTableView selectedRow];
    [self.filters deleteFilterAtIndex:row-self.biasCells];
    [self.mainTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
    if ([self.filters numberOfFilters] == 0) [self.treeController.bottomBar enableDeleteButton:NO];
}

#pragma mark - Cell editing methods

// We use key value coding to assign changes in the various controls to the model
// The identifier of the controls are equal to the keyPath of the properties we want to set
- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *sender = [obj object];
    NSString *senderIdentifier = [sender identifier];
    
    // the entries in the token field gets handled in another method so we have to make sure we are only setting the properties we want here
    if ([senderIdentifier isEqualToString:@"name"] || [senderIdentifier isEqualToString:@"evaluation"]) {
    
        NSString *enteredString = [sender.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSInteger row = [self.mainTableView rowForView:sender];
    
        id value = nil;
        if ([enteredString length]) value = enteredString;
        
        id element = (self.filters.filters)[row-self.biasCells];
        [element setValue:value forKeyPath:senderIdentifier];
    }
}

# pragma mark - Popup buttons method

- (IBAction)popUpButtonPressed:(id)sender
{
    NSInteger row = [self.mainTableView rowForView:sender];
    if (row != -1) {
        NSInteger selection = [sender indexOfSelectedItem];
        self.filters.where = selection;
        if (row != [self.mainTableView selectedRow]) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}

#pragma mark - Tokenfields completion delegate method

- (NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex
{
    NSString *senderIdentifier = [tokenField identifier];
    if ([senderIdentifier isEqualToString:@"dependencies.basis"]) {
        return [self.filters.root listOfBasisForSubstring:substring];
    } else if ([senderIdentifier isEqualToString:@"dependencies.vectors"]) {
        return [self.filters.root listOfVectorsForSubstring:substring];
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
        
        id element = (self.filters.filters)[row-self.biasCells];
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
    
    id element = (self.filters.filters)[row-self.biasCells];
    [element setValue:[tokenField objectValue] forKeyPath:tokenFieldIdentifier];
}

#pragma mark - Syntax highlighter delegate

-(NSArray *)userIdentifiersForKeywordComponentName:(NSString *)inModeName
{
    NSMutableArray *identifiers = [[self.filters.root listOfDimensionsIdentifiersForBasis] mutableCopy];
    [identifiers addObjectsFromArray:[self.filters.root listOfVectorComponentsIdentifiers]];
    [identifiers addObjectsFromArray:[self.filters.root listOfArgumentsIdentifiers]];
    return identifiers;
}

# pragma mark - Section title

- (NSString *)title
{
    return self.filters.description;
}

- (NSString *)sectionSuffix
{
    return @"filterselement";
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
    
    NSArray *draggedObjects = [self.filters.filters objectsAtIndexes:rowIndexes];
    [self.filters deleteFiltersAtIndexes:rowIndexes];
    
    for (id draggedObject in draggedObjects) {
        [self.filters addFilter:draggedObject atIndex:insertIndex];
        insertIndex++;
    }
    
    [self.mainTableView reloadData];
    
    return YES;
}

@end
