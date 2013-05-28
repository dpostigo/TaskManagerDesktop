//
//  JSCompuedVectorTableCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSComputedVectorTableCellView.h"

@interface JSComputedVectorTableCellView ()

@property (strong) IBOutlet NSTextField *nameLabel;
@property (strong) IBOutlet NSTextField *typeLabel;
@property (strong) IBOutlet NSTextField *componentsLabel;
@property (strong) IBOutlet NSTextField *dimensionsLabel;
@property (strong) IBOutlet NSTextField *dependenciesLabel;
@property (strong) IBOutlet NSTextField *dependenciesBasisLabel;
@property (strong) IBOutlet NSTextField *evaluationLabel;

@end

@implementation JSComputedVectorTableCellView

- (void)awakeFromNib {
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *group = NSDictionaryOfVariableBindings(_nameTextField, _typeButton, _componentsTokenField, _dimensionsTokenField, _dependenciesTokenField, _dependenciesBasisTokenField, _evaluationTextField);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_nameTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_componentsTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_dimensionsTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_dependenciesTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_dependenciesBasisTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_evaluationTextField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|" options:0 metrics:nil views:group]];
    
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesBasisLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_evaluationLabel
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesTokenField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesTokenField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_dependenciesTokenField addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesTokenField
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:100.0f]];
    
    // Horizontally position the dependencies basis tokenfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesBasisTokenField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesBasisTokenField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_dependenciesBasisTokenField addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesBasisTokenField
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:100.0f]];
    
    // Horizontally position the evaluation textfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_evaluationTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_evaluationTextField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_evaluationTextField addConstraint:[NSLayoutConstraint constraintWithItem:_evaluationTextField
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_dependenciesTokenField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesBasisLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_dependenciesBasisTokenField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_evaluationLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_evaluationTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
}

- (NSString *)cellHelpIdentifier
{
    return @"computedvectorelement";
}

@end
