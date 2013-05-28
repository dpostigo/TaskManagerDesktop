//
//  JSViewWithSlidingViews.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 5/11/12.
//
//

#import "DPViewWithSlidingViews.h"
#import <QuartzCore/QuartzCore.h>


NSString *const JSViewWithSlidingViewDidChangedView = @"JSViewWithSlidingViewDidChangedView";


@interface DPViewWithSlidingViews ()


// arrayOfPackages is a stack of dictionaries containing the view, its view controller, and its constraint to the super view (the placeholder view)
@property(nonatomic, strong) NSMutableArray *arrayOfPackages;

@end


@implementation DPViewWithSlidingViews

# pragma mark - Setters and getters

- (NSMutableArray *) arrayOfPackages {
    if (!_arrayOfPackages) {
        _arrayOfPackages = [NSMutableArray array];
    }
    return _arrayOfPackages;
}

// utility method that packges a view controller and its view in a mutable dictionary
- (NSMutableDictionary *) packageView: (NSViewController *) viewController {
    return [NSMutableDictionary dictionaryWithObjects: [NSArray arrayWithObjects: viewController.view, viewController, nil] forKeys: [NSArray arrayWithObjects: @"view", @"viewController", nil]];
}

// We are going to add the new view off screen and then animate it within the placeholder view by changing the constant in the constraints
- (void) slideViewController: (NSViewController *) controller fromDirection: (JSSlidingDirection) direction {
    // if we are already displaying the passed viewController do nothing
    if (controller == self.currentViewController) return;

    [self replacePlaceholderViewWith: controller block: ^(NSView *placeholder, NSMutableDictionary *newPackage) {

        // first based on the passed direction we calculate how much we have to shift the current view to take it off screen
        // second we compute the initial point (offset) at which place the new view
        // third we decide if we want an horizontal or vertical slide (JSAnimationType)
        CGFloat shift;
        NSPoint offset;
        JSAnimationType animationType;
        switch (direction) {
            case JSSlidingFromTop:
                shift = placeholder.bounds.size.height;
                offset = NSMakePoint(0.0, shift);
                animationType = JSSlidingUpAndDownAnimation;
                break;
            case JSSlidingFromBottom:
                shift = -placeholder.bounds.size.height;
                offset = NSMakePoint(0.0, shift);
                animationType = JSSlidingUpAndDownAnimation;
                break;
            case JSSlidingFromLeft:
                shift = -placeholder.bounds.size.width;
                offset = NSMakePoint(shift, 0.0);
                animationType = JSSlidingLeftAndRightAnimation;
                break;
            case JSSlidingFromRight:
                shift = placeholder.bounds.size.width;
                offset = NSMakePoint(shift, 0.0);
                animationType = JSSlidingLeftAndRightAnimation;
                break;
        }

        // extract the new view from the passed dictionary and compute the new constraints
        NSView *newView = [newPackage objectForKey: @"view"];
        [newView setTranslatesAutoresizingMaskIntoConstraints: NO];
        NSArray *newConstraints = [self layoutConstraintsForView: newView offsetBy: offset];
        [self animationForConstraints: newConstraints ofType: animationType];

        // we add the new constraints to the packaged that was passed so that we can hold onto them and animate them later when the view we are adding now will be moved off screen by a new one
        [newPackage setObject: newConstraints forKey: @"constraints"];

        [placeholder addSubview: newView];
        [placeholder addConstraints: newConstraints];

        // if arrayOfPackages already contains a package it means that we are displacing a view that was already there so we grab its constraints for the dictionary and animate them
        if (self.arrayOfPackages.count) {
            NSArray *oldConstraints = [[self.arrayOfPackages lastObject] objectForKey: @"constraints"];
            [[oldConstraints[animationType] animator] setConstant: -shift];
        }

        // animate the new constraints to slide the new view inn
        [[newConstraints[animationType] animator] setConstant: 0.0];

        // finally let's append this new package to the stack
        [self.arrayOfPackages addObject: newPackage];
    }];
    NSNotification *slideNotification = [NSNotification notificationWithName: JSViewWithSlidingViewDidChangedView object: self];
    [[NSNotificationCenter defaultCenter] postNotification: slideNotification];
}

- (void) replacePlaceholderViewWith: (NSViewController *) controller block: (JSPlaceholderReplaceBlockWithPackage) handler {
    NSView *placeholderView = self;
    // use the passed block to slide in the new view packaged in the mutable dictionary
    handler(placeholderView, [self packageView: controller]);
}

// create the constraints for placing the new view in the placeholder view
// We always return constraints in order: left, width, top, height.
- (NSArray *) layoutConstraintsForView: (NSView *) view offsetBy: (NSPoint) offset {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity: 4];
    NSView *placeholder = self;
    [result addObject: [NSLayoutConstraint constraintWithItem: view
                                                    attribute: NSLayoutAttributeLeft
                                                    relatedBy: NSLayoutRelationEqual
                                                       toItem: placeholder
                                                    attribute: NSLayoutAttributeLeft
                                                   multiplier: 1.0 constant: offset.x]];
    [result addObject: [NSLayoutConstraint constraintWithItem: view
                                                    attribute: NSLayoutAttributeWidth
                                                    relatedBy: NSLayoutRelationEqual
                                                       toItem: placeholder
                                                    attribute: NSLayoutAttributeWidth
                                                   multiplier: 1.0 constant: 0.0]];
    [result addObject: [NSLayoutConstraint constraintWithItem: view
                                                    attribute: NSLayoutAttributeTop
                                                    relatedBy: NSLayoutRelationEqual
                                                       toItem: placeholder
                                                    attribute: NSLayoutAttributeTop
                                                   multiplier: 1.0 constant: offset.y]];
    [result addObject: [NSLayoutConstraint constraintWithItem: view
                                                    attribute: NSLayoutAttributeHeight
                                                    relatedBy: NSLayoutRelationEqual
                                                       toItem: placeholder
                                                    attribute: NSLayoutAttributeHeight
                                                   multiplier: 1.0 constant: 0.0]];
    return result;
}

// Here we attach the animation to the constraints we created with the previous method
- (void) animationForConstraints: (NSArray *) constraints ofType: (JSAnimationType) animationType {
    // Finally prepare a new animation for the transition; we need it so that we can intercept animationDidStop:finished: and remove old view.
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;

    // The 4 constraints are ordered: offsetX, width, offsetY, height
    // NSSlidingUpAndDownAnimation has value 2 because we want to modify the y component
    // NSSlidingLeftAndRightAnimation has value 0 because we want to modify the x component
    if ((animationType == JSSlidingLeftAndRightAnimation) || (animationType == JSSlidingUpAndDownAnimation))
        [constraints[animationType] setAnimations: @{@"constant" : animation}];
}

- (void) animationDidStop: (CAAnimation *) anim finished: (BOOL) flag {
    // Once animation is finished, we should remove previous view. Note that the delegate is called two times as we have two animations running for both views. Hence we need to take care to only remove original view! We simply remove first view in hierarchy as we always append new one after it - kind of a hack, but works...
    if (!flag || self.arrayOfPackages.count < 2) return;

    // animations are stack when called one after the other so this method gets called sequentially in the order the animations where stacked
    // the packages in arrayOfPackages are stacked as the animations (FIFO)
    // we proceed to first remove the old view from the super view
    NSView *oldView = [[self.arrayOfPackages objectAtIndex: 0] objectForKey: @"view"];
    [oldView removeFromSuperview];

    // and by removing the package from the stack we ensure that the view controller, the view, and the constraints are released since nothing is pointing to them any more
    [self.arrayOfPackages removeObjectAtIndex: 0];
}

// the current view controller is simply the view controller packaged last in the stack of view controllers
- (NSViewController *) currentViewController {
    if (self.arrayOfPackages.count) return [[self.arrayOfPackages lastObject] objectForKey: @"viewController"];
    return nil;
}

@end
