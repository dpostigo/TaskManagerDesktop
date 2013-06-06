//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NavigationController.h"
#import "VeryBasicViewController.h"
#import "NSView+Animation.h"


@implementation NavigationController {
    BasicBackgroundView *modalBackground;
}


@synthesize viewControllers;
@synthesize rootViewController;
@synthesize navigationBar;
@synthesize navigationBarHidden;
@synthesize contentView;
@synthesize navigationBarHeight;


@synthesize defaultAnimationDuration;

- (id) initWithRootViewController: (VeryBasicViewController *) aRootViewController {
    self = [super init];
    if (self) {


        self.rootViewController = aRootViewController;
        self.view = [[NSView alloc] init];
        self.viewControllers = [[NSMutableArray alloc] init];


        defaultAnimationDuration = 0.2;
        contentView = [[NSView alloc] initWithFrame: self.view.bounds];
        contentView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self.view addSubview: contentView];
        [self addViewController: rootViewController animated: NO completion: nil];


        navigationBarHeight = 30;
        navigationBar = [[NavigationBar alloc] initWithFrame: NSMakeRect(0, 0, self.view.width, 40)];
    }

    return self;
}




#pragma mark Pop / push


- (void) presentModalView: (VeryBasicViewController *) controller {
}

- (void) popViewController {
    VeryBasicViewController *controller = [viewControllers lastObject];
    [self popViewController: controller animated: YES completion: nil];
}


- (void) popViewController: (VeryBasicViewController *) controller animated: (BOOL) isAnimated completion: (void (^)()) completionHandler {
    if (isAnimating) return;
    isAnimating = YES;


    controller.navigationController = nil;
    [viewControllers removeObject: controller];

    VeryBasicViewController *previousController = [viewControllers lastObject];
    CGFloat toWidth = contentView.width;

    if (isAnimated) {
        [previousController.view animateInDirection: NSViewAnimationDirectionToRight amount: toWidth duration: defaultAnimationDuration alpha: 1];
        [controller.view animateInDirection: NSViewAnimationDirectionToRight amount: toWidth duration: defaultAnimationDuration alpha: 1 completionHandler: ^{
            isAnimating = NO;
            [controller.view removeFromSuperview];
            if (completionHandler != nil) completionHandler();
        }];

    } else {
        isAnimating = NO;
        [controller.view removeFromSuperview];
    }


}

- (void) pushViewController: (VeryBasicViewController *) controller animated: (BOOL) isAnimated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self pushViewController: controller animated: isAnimated completion: nil];
}

- (void) pushViewController: (VeryBasicViewController *) controller animated: (BOOL) isAnimated completion: (void (^)()) completionHandler {
    //    NSViewController *lastController = [viewControllers lastObject];
    [self addViewController: controller animated: isAnimated completion: completionHandler];
}

- (void) setNavigationBar: (NavigationBar *) navigationBar1 {
    if (navigationBar && navigationBar.superview) [navigationBar removeFromSuperview];
    navigationBar = navigationBar1;
}

- (void) setNavigationBarHidden: (BOOL) navigationBarHidden1 {
    navigationBarHidden = navigationBarHidden1;
    navigationBar.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;

    NSRect toRect = [self navigationBarVisibleRect];
    NSRect hiddenRect = [self navigationBarHiddenRect];

    navigationBar.frame = hiddenRect;
    //    [self.view addSubview: navigationBar];

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration: 0.5];
    [navigationBar.animator setFrame: toRect];
    [NSAnimationContext endGrouping];
}

- (VeryBasicViewController *) visibleViewController {
    return ([viewControllers count] > 0) ? [viewControllers lastObject] : nil;
}



#pragma mark Add / Remove

- (void) addViewController: (VeryBasicViewController *) controller {
    [self addViewController: controller animated: NO completion: nil];
}


- (void) addViewController: (VeryBasicViewController *) controller animated: (BOOL) isAnimated {
    [self addViewController: controller animated: isAnimated completion: nil];
}

- (void) addViewController: (VeryBasicViewController *) newController animated: (BOOL) isAnimated completion: (void (^)()) completionHandler {
    if (isAnimating) return;
    isAnimating = YES;

    newController.navigationController = self;
    newController.view.frame = self.view.bounds;
    newController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable | NSViewMaxYMargin;


    VeryBasicViewController *currentController = [viewControllers count] > 0 ? [viewControllers lastObject] : nil ;
    [viewControllers addObject: newController];
    CGFloat toWidth = contentView.width;


    if (isAnimated) {
        if (currentController) {
            [currentController.view animateInDirection: NSViewAnimationDirectionToLeft amount: currentController.view.width duration: defaultAnimationDuration alpha: 1 completionHandler: ^{


            }];
        }

        [newController.view animateInDirection: NSViewAnimationDirectionFromRight amount: newController.view.width duration: defaultAnimationDuration alpha: 1 completionHandler: ^{
            isAnimating = NO;
            completionHandler();
            [newController viewDidAppear];
        }];
        [self.view addSubview: newController.view];
    } else {
        [self.view addSubview: newController.view];
        isAnimating = NO;
        [newController viewDidAppear];
    }
}


#pragma mark IBActions


- (void) targetBackButton {
    if (navigationBar.backButtonItem != nil) {
        navigationBar.backButtonItem.target = self;
        navigationBar.backButtonItem.action = @selector(handleBackButton:);
    }
}

- (IBAction) handleBackButton: (id) sender {
    [self popViewController];
}


#pragma mark Helpers


- (CGFloat) heightForViewControllerWithNavigationBar {
    return self.view.height - navigationBar.height;
}

- (NSRect) viewControllerHiddenRightRect: (VeryBasicViewController *) controller {
    NSRect rect = NSZeroRect;
    rect.size.width = self.view.width;
    rect.size.height = controller.showsNavigationBar ? self.view.height - navigationBarHeight : self.view.height;
    rect.origin.x = self.view.width;
    return rect;
}

- (NSRect) viewControllerHiddenLeftRect: (VeryBasicViewController *) controller {
    NSRect rect = NSZeroRect;
    rect.size.width = self.view.width;
    rect.size.height = controller.showsNavigationBar ? self.view.height - navigationBarHeight : self.view.height;
    rect.origin.x = -self.view.width;
    return rect;
}

- (NSRect) viewControllerVisibleRect: (VeryBasicViewController *) controller {
    NSRect rect = NSZeroRect;
    rect.size.width = self.view.width;
    rect.size.height = controller.showsNavigationBar ? self.view.height - navigationBarHeight : self.view.height;
    return rect;
}


- (NSRect) navigationBarHiddenRect {
    NSRect hiddenRect = NSZeroRect;
    hiddenRect.size.width = self.view.width;
    hiddenRect.size.width = self.view.width;
    hiddenRect.size.height = navigationBarHeight;
    hiddenRect.origin.y = self.view.height + navigationBarHeight;
    return hiddenRect;
}

- (NSRect) navigationBarVisibleRect {
    NSRect toRect = NSZeroRect;
    toRect.size.width = self.view.width;
    toRect.size.height = navigationBarHeight;
    toRect.origin.y = self.view.height - navigationBarHeight;
    return toRect;
}
@end