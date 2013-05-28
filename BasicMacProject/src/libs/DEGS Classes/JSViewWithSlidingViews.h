//
//  JSViewWithSlidingViews.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 5/11/12.
//
//

#import <Cocoa/Cocoa.h>
#import "KGNoise.h"


// notification name for the view sliding
extern NSString *const JSViewWithSlidingViewDidChangedView;

// AnimationType distinguish between horizontal or vertical sliding
typedef enum _AnimationType {
    JSSlidingUpAndDownAnimation = 2,
    JSSlidingLeftAndRightAnimation = 0
} JSAnimationType;

typedef enum _SlidingDirection {
    JSSlidingFromTop = 0,
    JSSlidingFromBottom = 1,
    JSSlidingFromLeft = 2,
    JSSlidingFromRight = 3
} JSSlidingDirection;

typedef void(^JSPlaceholderReplaceBlockWithPackage)(NSView *placeholder, NSMutableDictionary *newPackage);


@interface JSViewWithSlidingViews : KGNoiseView


// returns the view controller whose view is currently displayed by this view
@property(readonly) NSViewController *currentViewController;

// method to slide in the view of the new view controller from direction
- (void) slideViewController: (NSViewController *) controller fromDirection: (JSSlidingDirection) direction;

@end
