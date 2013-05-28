//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


typedef enum {
    NSViewAnimationDirectionToTop = 0,
    NSViewAnimationDirectionToBottom = 2,
    NSViewAnimationDirectionToLeft = 3,
    NSViewAnimationDirectionToRight = 4,
    NSViewAnimationDirectionFromTop = 5,
    NSViewAnimationDirectionFromBottom = 6,
    NSViewAnimationDirectionFromLeft = 7,
    NSViewAnimationDirectionFromRight = 8
} NSViewAnimationDirection;


@interface NSView (Animation)


- (void) animateInDirection: (NSViewAnimationDirection) direction amount: (CGFloat) amount duration: (CGFloat) duration;
- (void) animateInDirection: (NSViewAnimationDirection) direction amount: (CGFloat) amount duration: (CGFloat) duration completionHandler: (void (^)()) completionHandler;
- (void) animateInDirection: (NSViewAnimationDirection) direction amount: (CGFloat) amount duration: (CGFloat) duration alpha: (CGFloat) toAlpha;
- (void) animateInDirection: (NSViewAnimationDirection) direction amount: (CGFloat) amount duration: (CGFloat) duration alpha: (CGFloat) toAlpha completionHandler: (void (^)()) completionHandler;
@end