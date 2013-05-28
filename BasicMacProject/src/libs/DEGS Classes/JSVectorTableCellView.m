//
//  JSVectorTableCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSVectorTableCellView.h"

@interface JSVectorTableCellView ()

@property (strong) IBOutlet NSTextField *nameLabel;
@property (strong) IBOutlet NSTextField *filenameLabel;
@property (strong) IBOutlet NSTextField *typeLabel;
@property (strong) IBOutlet NSTextField *componentsLabel;
@property (strong) IBOutlet NSTextField *dimensionsLabel;
@property (strong) IBOutlet NSTextField *dependenciesLabel;
@property (strong) IBOutlet NSTextField *initialBasisLabel;
@property (strong) IBOutlet NSTextField *initialisationLabel;
@property (strong) IBOutlet NSTextField *initialisationStringLabel;
@property (strong) IBOutlet NSTextField *dependenciesBasisLabel;

@property JSVectorCellState currentState;
@property (nonatomic, strong) NSArray *constraintsForZeroState;
@property (nonatomic, strong) NSArray *constraintsForFilenameState;
@property (nonatomic, strong) NSArray *constraintsForCDATAState;

- (void)prepareForZeroState;
- (void)prepareForFilenameState;
- (void)prepareForCDATAState;

@end

@implementation JSVectorTableCellView

- (void)awakeFromNib {
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *group = NSDictionaryOfVariableBindings(_nameTextField, _typeButton, _componentsTokenField, _dimensionsTokenField, _initialBasisTokenField, _initialisationButton);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_nameTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_componentsTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_dimensionsTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_initialBasisTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_initialisationButton]" options:0 metrics:nil views:group]];
    
    [self prepareForZeroState];
        
    // Horizontally position the labels
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_componentsLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dimensionsLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_initialBasisLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_initialisationLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    
    // Horizontally position the name textfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_nameTextField addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:100.0f]];
    
    // Horizontally position the components tokenfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_componentsTokenField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_componentsTokenField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_componentsTokenField addConstraint:[NSLayoutConstraint constraintWithItem:_componentsTokenField
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:100.0f]];
    
    // Horizontally position the dimensions tokenfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dimensionsTokenField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dimensionsTokenField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_dimensionsTokenField addConstraint:[NSLayoutConstraint constraintWithItem:_dimensionsTokenField
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:100.0f]];
    
    // Horizontally position the dependencies tokenfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_initialBasisTokenField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_initialBasisTokenField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_initialBasisTokenField addConstraint:[NSLayoutConstraint constraintWithItem:_initialBasisTokenField
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:100.0f]];
    
    // Horinzontally position the buttons
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_typeButton
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_initialisationButton
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    
    // Vertically position the labels
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_nameTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_typeButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_componentsLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_componentsTokenField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dimensionsLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_dimensionsTokenField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_initialBasisLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_initialBasisTokenField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_initialisationLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_initialisationButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    // self consistent constraints
    [_filenameTextField addConstraint:[NSLayoutConstraint constraintWithItem:_filenameTextField
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:100.0f]];
    [_dependenciesTokenField addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesTokenField
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f
                                                                    constant:100.0f]];
    [_dependenciesBasisTokenField addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesBasisTokenField
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:100.0f]];
    [_initialisationTextField addConstraint:[NSLayoutConstraint constraintWithItem:_initialisationTextField
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:100.0f]];
    
    self.currentState = JSVectorCellInZeroState;
}

- (NSArray *)constraintsForZeroState
{
    if (!_constraintsForZeroState) {
        
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_initialisationButton);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_initialisationButton]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|" options:0 metrics:nil views:group]];
        
        _constraintsForZeroState = [constraintsArray copy];
    }
    return _constraintsForZeroState;
}

- (NSArray *)constraintsForFilenameState
{
    if (!_constraintsForFilenameState) {
        
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_initialisationButton, _filenameTextField);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_initialisationButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_filenameTextField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|" options:0 metrics:nil views:group]];
        
        // Horizontally position the labels
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_filenameLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        
        // Horizontally position the filename textfield
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_filenameTextField
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_filenameTextField
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:-SPACE_FROM_RIGHT_EDGE]];
        
        // Vertically position the labels
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_filenameLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_filenameTextField
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        _constraintsForFilenameState = [constraintsArray copy];
    }
    return _constraintsForFilenameState;
}

- (NSArray *)constraintsForCDATAState
{
    if (!_constraintsForCDATAState) {
        
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_initialisationButton, _dependenciesTokenField, _dependenciesBasisTokenField, _initialisationTextField);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_initialisationButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_dependenciesTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_dependenciesBasisTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_initialisationTextField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|" options:0 metrics:nil views:group]];
        
        // Horizontally position the labels
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dependenciesLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dependenciesBasisLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_initialisationStringLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        
        // Horizontally position the dependencies token field
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dependenciesTokenField
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dependenciesTokenField
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:-SPACE_FROM_RIGHT_EDGE]];
        
        // Horizontally position the dependencies basis token field
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dependenciesBasisTokenField
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dependenciesBasisTokenField
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:-SPACE_FROM_RIGHT_EDGE]];
        // Horizontally position the initialisation text field
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_initialisationTextField
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_initialisationTextField
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:-SPACE_FROM_RIGHT_EDGE]];
        
        
        // Vertically position the labels
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dependenciesLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_dependenciesTokenField
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dependenciesBasisLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_dependenciesBasisTokenField
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_initialisationStringLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_initialisationTextField
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        
        _constraintsForCDATAState = [constraintsArray copy];
    }
    return _constraintsForCDATAState;
}

- (void)prepareForZeroState
{
    [_filenameLabel setHidden:YES];
    [_filenameTextField setHidden:YES];
    [_dependenciesLabel setHidden:YES];
    [_dependenciesTokenField setHidden:YES];
    [_dependenciesBasisLabel setHidden:YES];
    [_dependenciesBasisTokenField setHidden:YES];
    [_initialisationStringLabel setHidden:YES];
    [_initialisationTextField setHidden:YES];
    
    if (_constraintsForCDATAState) {
        [self removeConstraints:self.constraintsForCDATAState];
        _constraintsForCDATAState = nil;
    }
    if (_constraintsForFilenameState) {
        [self removeConstraints:self.constraintsForFilenameState];
        _constraintsForFilenameState = nil;
    }
    [self addConstraints:self.constraintsForZeroState];
    
    [_filenameLabel removeFromSuperview];
    [_filenameTextField removeFromSuperview];
    [_dependenciesLabel removeFromSuperview];
    [_dependenciesTokenField removeFromSuperview];
    [_dependenciesBasisLabel removeFromSuperview];
    [_dependenciesBasisTokenField removeFromSuperview];
    [_initialisationStringLabel removeFromSuperview];
    [_initialisationTextField removeFromSuperview];
}

- (void)prepareForFilenameState
{
    [_dependenciesLabel setHidden:YES];
    [_dependenciesTokenField setHidden:YES];
    [_dependenciesBasisLabel setHidden:YES];
    [_dependenciesBasisTokenField setHidden:YES];
    [_initialisationStringLabel setHidden:YES];
    [_initialisationTextField setHidden:YES];
    
    [self addSubview:_filenameLabel];
    [self addSubview:_filenameTextField];
    
    if (_constraintsForCDATAState) {
        [self removeConstraints:self.constraintsForCDATAState];
        _constraintsForCDATAState = nil;
    }
    if (_constraintsForZeroState) {
        [self removeConstraints:self.constraintsForZeroState];
        _constraintsForZeroState = nil;
    }
    [self addConstraints:self.constraintsForFilenameState];
    
    [_filenameLabel setHidden:NO];
    [_filenameTextField setHidden:NO];
    
    [_dependenciesLabel removeFromSuperview];
    [_dependenciesTokenField removeFromSuperview];
    [_dependenciesBasisLabel removeFromSuperview];
    [_dependenciesBasisTokenField removeFromSuperview];
    [_initialisationStringLabel removeFromSuperview];
    [_initialisationTextField removeFromSuperview];
}

- (void)prepareForCDATAState
{
    [_filenameLabel setHidden:YES];
    [_filenameTextField setHidden:YES];
    
    [self addSubview:_dependenciesLabel];
    [self addSubview:_dependenciesTokenField];
    [self addSubview:_dependenciesBasisLabel];
    [self addSubview:_dependenciesBasisTokenField];
    [self addSubview:_initialisationStringLabel];
    [self addSubview:_initialisationTextField];
    
    if (_constraintsForZeroState) {
        [self removeConstraints:self.constraintsForZeroState];
        _constraintsForZeroState = nil;
    }
    if (_constraintsForFilenameState) {
        [self removeConstraints:self.constraintsForFilenameState];
        _constraintsForFilenameState = nil;
    }
    [self addConstraints:self.constraintsForCDATAState];
    
    [_dependenciesLabel setHidden:NO];
    [_dependenciesTokenField setHidden:NO];
    [_dependenciesBasisLabel setHidden:NO];
    [_dependenciesBasisTokenField setHidden:NO];
    [_initialisationStringLabel setHidden:NO];
    [_initialisationTextField setHidden:NO];
    
    [_filenameLabel removeFromSuperview];
    [_filenameTextField removeFromSuperview];
}

- (void)setVectorCellState:(JSVectorCellState)newState
{
    if (newState != _currentState) {
        if (newState == JSVectorCellInZeroState) {
            [self prepareForZeroState];
        } else if (newState == JSVectorCellInFilenameState) {
            [self prepareForFilenameState];
        } else {
            [self prepareForCDATAState];
        }
        self.currentState = newState;
        if ([self.delegate respondsToSelector:@selector(tableCellDidChangeUIState:)]) [self.delegate tableCellDidChangeUIState:self];
    }
}

- (NSString *)cellHelpIdentifier
{
    return @"vectorelement";
}

@end
