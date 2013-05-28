//
//  JSBreakpointTableCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 10/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSBreakpointTableCellView.h"

@interface JSBreakpointTableCellView ()

@property (strong) IBOutlet NSTextField *nameLabel;
@property (strong) IBOutlet NSTextField *filenameLabel;
@property (strong) IBOutlet NSTextField *formatLabel;
@property (strong) IBOutlet NSTextField *dependenciesLabel;
@property (strong) IBOutlet NSTextField *dependenciesBasisLabel;

@end

@implementation JSBreakpointTableCellView

- (void)awakeFromNib {
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *group = NSDictionaryOfVariableBindings(_nameTextField, _filenameTextField, _formatButton, _dependenciesTokenField, _dependenciesBasisTokenField);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_nameTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_filenameTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_formatButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_dependenciesTokenField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_dependenciesBasisTokenField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|" options:0 metrics:nil views:group]];
    
    // Horizontally position the labels
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_filenameLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_formatLabel
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dependenciesLabel
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
    
    // Horizontally position the filename textfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_filenameTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_filenameTextField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [_filenameTextField addConstraint:[NSLayoutConstraint constraintWithItem:_filenameTextField
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f
                                                                         constant:100.0f]];
    
    // Horinzontally position the buttons
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_formatButton
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_formatLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_formatButton
                                                     attribute:NSLayoutAttributeCenterY
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_filenameLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_filenameTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
}

- (NSString *)cellHelpIdentifier
{
    return @"breakpointelement";
}

@end
