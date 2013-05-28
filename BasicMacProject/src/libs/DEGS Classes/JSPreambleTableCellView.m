//
//  JSPreambleTableCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 23/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSPreambleTableCellView.h"

@interface JSPreambleTableCellView ()

@property (nonatomic, strong) IBOutlet NSTextField *nameLabel;
@property (nonatomic, strong) IBOutlet NSTextField *authorLabel;
@property (nonatomic, strong) IBOutlet NSTextField *descriptionLabel;

@end

@implementation JSPreambleTableCellView

- (void)awakeFromNib {
//    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *group = NSDictionaryOfVariableBindings(_nameTextField, _nameLabel, _authorTextField, _authorLabel, _descriptionTextField, _descriptionLabel);
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_nameTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_authorTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_descriptionTextField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|"
                          options:0 metrics:nil views:group]];
    
    // Textfields horizontal alignment
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionTextField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionTextField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:100.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_descriptionTextField
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_descriptionTextField
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_authorTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_descriptionTextField
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_authorTextField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_descriptionTextField
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    // Labels vertical alignment
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_nameTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_authorTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_descriptionTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    // Labels horizontal alignment
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
}

- (NSString *)cellHelpIdentifier
{
    return @"nameelement";
}

@end
