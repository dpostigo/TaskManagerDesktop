//
//  JSSideBar.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 2/11/12.
//
//

#import "JSSideBar.h"
#import "JSFlexibleButtonCell.h"
#import "JSFlexibleButton.h"
#import "JSButtonStyle.h"

#define BUTTON_HEIGHT 70.0
#define BUTTON_SPACING 8.0
#define STEP_BUTTON_HEIGHT 50.0

@interface JSSideBar() {
    NSMatrix *_matrix;
}

@property NSUInteger previouslySelectedSection;

// previous and next buttons are used to move through the sideBar bar sequentially
@property (nonatomic, strong) JSFlexibleButton *previousButton;
@property (nonatomic, strong) JSFlexibleButton *nextButton;

// convenience property to hold onto the constraints for the layout of the view
@property (nonatomic, strong) NSArray *previousAndNextButtonsConstraints;
@property (nonatomic, strong) NSLayoutConstraint *matrixHeightConstraint;

@end

@implementation JSSideBar

@synthesize delegate;

# pragma mark - default style for buttons

// Convenience method to create the default style for the button in the case one wasn't provided
- (JSButtonStyle *)defaultStyle
{
    JSButtonDecoration *normalDecoration = [[JSButtonDecoration alloc] initWithColor:[NSColor colorWithCalibratedWhite:0.85 alpha:1.0]];
    JSButtonDecoration *highlightDecoration = [[JSButtonDecoration alloc] initWithColor:[NSColor colorWithCalibratedWhite:0.5 alpha:1.0]];
    JSButtonDecoration *mouseOverDecoration = [[JSButtonDecoration alloc] initWithColor:[NSColor whiteColor]];
    JSButtonDecoration *selectionDecoration = [[JSButtonDecoration alloc] initWithColor:[NSColor colorWithCalibratedRed:0.608 green:0.784 blue:0.910 alpha:1.0]];
    NSDictionary *decorations = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:normalDecoration, highlightDecoration, mouseOverDecoration, selectionDecoration, nil] forKeys:[NSArray arrayWithObjects:@"normal", @"highlight", @"mouseOver", @"selection", nil]];
    JSButtonStyle *style = [[JSButtonStyle alloc] initWithDecorations:decorations];
    style.textColor = [NSColor whiteColor];
    return style;
}

# pragma mark - Previous and next buttons methods

// we override the default setter for hasStepButtons so that we can create or remove the buttons
- (void)setHasStepButtons:(BOOL)hasStepButtons
{
    if (hasStepButtons!=_hasStepButtons) {
        _hasStepButtons = hasStepButtons;
        if (_hasStepButtons) {
            [self addSubview:self.previousButton];
            [self addSubview:self.nextButton];
            [self addConstraints:self.previousAndNextButtonsConstraints];
        } else {
            [self removeConstraints:self.previousAndNextButtonsConstraints];
            [self.previousButton removeFromSuperview];
            [self.nextButton removeFromSuperview];
            _previousButton = nil;
            _nextButton = nil;
            _previousAndNextButtonsConstraints = nil;
        }
    }
}

// convenience method to set the look and behviour of the next and previous buttons
- (void)initializeButton:(JSFlexibleButton *)button
{
    if (_buttonsStyle) button.style = self.buttonsStyle;
    else button.style = [self defaultStyle];
    button.style.selectionDecoration = button.style.normalDecoration;
    [button setBordered:NO];
    [button setTarget:self];
    [button setImagePosition:NSImageOnly];
}

- (JSFlexibleButton *)previousButton
{
    if (!_previousButton) {
        _previousButton = [[JSFlexibleButton alloc] initWithFrame:NSMakeRect(0.0, [self frame].size.height - STEP_BUTTON_HEIGHT, [self frame].size.width, STEP_BUTTON_HEIGHT)];
        NSImage *buttonImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Previous" ofType: @"pdf"]];
        _previousButton.image = buttonImage;
        [self initializeButton:_previousButton];
        [_previousButton setAction:@selector(previousButtonClicked:)];
        [_previousButton setButtonType:NSMomentaryLightButton];
        [_previousButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_previousButton addConstraint:[NSLayoutConstraint constraintWithItem:_previousButton
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f
                                                             constant:STEP_BUTTON_HEIGHT]];
    }
    return _previousButton;
}

- (JSFlexibleButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[JSFlexibleButton alloc] initWithFrame:NSMakeRect(0.0, 0.0, [self frame].size.width, STEP_BUTTON_HEIGHT)];
        NSImage *buttonImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Next" ofType: @"pdf"]];
        _nextButton.image = buttonImage;
        [self initializeButton:_nextButton];
        [_nextButton setAction:@selector(nextButtonClicked:)];
        [_nextButton setButtonType:NSMomentaryLightButton];
        [_nextButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_nextButton addConstraint:[NSLayoutConstraint constraintWithItem:_nextButton
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:STEP_BUTTON_HEIGHT]];
    }
    return _nextButton;
}

- (NSArray *)previousAndNextButtonsConstraints
{
    if (!_previousAndNextButtonsConstraints) {
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0f
                                                             constant:0.0f]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.nextButton
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f
                                                             constant:0.0f]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.previousButton
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f
                                                             constant:0.0f]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.previousButton
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0f
                                                             constant:0.0f]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.previousButton
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:0.0f]];
        _previousAndNextButtonsConstraints = [constraints copy];
    }
    return _previousAndNextButtonsConstraints;
}

# pragma mark - Initialiser and dealloc

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code here.
        _matrix = [[NSMatrix alloc] initWithFrame:NSZeroRect];
        [_matrix setMode:NSRadioModeMatrix];
        
        // Defaults
        [_matrix setCellClass:[JSFlexibleButtonCell class]];
        [self addSubview:_matrix];
        [_matrix setIntercellSpacing:NSMakeSize(0.0, BUTTON_SPACING)];
        [_matrix setCellSize:NSMakeSize([self frame].size.width, BUTTON_HEIGHT)];
        [_matrix setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_matrix
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f
                                                                             constant:0.0f];
        self.matrixHeightConstraint = heightConstraint;
        [_matrix addConstraint:self.matrixHeightConstraint];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_matrix
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_matrix
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_matrix
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:0.0f]];
        // by default the sideBar has the step buttons
        self.hasStepButtons = YES;
    }
    return self;
}

# pragma mark - Add or remove buttons

// convenience method that add a cell to the matrix, set its basic common properties and return it
-(JSFlexibleButtonCell *)addButton
{
	[_matrix addRow];
	JSFlexibleButtonCell *cell = [_matrix cellAtRow:[_matrix numberOfRows]-1 column:0];
	[cell setBordered:NO];
	[cell setTarget:self];
    [cell setButtonType:NSMomentaryChangeButton];
	[cell setAction:@selector(buttonClicked:)];
	[cell setFocusRingType:NSFocusRingTypeNone];
	
    if (_buttonsStyle) cell.style = self.buttonsStyle;
    else cell.style = [self defaultStyle];
    
    [self updateMatrixHeightConstraint];
    
    [self updateTrackingAreas];
    
	return cell;
}

// set all the buttons at once
- (void)setButtons:(NSArray *)buttons
{
    [_matrix removeColumn:0];
    
    for (NSDictionary *button in buttons) {
        JSFlexibleButtonCell *cell = [self addButton];
        cell.title = button[@"title"];
        cell.image = button[@"image"];
    }
}

- (NSArray *)buttons
{
    // loop through the cells of the matrix, extract their image and title, add it to the returning array
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSInteger i=0; i<[_matrix numberOfRows]; i++) {
        JSFlexibleButtonCell *cell = [_matrix cellAtRow:i column:0];
        NSDictionary *buttonID = [NSDictionary dictionaryWithObjects:@[cell.image, cell.title] forKeys:@[@"image", @"title"]];
        [buttons addObject:buttonID];
    }
    return [buttons copy];
}

-(void)addButtonWithTitle:(NSString*)title image:(NSImage*)image
{
    JSFlexibleButtonCell *cell = [self addButton];
    cell.title = title;
    cell.image = image;
}

-(void)removeButtonWithTitle:(NSString*)title
{
    for (NSInteger i=0; i<[_matrix numberOfRows]; i++) {
        JSFlexibleButtonCell *cell = [_matrix cellAtRow:i column:0];
        if ([cell.title isEqualToString:title]) {
            [_matrix removeRow:i];
            [self updateMatrixHeightConstraint];
            NSTrackingArea *areaToBeRemoved = [self trackingAreas][i];
            [self removeTrackingArea:areaToBeRemoved];
        }
    }
}

-(void)removeButtonAtIndex:(NSInteger)index
{
    if (index < [_matrix numberOfRows]) {
        [_matrix removeRow:index];
        [self updateMatrixHeightConstraint];
        NSTrackingArea *areaToBeRemoved = [self trackingAreas][index];
        [self removeTrackingArea:areaToBeRemoved];
    }
}

# pragma mark - Selection methods

-(void)selectButtonWithIndex:(NSUInteger)index
{
    if (index<=[_matrix numberOfRows]-1) {
        [_matrix setState:(NSInteger)NSOnState atRow:(NSInteger)index column:(NSInteger)0];
        [self hasUpdatedSelection];
    }
}

-(void)selectButtonWithTitle:(NSString *)title
{
    for (int i=0; i<[_matrix numberOfRows]; i++) {
        if ([[[_matrix cellAtRow:i column:0] title] isEqualToString:title]) {
            [_matrix setState:(NSInteger)NSOnState atRow:(NSInteger)i column:(NSInteger)0];
            [self hasUpdatedSelection];
            return;
        }
    }
}

- (NSUInteger)selectionIndex
{
    return [_matrix selectedRow];
}

- (NSString *)selectionTitle
{
    return [[_matrix selectedCell] title];
}

# pragma mark - View resize methods

// on updating the tracking areas we first remove all of them and then create a new one for each cell and put it back in the view
// this probably inefficient but we are never going to have many buttons so the performance penalty is minimal
- (void)updateTrackingAreas
{
    while ([[self trackingAreas] count]) {
        NSTrackingArea *trackingArea = [self trackingAreas][0];
        [self removeTrackingArea:trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp);
    for (NSInteger i=0; i<[_matrix numberOfRows]; i++) {
        NSDictionary *cellIndex = @{@"index": [NSNumber numberWithInteger:i]};
        CGFloat cellY = _matrix.frame.origin.y + (BUTTON_HEIGHT + BUTTON_SPACING) * ([_matrix numberOfRows] - i - 1);
        NSRect cellRect = NSMakeRect(0.0, cellY, [self frame].size.width, BUTTON_HEIGHT);
        
        // we add the cellIndex to the userInfo of the tracking area in other to be able to track where the mouse enetered and exited events originated from
        NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:cellRect options:opts owner:self userInfo:cellIndex];
        [self addTrackingArea:trackingArea];
    }
}

- (void)updateMatrixHeightConstraint
{
    self.matrixHeightConstraint.constant = [_matrix numberOfRows] * BUTTON_HEIGHT + ( [_matrix numberOfRows] - 1 ) * BUTTON_SPACING;
}

# pragma mark - Mouse tracking methods

- (void)mouseEntered:(NSEvent *)theEvent
{
    NSInteger cellIndex = [(NSNumber *)((NSDictionary *)[theEvent userData])[@"index"] integerValue];
    JSFlexibleButtonCell *cell = [_matrix cellAtRow:cellIndex column:0];
    [cell setIsMouseOver:YES];
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    NSInteger cellIndex = [(NSNumber *)((NSDictionary *)[theEvent userData])[@"index"] integerValue];
    JSFlexibleButtonCell *cell = [_matrix cellAtRow:cellIndex column:0];
    [cell setIsMouseOver:NO];
    [self setNeedsDisplay:YES];
}

# pragma mark - Button click methods

-(void)buttonClicked:(id)sender
{
    NSInteger row = [_matrix selectedRow];
    if (row!=self.previouslySelectedSection) {
        [self hasUpdatedSelection];
        // we inform the delegate of the changed selection
        [self sendSelectedRowToDelegate];
    }
}

- (void)previousButtonClicked:(id)sender
{
    if (_matrix.selectedRow!=0) {
        [_matrix selectCellAtRow:_matrix.selectedRow-1 column:0];
        [self hasUpdatedSelection];
        // we inform the delegate of the changed selection
        [self sendSelectedRowToDelegate];
    }
}

- (void)nextButtonClicked:(id)sender
{
    if (_matrix.selectedRow<[_matrix numberOfRows]-1) {
        [_matrix selectCellAtRow:_matrix.selectedRow+1 column:0];
        [self hasUpdatedSelection];
        // we inform the delegate of the changed selection
        [self sendSelectedRowToDelegate];
    }
}

# pragma mark - Update after new selection

- (void)hasUpdatedSelection
{
    NSInteger row = [_matrix selectedRow];
    
    // we then update our internal reresentation
    self.previouslySelectedSection = row;
    
    // finally we update the state of the previous and next button in case we are on the first or last of the buttons
    if (self.hasStepButtons) {
        if (row == 0) [self.previousButton setEnabled:FALSE]; else [self.previousButton setEnabled:TRUE];
        if (row == [_matrix numberOfRows]-1) [self.nextButton setEnabled:FALSE]; else [self.nextButton setEnabled:TRUE];
    }
}

- (void)sendSelectedRowToDelegate
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sidebar:didChangeSelectionTo:)] ) {
        NSInteger row = [_matrix selectedRow];
        JSFlexibleButtonCell *cell = [_matrix cellAtRow:row column:0];
        NSDictionary *buttonID = [NSDictionary dictionaryWithObjects:@[@(row), cell.title] forKeys:@[@"index", @"title"]];
		[self.delegate sidebar:self didChangeSelectionTo:buttonID];
	}
}

# pragma mark - Buttons style setter

// Every time the buttons style property is set we need to pass it to all the buttons in the view
- (void)setButtonsStyle:(JSButtonStyle *)buttonsStyle
{
    _buttonsStyle = buttonsStyle;
    if (self.hasStepButtons) {
        self.previousButton.style = buttonsStyle;
        self.nextButton.style = buttonsStyle;
    }
    for (JSFlexibleButtonCell *cell in [_matrix cells]) {
        cell.style = buttonsStyle;
    }
}

@end
