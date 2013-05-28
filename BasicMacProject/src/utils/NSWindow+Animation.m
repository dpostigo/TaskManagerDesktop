//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "NSWindow+Animation.h"


@implementation NSWindow (Animation)


- (void) animateToAlpha: (CGFloat) toAlpha fromAlpha: (CGFloat) fromAlpha duration: (CGFloat) duration {
    [self animateToAlpha: toAlpha fromAlpha: fromAlpha duration: duration completionHandler: nil];
}

- (void) animateToAlpha: (CGFloat) toAlpha fromAlpha: (CGFloat) fromAlpha duration: (CGFloat) duration completionHandler: (void (^)()) completionHandler {
    self.alphaValue = fromAlpha;

    [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
        context.duration = duration;
        context.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        [self.animator setAlphaValue: toAlpha];
    }                   completionHandler: completionHandler];
}

@end