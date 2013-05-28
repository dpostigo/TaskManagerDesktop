//
//  JSIntroductionTableCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 26/07/12.
//
//

#import "JSIntroductionTableCellView.h"

@interface JSIntroductionTableCellView ()

@property (strong) IBOutlet NSTextField *filenameLabel;
@property (strong) IBOutlet NSTextField *formatLabel;

@end

@implementation JSIntroductionTableCellView

- (void)awakeFromNib {
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *group = NSDictionaryOfVariableBindings(_filenameTextField, _formatButton);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_formatButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_filenameTextField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|" options:0 metrics:nil views:group]];
    
    // Horizontally position the labels
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_formatLabel
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_filenameLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_filenameTextField
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
}

- (NSString *)cellHelpIdentifier
{
    return @"outputelement";
}

@end
