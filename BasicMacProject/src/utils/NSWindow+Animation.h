//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface NSWindow (Animation)


- (void) animateToAlpha: (CGFloat) toAlpha fromAlpha: (CGFloat) fromAlpha duration: (CGFloat) duration;
- (void) animateToAlpha: (CGFloat) toAlpha fromAlpha: (CGFloat) fromAlpha duration: (CGFloat) duration completionHandler: (void (^)()) completionHandler;
@end