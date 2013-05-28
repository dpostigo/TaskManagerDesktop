//
//  JSDriverTableCellView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 31/07/12.
//
//

#import "JSDriverTableCellView.h"

@interface JSDriverTableCellView ()

@property (strong) IBOutlet NSTextField *typeLabel;
@property (strong) IBOutlet NSTextField *pathsLabel;

@property JSDriverCellState currentState;

// we create properties for the constraints in the various state so that we can hold a reference to them.
// we create them on demand with a lazy instantiation pattern.
// by holding a reference to them we can remove and deallocate once they become unnecessary to save memory
@property (nonatomic, strong) NSArray *constraintsForNoneOrDistrbutedMPIState;
@property (nonatomic, strong) NSArray *constraintsForMultiPathState;

// convenience methods for changing state
- (void)prepareForNoneOrDistributedMPIState;
- (void)prepareForMultiPathState;

@end

@implementation JSDriverTableCellView

- (void)awakeFromNib
{
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *group = NSDictionaryOfVariableBindings(_typeLabel, _typeButton, _pathsLabel, _pathsTextField);
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(SPACE_FROM_TOP_EDGE) "-[_typeButton]"
                          options:0 metrics:nil views:group]];
    
    // Let's get the set of constraints for multiPath state and add them in block
    [self prepareForNoneOrDistributedMPIState];
    
    // Horizontally position the labels
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
    
    // Horinzontally position the button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_typeButton
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        
    // Vertically position the labels and controls
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_typeLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_typeButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:1.0f]];
    
    self.currentState = JSDriverCellNoneOrDistributedMPIState;
}

// The pattern for changing layout when the state change is:
// 1) we hide the subviews we don't need, if any, in the new state
// 2) we add the views we need, if any, to the cell
// 3) remove the old constraints and nil their reference
// 4) add the new constraints to the cell
// 5) unhide the views we need in the new state
// 6) remove the views we don't need from the cell

// attention: some of the constraints of the views that we put in or remove as the state changes are fixed.
//            since they are fixed constraints we add them in the awakeFromNib method so that we don't have to recreate them every time
//            As a general rule the fixed constraints are the ones that don't have to be added to the superview (the cell view in this case) but can be added to the controls directly (like the width).

- (void)prepareForNoneOrDistributedMPIState
{
    [_pathsLabel setHidden:YES];
    [_pathsTextField setHidden:YES];

    [self removeConstraints:self.constraintsForMultiPathState];
    _constraintsForMultiPathState = nil;
    [self addConstraints:self.constraintsForNoneOrDistrbutedMPIState];
    
    [_pathsLabel removeFromSuperview];
    [_pathsTextField removeFromSuperview];
}

- (void)prepareForMultiPathState
{
    [self addSubview:_pathsLabel];
    [self addSubview:_pathsTextField];

    [self removeConstraints:self.constraintsForNoneOrDistrbutedMPIState];
    _constraintsForNoneOrDistrbutedMPIState = nil;
    [self addConstraints:self.constraintsForMultiPathState];
    
    [_pathsLabel setHidden:NO];
    [_pathsTextField setHidden:NO];
}

- (void)setDriverCellState:(JSDriverCellState)newState
{
    if (newState != _currentState) {
        if (newState == JSDriverCellNoneOrDistributedMPIState) {
            [self prepareForNoneOrDistributedMPIState];
        } else if (newState == JSDriverCellMultiPathState) {
            [self prepareForMultiPathState];
        }
        self.currentState = newState;
        // if we changed state and layout we notify our delegate so that they can recompute the hegights if needed
        if ([self.delegate respondsToSelector:@selector(tableCellDidChangeUIState:)]) [self.delegate tableCellDidChangeUIState:self];
    }
}

- (NSArray *)constraintsForMultiPathState
{
    if (!_constraintsForMultiPathState) {
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_typeButton, _pathsLabel, _pathsTextField);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_CONTROLS) "-[_pathsTextField]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|"
                                               options:0 metrics:nil views:group]];
        
        // Horinzontally position the paths textfield and stepper
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_pathsTextField
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f
                                                                  constant:END_OF_LEFT_RECT+OFFSET_FROM_EDGE]];
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_pathsTextField
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_typeButton
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];
        
        // Horizontally position the label
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_pathsLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:END_OF_LEFT_RECT-OFFSET_FROM_EDGE]];
        
        // Vertically position the labels and controls
        [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_pathsLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_pathsTextField
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:1.0f]];
        _constraintsForMultiPathState = [constraintsArray copy];
    }
    return _constraintsForMultiPathState;
}

- (NSArray *)constraintsForNoneOrDistrbutedMPIState
{
    if (!_constraintsForNoneOrDistrbutedMPIState) {
        NSMutableArray *constraintsArray = [NSMutableArray array];
        
        NSDictionary *group = NSDictionaryOfVariableBindings(_typeButton);
        
        // Vertical constraints for the pathsTextField
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:[_typeButton]-" MACRO_VALUE_TO_STRING(SPACE_FROM_BOTTOM_EDGE) "-|"
                                               options:0 metrics:nil views:group]];
        
        _constraintsForNoneOrDistrbutedMPIState = [constraintsArray copy];
    }
    return _constraintsForNoneOrDistrbutedMPIState;
}

- (NSString *)cellHelpIdentifier
{
    return @"driverelement";
}

@end
