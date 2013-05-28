//
//  JSOutputViewController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 16/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSOutputViewController.h"
#import "JSOutput.h"
#import "JSGroup.h"
#import "JSGroupTableCellView.h"
#import "JSIntroductionTableCellView.h"

@interface JSOutputViewController ()

@property (nonatomic, strong) JSOutput *output;

@property (nonatomic, strong) JSSyntaxHighlighter *syntaxHighlighter;
@property (readonly, strong) NSArray *subSampling;

@property (nonatomic, strong) JSGroupTableCellView *groupDummyCell;
@property (nonatomic, strong) JSIntroductionTableCellView *introductionDummyCell;

@end

@implementation JSOutputViewController

- (NSArray *)subSampling {
    return @[@32, @20, @16, @15, @10, @8, @6, @5, @4, @3, @2];
}

#pragma mark - Setter and getters

// The dummy cells are used to compute the height of the cells at runtime

- (JSGroupTableCellView *)groupDummyCell
{
    if (!_groupDummyCell) {
        _groupDummyCell = [self.mainTableView makeViewWithIdentifier:@"groupCell" owner:self];
        _groupDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_groupDummyCell
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0f
                                                                        constant:500.0f];
        [_groupDummyCell addConstraint:_groupDummyCell.widthConstraint];
    }
    return _groupDummyCell;
}

- (JSIntroductionTableCellView *)introductionDummyCell
{
    if (!_introductionDummyCell) {
        _introductionDummyCell = [self.mainTableView makeViewWithIdentifier:@"introductionCell" owner:self];
        _introductionDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_introductionDummyCell
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.0f
                                                                               constant:500.0f];
        [_introductionDummyCell addConstraint:_introductionDummyCell.widthConstraint];
    }
    return _introductionDummyCell;
}

- (void)resizeDummyCells
{
    [self.groupDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.groupDummyCell layoutSubtreeIfNeeded];
    [self.introductionDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.introductionDummyCell layoutSubtreeIfNeeded];
}

- (id)representedObject
{
    return self.output;
}

- (void)setRepresentedObject:(id)representedObject
{
    if ([representedObject isKindOfClass:[JSOutput class]]) self.output = representedObject;
}

# pragma mark - init and destroy methods

- (id)initWithOutput:(JSOutput *)output
{
    self = [super initWithNibName:@"JSOutputViewController" bundle:nil];
    if (self) {
        self.output = output;
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
    [self.treeController.bottomBar setNewLabel:@"New Group"];
    [self.treeController.bottomBar enableNewButton:YES];
    [self.treeController.bottomBar enableDeleteButton:NO];
    [self.treeController.bottomBar showBackButton:NO withAnimation:YES];
}

#pragma mark - Data source and delegate of the table view

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.output.numberOfGroups + self.biasCells;
}

- (void)fillIntroductionCell:(JSIntroductionTableCellView *)cellView
{
    [cellView.formatButton removeAllItems];
    [cellView.formatButton addItemsWithTitles:self.output.formatOptions];
    [cellView.formatButton selectItemAtIndex:self.output.format];
    if (self.output.filename) cellView.filenameTextField.stringValue = self.output.filename;
}

- (void)fillGroupCell:(JSGroupTableCellView *)cellView atRow:(NSInteger)row
{
    JSGroup *group = (self.output.groups)[row-self.biasCells];
    
    if (group.name) cellView.nameTextField.stringValue = group.name;
    else cellView.nameTextField.stringValue = @"";
    
    [cellView.basisTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (group.samplingBasis) [cellView.basisTokenField setObjectValue:group.samplingBasis];
    else [cellView.basisTokenField setObjectValue:nil];
    
    cellView.initialSampleCheckBox.state = group.initialSample;
    
    NSNumber *computedVectorNumber = @(group.computedVectors.numberOfVectors);
    cellView.computedVectorsButton.title = [computedVectorNumber stringValue];
    
    NSNumber *operatorNumber = @(group.operators.numberOfOperators);
    cellView.operatorButton.title = [operatorNumber stringValue];
    
    [cellView.momentsTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (group.moments) [cellView.momentsTokenField setObjectValue:group.moments];
    else [cellView.momentsTokenField setObjectValue:nil];
    
    [cellView.dependenciesTokenField setTokenizingCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (group.dependencies.vectors) [cellView.dependenciesTokenField setObjectValue:group.dependencies.vectors];
    else [cellView.dependenciesTokenField setObjectValue:nil];
    
    if (group.definition) cellView.definitionTextField.stringValue = group.definition;
    else cellView.definitionTextField.stringValue = @"";
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row == 0) {
        JSIntroductionTableCellView *cellView = (JSIntroductionTableCellView *)[tableView makeViewWithIdentifier:@"introductionCell" owner:self];
        [self fillIntroductionCell:cellView];
        return cellView;
    } else {
        JSGroupTableCellView *cellView = (JSGroupTableCellView *)[tableView makeViewWithIdentifier:@"groupCell" owner:self];
        cellView.definitionTextField.syntaxHighlighter = self.syntaxHighlighter;
        [self fillGroupCell:cellView atRow:row];
        cellView.definitionTextField.keepsEditingOnReturn = YES;
        return cellView;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if (row == 0) {
        return [self.introductionDummyCell fittingSize].height;
    } else {
        [self fillGroupCell:self.groupDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.groupDummyCell fittingSize].height;
    }
}

#pragma mark - Methods to add or delete elements to the output section

-(void)addElement:(id)sender
{
    JSGroup *newGroup = [[JSGroup alloc] init];
    [self.output addGroup:newGroup];
    
    [self insertNewRowInMainTable];
}

-(void)deleteElement:(id)sender
{
    NSInteger row = [self.mainTableView selectedRow];
    [self.output deleteGroupAtIndex:row-self.biasCells];
    [self.mainTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
}

# pragma mark - Filters and Operators buttons

-(IBAction)subsectionButtonPressed:(id)sender
{
    NSInteger row = [self.mainTableView rowForView:sender];
    if (row != -1) {
        NSString *senderIdentifier = [sender identifier];
        JSGroup *group = (self.output.groups)[row-self.biasCells];
        JSNode *newObject = [group valueForKey:senderIdentifier];
        [self.treeController showSubsectionForObject:newObject];
    }
}

#pragma mark - Cell editing methods

// We use key value coding to assign changes in the various controls to the model
// The identifier of the controls are equal to the keyPath of the properties we want to set
- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *sender = [obj object];
    NSString *senderIdentifier = [sender identifier];
    
    // the entries in the token field gets handled in another method so we have to make sure we are only setting the properties we want here
    if ([senderIdentifier isEqualToString:@"name"] || [senderIdentifier isEqualToString:@"definition"] || [senderIdentifier isEqualToString:@"filename"]) {
        
        NSString *enteredString = [sender.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSInteger row = [self.mainTableView rowForView:sender];
        
        id value = nil;
        if ([enteredString length]) value = enteredString;
        
        id element;
        if (row) element = (self.output.groups)[row-self.biasCells];
        else element = self.output;
        [element setValue:value forKeyPath:senderIdentifier];
    }
}

# pragma mark - Popup buttons method

- (IBAction)popUpButtonPressed:(id)sender
{
    NSInteger selection = [sender indexOfSelectedItem];
    self.output.format = selection;
    if ([self.mainTableView selectedRow] != 0) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

# pragma mark - check box method

- (IBAction)initialSampleCheckedBoxPressed:(id)sender
{
    NSNumber *buttonState = @( [sender state] );
    NSInteger row = [self.mainTableView rowForView:sender];
    id element = (self.output.groups)[row-self.biasCells];
    [element setValue:buttonState forKey:[sender identifier]];
    if (row != [self.mainTableView selectedRow]) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
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
        
        id element = (self.output.groups)[row-self.biasCells];
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
    
    id element = (self.output.groups)[row-self.biasCells];
    [element setValue:[tokenField objectValue] forKeyPath:tokenFieldIdentifier];
}

- (NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex
{
    NSString *senderIdentifier = [tokenField identifier];
    if ([senderIdentifier isEqualToString:@"samplingBasis"]) {
        return [self.output.root listOfBasisForSubstring:substring];
    } else if ([senderIdentifier isEqualToString:@"dependencies.vectors"]) {
        return [self.output.root listOfVectorsForSubstring:substring];
    }
    return nil;
}

- (BOOL)tokenField:(NSTokenField *)tokenField hasMenuForRepresentedObject:(id)representedObject
{
    if ([[tokenField identifier] isEqualToString:@"samplingBasis"] && [representedObject length]) return YES;
    return NO;
}

// every token in the sampling element has menu providing a small subset of possible sampling given the number of points for the dimension
- (NSMenu *)tokenField:(NSTokenField *)tokenField menuForRepresentedObject:(id)representedObject
{
    NSNumber *gridPoints = [self.output.root gridPointsForDimension:[self extractDimensionName:representedObject]];
    if (gridPoints) {
        NSMutableArray *subSampledGrid = [NSMutableArray arrayWithCapacity:0];
        for (NSNumber *number in self.subSampling) {
            if ([gridPoints intValue] % [number intValue] == 0) {
                [subSampledGrid addObject:@([gridPoints intValue]/[number intValue])];
            }
        }
        
        // in handling the menu item press and changing the sampling we need to know which token field and token originated the call
        // we package the information in a dictionary to attach to the representedObject property of the menuitem
        NSDictionary *info = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:representedObject, tokenField, nil] forKeys:[NSArray arrayWithObjects:@"token", @"tokenField", nil]];
        
        NSMenu *tokenMenu = [[NSMenu alloc] init];
        NSMenuItem *zeroItem = [[NSMenuItem alloc] initWithTitle:@"0" action:@selector(changeSampling:) keyEquivalent:@""];
        [zeroItem setTarget:self];
        [zeroItem setRepresentedObject:info];
        [tokenMenu addItem:zeroItem];
        
        for (NSNumber *sampling in subSampledGrid) {
            NSMenuItem *finiteItem = [[NSMenuItem alloc] initWithTitle:[sampling stringValue] action:@selector(changeSampling:) keyEquivalent:@""];
            [finiteItem setTarget:self];
            [finiteItem setRepresentedObject:info];
            [tokenMenu addItem:finiteItem];
        }
        return tokenMenu;
    }
    return nil;
}

// here we take a string in the form " dimensionName ( sampling ) " coming from the token field and then extract " dimensionName " which is returned by the method
- (NSString *)extractDimensionName:(NSString *)basisString
{
    NSRange locationOfSamplingParenthesis = [basisString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"("]];
    if (locationOfSamplingParenthesis.location != NSNotFound) {
        NSRange basisNameRange = NSMakeRange(0, locationOfSamplingParenthesis.location);
        return [basisString substringWithRange:basisNameRange];
    } else return basisString;
}

// here we take a string in the form " dimensionName ( sampling ) " coming from the token field and then extract " sampling " which is returned by the method
- (NSNumber *)extractSampling:(NSString *)basisString
{
    NSRange locationOfSamplingParenthesis = [basisString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"("]];
    if (locationOfSamplingParenthesis.location != NSNotFound) {
        NSRange samplingRange = NSMakeRange(locationOfSamplingParenthesis.location+1, [basisString length]-2-locationOfSamplingParenthesis.location);
        return @([[basisString substringWithRange:samplingRange] intValue]);
    } else return nil;
}

- (void)changeSampling:(id)sender
{
    NSString *menuString = ((NSMenuItem *)sender).title;
    NSDictionary *info = ((NSMenuItem *)sender).representedObject;
    NSString *clickedToken = [info valueForKey:@"token"];
    JSTokenField *originatingTokenField = [info valueForKey:@"tokenField"];
    NSMutableArray *tokens = [originatingTokenField.objectValue mutableCopy];
    NSUInteger tokenIndex = [tokens indexOfObject:clickedToken];
    
    NSInteger row = [self.mainTableView rowForView:originatingTokenField];
    JSGroup *group = (self.output.groups)[row-self.biasCells];
    
    NSString *samplingString = [@"(" stringByAppendingString:menuString];
    samplingString = [samplingString stringByAppendingString:@")"];
    tokens[tokenIndex] = [[self extractDimensionName:clickedToken] stringByAppendingString:samplingString];
    [originatingTokenField setObjectValue:[tokens copy]];
    group.samplingBasis = [tokens copy];
}

#pragma mark - Syntax highlighter delegate

-(NSArray *)userIdentifiersForKeywordComponentName:(NSString *)inModeName
{
    NSMutableArray *identifiers = [[self.output.root listOfDimensionsIdentifiersForBasis] mutableCopy];
    [identifiers addObjectsFromArray:[self.output.root listOfVectorComponentsIdentifiers]];
    [identifiers addObjectsFromArray:[self.output.root listOfArgumentsIdentifiers]];
    [identifiers addObjectsFromArray:[self.output.root listOfMomentsIdentifiers]];
    return identifiers;
}

# pragma mark - Section title

- (NSString *)title
{
    return self.output.description;
}

- (NSString *)sectionSuffix
{
    return @"outputelement";
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
    
    NSArray *draggedObjects = [self.output.groups objectsAtIndexes:rowIndexes];
    [self.output deleteGroupsAtIndexes:rowIndexes];
    
    for (id draggedObject in draggedObjects) {
        [self.output addGroup:draggedObject atIndex:insertIndex];
        insertIndex++;
    }
    
    [self.mainTableView reloadData];
    
    return YES;
}

@end
