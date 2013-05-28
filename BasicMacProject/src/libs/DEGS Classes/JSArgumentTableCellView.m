//
//  JSArgumentTableCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 14/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSArgumentTableCellView.h"

@interface JSArgumentTableCellView ()

@property (strong) IBOutlet NSTextField *nameLabel;
@property (strong) IBOutlet NSTextField *defaultValueLabel;
@property (strong) IBOutlet NSTextField *typeLabel;

@end

@implementation JSArgumentTableCellView

- (void)awakeFromNib {
    //    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *group = NSDictionaryOfVariableBindings(_nameLabel, _nameTextField, _typeLabel, _typeButton, _defaultValueLabel, _defaultValueTextField);
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_nameTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_defaultValueTextField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|"
                          options:0 metrics:nil views:group]];
    
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_defaultValueLabel   
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    
    // Horizontally position the defaultValue textfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_defaultValueTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_defaultValueTextField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_defaultValueTextField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:100.0f]];
    
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:100.0f]];
    
    // Horinzontally position the button
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_defaultValueLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_defaultValueTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
}

- (NSString *)cellHelpIdentifier
{
    return @"argumentelement";
}

@end
