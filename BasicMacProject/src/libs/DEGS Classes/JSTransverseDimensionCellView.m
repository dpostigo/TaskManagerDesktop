//
//  JSTransverseDimensionCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 22/06/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTransverseDimensionCellView.h"

@interface JSTransverseDimensionCellView ()

@property (strong) IBOutlet NSTextField *transformLabel;
@property (strong) IBOutlet NSTextField *typeLabel;
@property (strong) IBOutlet NSTextField *domainLabel;
@property (strong) IBOutlet NSTextField *latticeLabel;
@property (strong) IBOutlet NSTextField *aliasesLabel;
@property (strong) IBOutlet NSTextField *openPar;
@property (strong) IBOutlet NSTextField *closePar;
@property (strong) IBOutlet NSTextField *comma;
@property (strong) IBOutlet NSTextField *nameLabel;
@property (strong) IBOutlet NSTextField *volumePrefactorLabel;
@property (strong) IBOutlet NSTextField *spectralLatticeLabel;
@property (strong) IBOutlet NSTextField *lengthScaleLabel;
@property (strong) IBOutlet NSTextField *orderLabel;

@property JSTransverseDimensionCellState currentState;
@property (nonatomic, strong) NSArray *constraintsForNormalState;
@property (nonatomic, strong) NSArray *constraintsForHermiteGaussState;
@property (nonatomic, strong) NSArray *constraintsForBesselState;

- (void)prepareForNormalState;
- (void)prepareForHermiteGaussState;
- (void)prepareForBesselState;

@end

@implementation JSTransverseDimensionCellView

- (void)nameLabelConstraints
{
    NSRect frame = [_nameLabel frame];
    
    CGFloat width = frame.size.width;
    
    // Make the frame very high, while keeping the width
    frame.size.height = CGFLOAT_MAX;
    
    // Calculate new height within the frame
    // with practically infinite height.
    CGFloat height = [_nameLabel.cell cellSizeForBounds:frame].height;
    
    [_nameLabel addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0f
                                                            constant:width]];
    
    [_nameLabel addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0f
                                                            constant:height]];
}

- (void)awakeFromNib {
    //    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
//    [_nameLabel setPreferredMaxLayoutWidth:0.5*END_OF_LEFT_RECT];
    [self nameLabelConstraints];
    
    NSDictionary *group = NSDictionaryOfVariableBindings(_nameLabel, _nameTextField, _transformLabel, _transformButton, _typeLabel, _typeButton, _domainLabel, _openPar, _domainStartTextField, _comma, _domainEndTextField, _closePar, _latticeLabel, _latticeTextField, _aliasesLabel, _aliasesTokenField, _volumePrefactorLabel, _volumePrefactorTextField);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_nameLabel]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_transformButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_typeButton]" options:0 metrics:nil views:group]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_latticeTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_volumePrefactorTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_aliasesTokenField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|" options:0 metrics:nil views:group]];
    
//    [self addConstraints:self.constraintsForNormalState];
    [self prepareForNormalState];
    
    // Horizontally position the labels
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel   
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_transformLabel
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_latticeLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_volumePrefactorLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_aliasesLabel
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:100.0f]];
    
    // Horizontally position the aliases tokenfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_aliasesTokenField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_aliasesTokenField
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0f
                                                      constant:-SPACE_FROM_RIGHT_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_aliasesTokenField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:100.0f]];
    
    // Horizontally position the lattice textfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_latticeTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_latticeTextField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:100.0f]];
    
    // Horizontally position the volume prefactor textfield
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_volumePrefactorTextField
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_volumePrefactorTextField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:100.0f]];
    
    // Horinzontally position the buttons
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_transformButton
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_transformLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_transformButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_typeButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_latticeLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_latticeTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_volumePrefactorLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_volumePrefactorTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_aliasesLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_aliasesTokenField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    // self consistent constraints
    [_domainStartTextField addConstraint:[NSLayoutConstraint constraintWithItem:_domainStartTextField
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:DOMAIN_TEXTFIELD_WIDTH]];
    [_domainEndTextField addConstraint:[NSLayoutConstraint constraintWithItem:_domainEndTextField
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:DOMAIN_TEXTFIELD_WIDTH]];
    [_lengthScaleTextField addConstraint:[NSLayoutConstraint constraintWithItem:_lengthScaleTextField
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f
                                                                       constant:100.0f]];
    [_spectralLatticeTextField addConstraint:[NSLayoutConstraint constraintWithItem:_spectralLatticeTextField
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f
                                                                           constant:100.0f]];
    [_orderTextField addConstraint:[NSLayoutConstraint constraintWithItem:_orderTextField
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f
                                                                           constant:100.0f]];


    
    self.currentState = JSTransverseDimensionCellNormalState;
}

- (void)prepareForNormalState
{
    [_lengthScaleLabel setHidden:YES];
    [_lengthScaleTextField setHidden:YES];
    [_spectralLatticeLabel setHidden:YES];
    [_spectralLatticeTextField setHidden:YES];
    [_orderLabel setHidden:YES];
    [_orderTextField setHidden:YES];
    
    [self addSubview:_domainLabel];
    [self addSubview:_openPar];
    [self addSubview:_domainStartTextField];
    [self addSubview:_comma];
    [self addSubview:_domainEndTextField];
    [self addSubview:_closePar];
    
    if (_constraintsForHermiteGaussState) {
        [self removeConstraints:self.constraintsForHermiteGaussState];
        _constraintsForHermiteGaussState = nil;
    }
    if (_constraintsForBesselState) {
        [self removeConstraints:self.constraintsForBesselState];
        _constraintsForBesselState = nil;
    }
    [self addConstraints:self.constraintsForNormalState];
    
    [_domainLabel setHidden:NO];
    [_openPar setHidden:NO];
    [_domainStartTextField setHidden:NO];
    [_comma setHidden:NO];
    [_domainEndTextField setHidden:NO];
    [_closePar setHidden:NO];
    
    [_lengthScaleLabel removeFromSuperview];
    [_lengthScaleTextField removeFromSuperview];
    [_spectralLatticeLabel removeFromSuperview];
    [_spectralLatticeTextField removeFromSuperview];
    [_orderLabel removeFromSuperview];
    [_orderTextField removeFromSuperview];
}

- (void)prepareForHermiteGaussState
{
    [_domainLabel setHidden:YES];
    [_openPar setHidden:YES];
    [_domainStartTextField setHidden:YES];
    [_comma setHidden:YES];
    [_domainEndTextField setHidden:YES];
    [_closePar setHidden:YES];
    [_orderLabel setHidden:YES];
    [_orderTextField setHidden:YES];
    
    [self addSubview:_lengthScaleLabel];
    [self addSubview:_lengthScaleTextField];
    [self addSubview:_spectralLatticeLabel];
    [self addSubview:_spectralLatticeTextField];
    
    if (_constraintsForNormalState) {
        [self removeConstraints:self.constraintsForNormalState];
        _constraintsForNormalState = nil;        
    }
    if (_constraintsForBesselState) {
        [self removeConstraints:self.constraintsForBesselState];
         _constraintsForBesselState = nil;
    }
    [self addConstraints:self.constraintsForHermiteGaussState];
    
    [_lengthScaleLabel setHidden:NO];
    [_lengthScaleTextField setHidden:NO];
    [_spectralLatticeLabel setHidden:NO];
    [_spectralLatticeTextField setHidden:NO];
    
    [_domainLabel removeFromSuperview];
    [_openPar removeFromSuperview];
    [_domainStartTextField removeFromSuperview];
    [_comma removeFromSuperview];
    [_domainEndTextField removeFromSuperview];
    [_closePar removeFromSuperview];
    [_orderLabel removeFromSuperview];
    [_orderTextField removeFromSuperview];
}

- (void)prepareForBesselState
{
    [_lengthScaleLabel setHidden:YES];
    [_lengthScaleTextField setHidden:YES];
    [_spectralLatticeLabel setHidden:YES];
    [_spectralLatticeTextField setHidden:YES];
    
    [self addSubview:_domainLabel];
    [self addSubview:_openPar];
    [self addSubview:_domainStartTextField];
    [self addSubview:_comma];
    [self addSubview:_domainEndTextField];
    [self addSubview:_closePar];
    [self addSubview:_orderLabel];
    [self addSubview:_orderTextField];
    
    if (_constraintsForHermiteGaussState) {
        [self removeConstraints:self.constraintsForHermiteGaussState];
        _constraintsForHermiteGaussState = nil;
    }
    if (_constraintsForNormalState) {
        [self removeConstraints:self.constraintsForNormalState];
        _constraintsForNormalState = nil;
    }
    [self addConstraints:self.constraintsForBesselState];
    
    [_domainLabel setHidden:NO];
    [_openPar setHidden:NO];
    [_domainStartTextField setHidden:NO];
    [_comma setHidden:NO];
    [_domainEndTextField setHidden:NO];
    [_closePar setHidden:NO];
    [_orderLabel setHidden:NO];
    [_orderTextField setHidden:NO];
    
    [_lengthScaleLabel removeFromSuperview];
    [_lengthScaleTextField removeFromSuperview];
    [_spectralLatticeLabel removeFromSuperview];
    [_spectralLatticeTextField removeFromSuperview];
}

- (void)setTransverseDimensionCellState:(JSTransverseDimensionCellState)newState
{
    if (newState != _currentState) {
        if (newState == JSTransverseDimensionCellNormalState) {
            [self prepareForNormalState];
        } else if (newState == JSTransverseDimensionCellHermiteGaussState) {
            [self prepareForHermiteGaussState];
        } else if (newState == JSTransverseDimensionCellBesselState) {
            [self prepareForBesselState];
        }
        self.currentState = newState;
        if ([self.delegate respondsToSelector:@selector(tableCellDidChangeUIState:)]) [self.delegate tableCellDidChangeUIState:self];
    }
}

- (NSArray *)constraintsForNormalState
{
    if (!_constraintsForNormalState) {
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_typeButton, _domainStartTextField, _latticeTextField);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_domainStartTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_latticeTextField]"
                                               options:0 metrics:nil views:group]];
        
        // horizontally position the domain group
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_openPar
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainStartTextField
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_openPar
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:SPACING_OF_DOMAIN_GROUP]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_comma
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_domainStartTextField
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:SPACING_OF_DOMAIN_GROUP]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainEndTextField
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_comma
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:SPACING_OF_DOMAIN_GROUP]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_closePar
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_domainEndTextField
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:SPACING_OF_DOMAIN_GROUP]];
        
        // Horizontally position the label
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        
        // Vertically position the labels and controls
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_openPar
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_openPar
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_domainStartTextField
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainStartTextField
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_comma
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_comma
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_domainEndTextField
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainEndTextField
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_closePar
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        _constraintsForNormalState = [constraintsArray copy];
    }
    return _constraintsForNormalState;
}

- (NSArray *)constraintsForHermiteGaussState
{
    if (!_constraintsForHermiteGaussState) {
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_typeButton, _lengthScaleTextField, _spectralLatticeTextField, _latticeTextField);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_lengthScaleTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_spectralLatticeTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_latticeTextField]"
                                               options:0 metrics:nil views:group]];
        
        // Horizontally position the length scale textfield
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_lengthScaleTextField
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
            
        // Horizontally position the spectral lattice textfield
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_spectralLatticeTextField
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
                
        // Horizontally position the labels
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_lengthScaleLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_spectralLatticeLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];

        
        // Vertically position the labels and controls
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_lengthScaleLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_lengthScaleTextField
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_spectralLatticeLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_spectralLatticeTextField
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        _constraintsForHermiteGaussState = [constraintsArray copy];
    }
    return _constraintsForHermiteGaussState;
}

- (NSArray *)constraintsForBesselState
{
    if (!_constraintsForBesselState) {
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_typeButton, _domainStartTextField, _orderTextField, _latticeTextField);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_domainStartTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_orderTextField]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_latticeTextField]"
                                               options:0 metrics:nil views:group]];
        
        // horizontally position the domain group
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_openPar
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainStartTextField
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_openPar
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:SPACING_OF_DOMAIN_GROUP]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_comma
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_domainStartTextField
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:SPACING_OF_DOMAIN_GROUP]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainEndTextField
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_comma
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:SPACING_OF_DOMAIN_GROUP]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_closePar
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_domainEndTextField
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f
                                                                  constant:SPACING_OF_DOMAIN_GROUP]];
        
        // Horizontally position the label
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_orderLabel  
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        
        // Horizontally position the order textfield
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_orderTextField
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        
        // Vertically position the labels and controls
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_openPar
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_openPar
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_domainStartTextField
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainStartTextField
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_comma
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_comma
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_domainEndTextField
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_domainEndTextField
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_closePar
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_orderLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderTextField
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
        _constraintsForBesselState = [constraintsArray copy];
    }
    return _constraintsForBesselState;
}

- (NSString *)cellHelpIdentifier
{
    return @"dimensionelement";
}

@end
