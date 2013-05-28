//
//  JSFeaturesViewController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSFeaturesViewController.h"
#import "JSFeatures.h"
#import "JSArgument.h"
#import "JSDriver.h"
#import "JSOptionsTableCellView.h"
#import "JSDriverTableCellView.h"
#import "JSArgumentTableCellView.h"

@interface JSFeaturesViewController ()

- (IBAction)optionsCheckedBoxPressed:(id)sender;
- (IBAction)popUpButtonPressed:(id)sender;

// model properties
@property (nonatomic, strong) JSFeatures *features;
@property (nonatomic, strong) JSDriver *driver;

// syntax highlighter
@property (nonatomic, strong) JSSyntaxHighlighter *syntaxHighlighter;

// dummy cells
@property (nonatomic, strong) JSOptionsTableCellView *optionsDummyCell;
@property (nonatomic, strong) JSDriverTableCellView *driverDummyCell;
@property (nonatomic, strong) JSArgumentTableCellView *argumentDummyCell;

@end

@implementation JSFeaturesViewController

#pragma mark - Setter and getters

// The dummy cells are used to compute the height of the cells at runtime (see JSPreambleViwController.m)
- (JSOptionsTableCellView *)optionsDummyCell
{
    if (!_optionsDummyCell) {
        _optionsDummyCell = [self.mainTableView makeViewWithIdentifier:@"optionsCell" owner:self];
        _optionsDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_optionsDummyCell
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f
                                                                          constant:500.0f];
        [_optionsDummyCell addConstraint:_optionsDummyCell.widthConstraint];
    }
    return _optionsDummyCell;
}

- (JSDriverTableCellView *)driverDummyCell
{
    if (!_driverDummyCell) {
        _driverDummyCell = [self.mainTableView makeViewWithIdentifier:@"driverCell" owner:self];
        _driverDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_driverDummyCell
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:500.0f];
        [_driverDummyCell addConstraint:_driverDummyCell.widthConstraint];
    }
    return _driverDummyCell;
}

- (JSArgumentTableCellView *)argumentDummyCell
{
    if (!_argumentDummyCell) {
        _argumentDummyCell = [self.mainTableView makeViewWithIdentifier:@"argumentCell" owner:self];
        _argumentDummyCell.widthConstraint = [NSLayoutConstraint constraintWithItem:_argumentDummyCell
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f
                                                                           constant:500.0f];
        [_argumentDummyCell addConstraint:_argumentDummyCell.widthConstraint];
    }
    return _argumentDummyCell;
}

- (void)resizeDummyCells
{
    [self.optionsDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.optionsDummyCell layoutSubtreeIfNeeded];
    [self.driverDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.driverDummyCell layoutSubtreeIfNeeded];
    [self.argumentDummyCell.widthConstraint setConstant:self.mainTableView.frame.size.width];
    [self.argumentDummyCell layoutSubtreeIfNeeded];
}

- (id)representedObject
{
    return @{@"features" : self.features, @"driver" : self.driver};
}

- (void)setRepresentedObject:(id)representedObject
{
    if ([representedObject isKindOfClass:[NSDictionary class]]) {
        self.features = [representedObject objectForKey:@"features"];
        self.driver = [representedObject objectForKey:@"driver"];
    }
}

#pragma mark - Init and destroy methods

- (id)initWithFeatures:(JSFeatures *)features driver:(JSDriver *)driver
{
    self = [super initWithNibName:@"JSFeaturesViewController" bundle:nil];
    if (self) {
        // set the model
        self.features = features;
        self.driver = driver;
        
        // set the number of fixed cells (the driver cell and options cell)
        self.biasCells = 2;
        
        // initialise the syntax highlighter
        self.syntaxHighlighter = [[JSSyntaxHighlighter alloc] init];
        [self.syntaxHighlighter setDelegate:self];
    }
    return self;
}

-(void)dealloc
{
    if (self.syntaxHighlighter.delegate == self) self.syntaxHighlighter.delegate = nil;
}

-(void)viewDidAppear
{
    // set the appeareance of the left group of buttons in the bottom bar
    [self.treeController.bottomBar enableDeleteButton:NO];
    [self.treeController.bottomBar enableNewButton:YES];
    [self.treeController.bottomBar setNewLabel:@"New Argument"];
    [self.treeController.bottomBar showBackButton:NO withAnimation:YES];
}


#pragma mark - Data source and delegate of the table view

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.features.numberOfArguments+self.biasCells;
}

- (void)fillOptionsCell:(JSOptionsTableCellView *)cellView
{
    [cellView.fftwPopUpButton removeAllItems];
    [cellView.fftwPopUpButton addItemsWithTitles:[self.features fftwOptions]];
    [cellView.fftwPopUpButton selectItemAtIndex:self.features.fftw];
    
    if (self.features.fftwThreads) cellView.fftwThreadsTextField.stringValue = [@(self.features.fftwThreads) stringValue];
    else cellView.fftwThreadsTextField.stringValue = @"";
    
    [cellView.validationPopUpButton removeAllItems];
    [cellView.validationPopUpButton addItemsWithTitles:[self.features validationOptions]];
    [cellView.validationPopUpButton selectItemAtIndex:self.features.validation];
    
    [cellView.precisionPopUpButton removeAllItems];
    [cellView.precisionPopUpButton addItemsWithTitles:[self.features precisionOptions]];
    [cellView.precisionPopUpButton selectItemAtIndex:self.features.precision];
    
    if (self.features.chunkedOutput) cellView.chunkedOutputTextField.stringValue = self.features.chunkedOutput;
    else cellView.chunkedOutputTextField.stringValue = @"";
    
    cellView.autoVectoriseButton.state = self.features.autoVectorise;
    cellView.haltNonFiniteButton.state = self.features.haltNonFinite;
    cellView.openMPButton.state = self.features.openMP;
    cellView.bingButton.state = self.features.bing;
    cellView.benchmarkButton.state = self.features.benchmark;
    cellView.errorCheckButton.state = self.features.errorCheck;
    cellView.diagnosticsButton.state = self.features.diagnostics;
    
    if (self.features.globals) cellView.globalsTextField.stringValue = self.features.globals;
    else cellView.globalsTextField.stringValue = @"";
    
    if (self.features.argumentsGlobals) cellView.argumentsCDATATextField.stringValue = self.features.argumentsGlobals;
    else cellView.argumentsCDATATextField.stringValue = @"";
}

- (void)fillDriverCell:(JSDriverTableCellView *)cellView
{
    [cellView.typeButton removeAllItems];
    [cellView.typeButton addItemsWithTitles:self.driver.typeOptions];
    [cellView.typeButton selectItemAtIndex:self.driver.type];
    
    if (self.driver.paths) cellView.pathsTextField.stringValue = self.driver.paths;
    else cellView.pathsTextField.stringValue = @"";
    
    [self setCellState:cellView];
}

// convenience method to set the state of the driver cell passed as an argument
- (void)setCellState:(JSDriverTableCellView *)cellView
{
    NSString *typeString = (self.driver.typeOptions)[self.driver.type];
    if (([typeString isEqualToString:@"none"]) || ([typeString isEqualToString:@"distributed-mpi"]))
        [cellView setDriverCellState:JSDriverCellNoneOrDistributedMPIState];
    else
        [cellView setDriverCellState:JSDriverCellMultiPathState];
}

- (void)fillArgumentCell:(JSArgumentTableCellView *)cellView atRow:(NSInteger)row
{
    JSArgument *argument = (self.features.arguments)[row-self.biasCells];
    
    if (argument.name) cellView.nameTextField.stringValue = argument.name;
    else cellView.nameTextField.stringValue = @"";
    
    [cellView.typeButton removeAllItems];
    [cellView.typeButton addItemsWithTitles:[argument typeOptions]];
    [cellView.typeButton selectItemAtIndex:argument.type];
    
    if (argument.defaultValue) cellView.defaultValueTextField.stringValue = argument.defaultValue;
    else cellView.defaultValueTextField.stringValue = @"";
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row == 0) {
        JSDriverTableCellView *cellView = (JSDriverTableCellView *)[tableView makeViewWithIdentifier:@"driverCell" owner:self];
        
        [self fillDriverCell:cellView];
        
        cellView.delegate = (id)self;
        
        return cellView;
    } else if (row == 1) {
        JSOptionsTableCellView *cellView = (JSOptionsTableCellView *)[tableView makeViewWithIdentifier:@"optionsCell" owner:self];
        
        // we set the syntax highlighter before filling the cell so that when the setter of the stringValue of the textField field is called the string is automatically recolored
        cellView.globalsTextField.syntaxHighlighter = self.syntaxHighlighter;
        cellView.argumentsCDATATextField.syntaxHighlighter = self.syntaxHighlighter;
        
        [self fillOptionsCell:cellView];
        
        cellView.globalsTextField.keepsEditingOnReturn = YES;
        cellView.argumentsCDATATextField.keepsEditingOnReturn = YES;
        
        return cellView;
    } else {
        JSArgumentTableCellView *cellView = (JSArgumentTableCellView *)[tableView makeViewWithIdentifier:@"argumentCell" owner:self];
        
        [self fillArgumentCell:cellView atRow:row];
        
        return cellView;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if (row == 0) {
        [self fillDriverCell:self.driverDummyCell];
        [self resizeDummyCells];
        return [self.driverDummyCell fittingSize].height;
    } else if (row == 1) {
        [self fillOptionsCell:self.optionsDummyCell];
        [self resizeDummyCells];
        return [self.optionsDummyCell fittingSize].height;
    } else {
        [self fillArgumentCell:self.argumentDummyCell atRow:row];
        [self resizeDummyCells];
        return [self.argumentDummyCell fittingSize].height;
    }
}

#pragma mark - Methods to add and delete

-(void)addElement:(id)sender
{
    // instantiate a new argument and add it to features
    JSArgument *newArgument = [[JSArgument alloc] init];
    [self.features addArgument:newArgument];
    
    // insert the new row in the table view and select it
    [self insertNewRowInMainTable];
}

-(void)deleteElement:(id)sender
{
    NSInteger row = [self.mainTableView selectedRow];
    [self.features deleteArgumentAtIndex:row-self.biasCells];
    [self.mainTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:NSTableViewAnimationEffectFade];
}

#pragma mark - Actions for the buttons

// as for the textField we use the key-value pattern. Each checkBox identifier is equal to the property we need to set and we can use as key
- (IBAction)optionsCheckedBoxPressed:(id)sender
{
    NSNumber *buttonState = @( [sender state] );
    [self.features setValue:buttonState forKey:[sender identifier]];
    if ([self.mainTableView selectedRow] != 1) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}


-(void)popUpButtonPressed:(id)sender
{
    NSInteger selection = [sender indexOfSelectedItem];
    NSInteger row = [self.mainTableView rowForView:sender];
    // the rowForView: method of the tableView returns -1 if the view is not part of the tableView
    // we make sure that the call came from one of the view of the tableView
    // this is not strictly necessary as the tableView and its views are the onyl things in the view controller but better be safe
    if (row != -1) {
        if (row == 0) {
            self.driver.type = selection;
            JSDriverTableCellView *cellView = (JSDriverTableCellView *)[self.mainTableView viewAtColumn:0 row:0 makeIfNecessary:NO];
            [self setCellState:cellView];
        } else if (row == 1) {
            [self.features setValue:@(selection) forKey:[sender identifier]];
        } else if (row >= self.biasCells) {
            JSArgument *argument = (self.features.arguments)[row-self.biasCells];
            argument.type = selection;
        }
        // make sure that the cell we just edited is selected
        if (row != [self.mainTableView selectedRow]) [self.mainTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}

#pragma mark - Textfields delegate methods

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSTextField *sender = [obj object];
    NSString *enteredString = [sender.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *senderIdentifier = [sender identifier];
    
    id value = nil;
    if ([enteredString length]) value = enteredString;
    
    if (([senderIdentifier isEqualToString:@"name"]) || ([senderIdentifier isEqualToString:@"defaultValue"])) {
        NSInteger row = [self.mainTableView rowForView:sender];
        JSArgument *argument = (self.features.arguments)[row-self.biasCells];
        [argument setValue:value forKeyPath:senderIdentifier];
    } else if ([senderIdentifier isEqualToString:@"globals"] || [senderIdentifier isEqualToString:@"argumentsGlobals"] || [[sender identifier] isEqualToString:@"chunkedOutput"]) {
        [self.features setValue:value forKeyPath:senderIdentifier];
    } else if ([senderIdentifier isEqualToString:@"fftwThreads"]) {
        if (!value) [self.features setValue:@(0) forKeyPath:senderIdentifier];
        else [self.features setValue:@([value integerValue]) forKeyPath:senderIdentifier];
    } else if ([[sender identifier] isEqualToString:@"paths"]) {
        [self.driver setValue:value forKeyPath:senderIdentifier];
    }
}

#pragma mark - Syntax highlighter delegate

// pass a list of user defined identifier to the syntaxHighlighter for coloring
-(NSArray *)userIdentifiersForKeywordComponentName:(NSString *)inModeName
{
    return [[self.features.root listOfArgumentsIdentifiers] mutableCopy];
}

# pragma mark - Section title

- (NSString *)title
{
    return self.features.description;
}

- (NSString *)sectionSuffix
{
    return @"featureselement";
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
    
    NSArray *draggedObjects = [self.features.arguments objectsAtIndexes:rowIndexes];
    [self.features deleteArgumentsAtIndexes:rowIndexes];
    
    for (id draggedObject in draggedObjects) {
        [self.features addArgument:draggedObject atIndex:insertIndex];
        insertIndex++;
    }
    
    [self.mainTableView reloadData];
    
    return YES;
}

@end
