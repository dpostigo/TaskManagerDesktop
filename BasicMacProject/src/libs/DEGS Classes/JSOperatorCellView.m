//
//  JSOperatorCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 23/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSOperatorCellView.h"

@interface JSOperatorCellView ()

@property (strong) IBOutlet NSTextField *nameLabel;
@property (strong) IBOutlet NSTextField *kindLabel;
@property (strong) IBOutlet NSTextField *typeLabel;
@property (strong) IBOutlet NSTextField *constantLabel;
@property (strong) IBOutlet NSTextField *namesLabel;
@property (strong) IBOutlet NSTextField *definitionLabel;

@property JSOperatorCellState currentState;
@property (nonatomic, strong) NSArray *constraintsForFunctionState;
@property (nonatomic, strong) NSArray *constraintsForDifferentialState;

- (void)prepareFunctionState;
- (void)prepareDifferentialState;

@end

@implementation JSOperatorCellView

- (void)awakeFromNib {
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *group = NSDictionaryOfVariableBindings(_nameTextField, _kindButton, _definitionTextField);

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_nameTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_kindButton]" options:0 metrics:nil views:group]];
                          
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_definitionTextField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|" options:0 metrics:nil views:group]];

    [self prepareDifferentialState];
    
    // Horizontally position the labels
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_kindLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_definitionLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];

    
    // self consistent constraint
    [_namesTokenField addConstraint:[NSLayoutConstraint constraintWithItem:_namesTokenField
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:100.0f]];

    // Horizontally position the name text field
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

    // Horizontally position the definition text field
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_definitionTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_definitionTextField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_definitionTextField addConstraint:[NSLayoutConstraint constraintWithItem:_definitionTextField
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:100.0f]];
    
    // Horinzontally position the buttons
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_kindButton
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_kindLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_kindButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_definitionLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_definitionTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    self.currentState = JSOperatorCellDifferentialState;
}

- (void)prepareFunctionState
{
    [_typeLabel setHidden:YES];
    [_typeButton setHidden:YES];
    [_constantLabel setHidden:YES];
    [_constantCheckBox setHidden:YES];
    [_namesLabel setHidden:YES];
    [_namesTokenField setHidden:YES];
    
    if (_constraintsForDifferentialState) {
        [self removeConstraints:self.constraintsForDifferentialState];
        _constraintsForDifferentialState = nil;
    }
    [self addConstraints:self.constraintsForFunctionState];
    
    [_typeLabel removeFromSuperview];
    [_typeButton removeFromSuperview];
    [_constantLabel removeFromSuperview];
    [_constantCheckBox removeFromSuperview];
    [_namesLabel removeFromSuperview];
    [_namesTokenField removeFromSuperview];
}

- (void)prepareDifferentialState
{
    [self addSubview:_typeLabel];
    [self addSubview:_typeButton];
    [self addSubview:_constantLabel];
    [self addSubview:_constantCheckBox];
    [self addSubview:_namesLabel];
    [self addSubview:_namesTokenField];
    
    if (_constraintsForFunctionState) {
        [self removeConstraints:self.constraintsForFunctionState];
        _constraintsForFunctionState = nil;
    }
    [self addConstraints:self.constraintsForDifferentialState];
    
    [_typeLabel setHidden:NO];
    [_typeButton setHidden:NO];
    [_constantLabel setHidden:NO];
    [_constantCheckBox setHidden:NO];
    [_namesLabel setHidden:NO];
    [_namesTokenField setHidden:NO];
}

- (void)setOperatorCellState:(JSOperatorCellState)newState
{
    if (newState != _currentState) {
        if (newState == JSOperatorCellFunctionState) {
            [self prepareFunctionState];
        } else if (newState == JSOperatorCellDifferentialState) {
            [self prepareDifferentialState];
        }
        self.currentState = newState;
        if ([self.delegate respondsToSelector:@selector(tableCellDidChangeUIState:)]) [self.delegate tableCellDidChangeUIState:self];
    }
}

- (NSArray *)constraintsForDifferentialState
{
    if (!_constraintsForDifferentialState) {
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_kindButton, _typeButton, _constantCheckBox, _namesTokenField, _definitionTextField);

        // Vertical constraints
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_kindButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_constantCheckBox]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_namesTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_definitionTextField]" options:0 metrics:nil views:group]];
        
        // Horizontally position the names token field
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_namesTokenField
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_namesTokenField
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:-SPACE_FROM_RIGHT_EDGE]];
        
        // Horinzontally position the buttons
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_typeButton
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        
        // Horizontally position the checkbox
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_constantCheckBox
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];

        // Horizontally position the labels
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_constantLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_namesLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];

        // Vertically position the labels and controls
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_typeButton
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_constantLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_constantCheckBox
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_namesLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_namesTokenField
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        
        _constraintsForDifferentialState = [constraintsArray copy];
    }
    return _constraintsForDifferentialState;
}

- (NSArray *)constraintsForFunctionState
{
    if (!_constraintsForFunctionState) {
        
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_kindButton, _definitionTextField);
        
        // Vertical constraints
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_kindButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_definitionTextField]" options:0 metrics:nil views:group]];
        
        _constraintsForFunctionState = [constraintsArray copy];
    }
    return _constraintsForFunctionState;
}

- (NSString *)cellHelpIdentifier
{
    return @"operatorelement";
}

@end
