//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "NSView+Animation.h"


@implementation NSView (Animation)


- (void) animateView: (NSView *) view inWindow: (NSWindow *) window duration: (CGFloat) duration {

    NSRect toRect = view.frame;
    view.top -= 10;
    view.alphaValue = 0;

    [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
        context.duration = duration;
        context.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        [view.animator setFrame: toRect];
        [view.animator setAlphaValue: 1];
    }                   completionHandler: ^{
    }];
}

- (void) animateInDirection: (NSViewAnimationDirection) direction amount: (CGFloat) amount duration: (CGFloat) duration {
    [self animateInDirection: direction amount: amount duration: duration completionHandler: nil];
}

- (void) animateInDirection: (NSViewAnimationDirection) direction amount: (CGFloat) amount duration: (CGFloat) duration completionHandler: (void (^)()) completionHandler {
    NSRect toRect = self.frame;
    NSRect fromRect = self.frame;

    switch (direction) {
        case NSViewAnimationDirectionToTop :
            toRect.origin.y += amount;
            break;

        case NSViewAnimationDirectionToBottom :
            toRect.origin.y -= amount;
            break;

        case NSViewAnimationDirectionToLeft :
            toRect.origin.x -= amount;

        case NSViewAnimationDirectionToRight:
            toRect.origin.x += amount;
            break;

        case NSViewAnimationDirectionFromTop :
            fromRect.origin.y += amount;
            break;

        case NSViewAnimationDirectionFromBottom :
            fromRect.origin.y -= amount;
            break;

        case NSViewAnimationDirectionFromLeft :
            fromRect.origin.y -= amount;
            break;

        case NSViewAnimationDirectionFromRight :
            fromRect.origin.y += amount;
            break;
    }

    self.frame = fromRect;

    [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
        context.duration = duration;
        context.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        [self.animator setFrame: toRect];
    }                   completionHandler: completionHandler];
}

- (void) animateInDirection: (NSViewAnimationDirection) direction amount: (CGFloat) amount duration: (CGFloat) duration alpha: (CGFloat) toAlpha {
    [self animateInDirection: direction amount: amount duration: duration alpha: toAlpha completionHandler: nil];


}

- (void) animateInDirection: (NSViewAnimationDirection) direction amount: (CGFloat) amount duration: (CGFloat) duration alpha: (CGFloat) toAlpha completionHandler: (void (^)()) completionHandler {
    NSRect toRect = self.frame;
    NSRect fromRect = self.frame;


    switch (direction) {
        case NSViewAnimationDirectionToTop :
            toRect.origin.y += amount;
            break;

        case NSViewAnimationDirectionToBottom :
            toRect.origin.y -= amount;
            break;

        case NSViewAnimationDirectionToLeft :
            toRect.origin.x -= amount;
            break;

        case NSViewAnimationDirectionToRight:
            toRect.origin.x += amount;
            break;

        case NSViewAnimationDirectionFromTop :
            fromRect.origin.y += amount;
            break;

        case NSViewAnimationDirectionFromBottom :
            fromRect.origin.y -= amount;
            break;

        case NSViewAnimationDirectionFromLeft :
            fromRect.origin.x -= amount;
            break;

        case NSViewAnimationDirectionFromRight :
            fromRect.origin.x += amount;
            break;
    }

    self.frame = fromRect;
    //    self.alphaValue = toAlpha == 0 ? 1 : 0;


    [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
        context.duration = duration;
        context.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        [self.animator setFrame: toRect];
        [self.animator setAlphaValue: toAlpha];
    }                   completionHandler: completionHandler];
}

@end