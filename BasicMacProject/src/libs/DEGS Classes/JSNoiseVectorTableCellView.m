//
//  JSNoiseVectorTableCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSNoiseVectorTableCellView.h"

@interface JSNoiseVectorTableCellView ()

@property (strong) IBOutlet NSTextField *nameLabel;
@property (strong) IBOutlet NSTextField *typeLabel;
@property (strong) IBOutlet NSTextField *componentsLabel;
@property (strong) IBOutlet NSTextField *dimensionsLabel;
@property (strong) IBOutlet NSTextField *initialBasisLabel;
@property (strong) IBOutlet NSTextField *methodLabel;
@property (strong) IBOutlet NSTextField *kindLabel;
@property (strong) IBOutlet NSTextField *seedLabel;
@property (strong) IBOutlet NSTextField *meanLabel;

@property JSNoiseVectorCellState currentState;
@property (nonatomic, strong) NSArray *constraintsForNonMeanState;
@property (nonatomic, strong) NSArray *constraintsForMeanState;

- (void)prepareForMeanState;
- (void)prepareForNonMeanState;

@end

@implementation JSNoiseVectorTableCellView

- (void)awakeFromNib {
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    NSDictionary *group = NSDictionaryOfVariableBindings(_nameTextField, _typeButton, _componentsTokenField, _dimensionsTokenField, _initialBasisTokenField, _kindButton, _methodButton, _seedTextField);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_nameTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_componentsTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_dimensionsTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_initialBasisTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_methodButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_kindButton]" options:0 metrics:nil views:group]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_seedTextField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|" options:0 metrics:nil views:group]];
    
    //    [self addConstraints:self.constraintsForNormalState];
    [self prepareForNonMeanState];
    
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_kindLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_methodLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_seedLabel
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
    
    // Horizontally position the components textfield
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
    
    // Horizontally position the dimensions textfield
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
    
    // Horizontally position the initial basis textfield
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

    // Horizontally position the seed textfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_seedTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_seedTextField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_seedTextField addConstraint:[NSLayoutConstraint constraintWithItem:_seedTextField
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_kindButton
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_methodButton
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_kindLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_kindButton  
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_methodLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_methodButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_seedLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_seedTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    // self consistent constraints
    [_meanTextField addConstraint:[NSLayoutConstraint constraintWithItem:_meanTextField
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:100.0f]];
    
    self.currentState = JSNoiseVectorCellWithoutMeanState;
}

- (void)prepareForNonMeanState
{
    [_meanLabel setHidden:YES];
    [_meanTextField setHidden:YES];
    
    if (_constraintsForMeanState) {
        [self removeConstraints:self.constraintsForMeanState];
        _constraintsForMeanState = nil;
    }
    [self addConstraints:self.constraintsForNonMeanState];
    
    [_meanLabel removeFromSuperview];
    [_meanTextField removeFromSuperview];
}

- (void)prepareForMeanState
{
    [self addSubview:_meanLabel];
    [self addSubview:_meanTextField];
    
    if (_constraintsForNonMeanState) {
        [self removeConstraints:self.constraintsForNonMeanState];
        _constraintsForNonMeanState = nil;
    }
    [self addConstraints:self.constraintsForMeanState];
    
    [_meanLabel setHidden:NO];
    [_meanTextField setHidden:NO];
}

- (void)setNoiseVectorCellState:(JSNoiseVectorCellState)newState
{
    if (newState != _currentState) {
        if (newState == JSNoiseVectorCellWithMeanState) {
            [self prepareForMeanState];
        } else if (newState == JSNoiseVectorCellWithoutMeanState) {
            [self prepareForNonMeanState];
        }
        self.currentState = newState;
        if ([self.delegate respondsToSelector:@selector(tableCellDidChangeUIState:)]) [self.delegate tableCellDidChangeUIState:self];
    }
}

- (NSArray *)constraintsForMeanState
{
    if (!_constraintsForMeanState) {
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_kindButton, _meanTextField, _seedTextField);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_kindButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_meanTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_seedTextField]" options:0 metrics:nil views:group]];
        
        // Horizontally position the mean text field
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_meanTextField
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        
        // Horizontally position the labels
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_meanLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        
        // Vertically position the labels and controls
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_meanLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_meanTextField
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        _constraintsForMeanState = [constraintsArray copy];
    }
    return _constraintsForMeanState;
}

- (NSArray *)constraintsForNonMeanState
{
    if (!_constraintsForNonMeanState) {
        
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_kindButton, _seedTextField);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_kindButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_seedTextField]"
                                               options:0 metrics:nil views:group]];
        
        _constraintsForNonMeanState = [constraintsArray copy];
    }
    return _constraintsForNonMeanState;
}

- (NSString *)cellHelpIdentifier
{
    return @"noisevectorelement";
}


@end
