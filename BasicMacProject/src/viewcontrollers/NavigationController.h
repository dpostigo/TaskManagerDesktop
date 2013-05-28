//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "NavigationBar.h"
#import "JSViewWithSlidingViews.h"


@class VeryBasicViewController;


@interface NavigationController : NSViewController {

    BOOL isAnimating;
    CGFloat defaultAnimationDuration;


    NSMutableArray *viewControllers;
    VeryBasicViewController *rootViewController;
    NavigationBar *navigationBar;
    CGFloat navigationBarHeight;
    BOOL navigationBarHidden;

    NSView *contentView;

    NSView *barContainer;
}


@property(nonatomic, strong) NSMutableArray *viewControllers;
@property(nonatomic, strong) VeryBasicViewController *rootViewController;
@property(nonatomic, strong) NavigationBar *navigationBar;
@property(nonatomic) BOOL navigationBarHidden;
@property(nonatomic, strong) NSView *contentView;
@property(nonatomic) CGFloat navigationBarHeight;


@property(nonatomic) CGFloat defaultAnimationDuration;
- (id) initWithRootViewController: (VeryBasicViewController *) rootViewController;
- (void) popViewController;
- (void) popViewController: (VeryBasicViewController *) controller animated: (BOOL) isAnimated completion: (void (^)()) completionHandler;
- (void) pushViewController: (VeryBasicViewController *) controller animated: (BOOL) isAnimated;
- (void) pushViewController: (VeryBasicViewController *) controller animated: (BOOL) isAnimated completion: (void (^)()) completionHandler;
- (VeryBasicViewController *) visibleViewController;
@end