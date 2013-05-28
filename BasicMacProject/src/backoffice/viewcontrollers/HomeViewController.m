//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "SaveDataOperation.h"
#import "OldWhiteView.h"
#import "NSImage+Utils.h"
#import "SVProgressHUD.h"
#import "IOSLoginViewController.h"


@implementation HomeViewController {
    BOOL showsLoginModal;
    CGFloat mainContentTop;
    CGFloat sidebarTop;
    OldWhiteView *shadowView;
    CGFloat originalModalTop;
    float modalRevealDuration;
}


- (void) loadView {
    [super loadView];

    modalRevealDuration = 0.5;
    _model.homeController = self;

    blockerView = [[UIImageView alloc] initWithImage: [UIImage newImageFromResource: @"background-texture-ipad-dark.png"]];
    mainContent.clipsToBounds = YES;
    mainContent.layer.cornerRadius = 5.0;

    shadowView = [[OldWhiteView alloc] initWithFrame: mainContent.frame];
    [mainContent.superview insertSubview: shadowView belowSubview: mainContent];
    shadowView.layer.cornerRadius = mainContent.layer.cornerRadius + 1;
    shadowView.autoresizingMask = mainContent.autoresizingMask;
    shadowView.clipsToBounds = NO;
    shadowView.layer.shadowRadius = 10;

    if (_model.loggedIn) {
    } else {
        [self.view addSubview: blockerView];
    }

    [backgroundView removeAllSubviews];

    UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage newImageFromResource: @"background-texture-ipad-dark.png"]];
    [backgroundView addSubview: imageView];
}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    if (!_model.loggedIn && !showsLoginModal) {
        showsLoginModal = YES;
        [self performSegueWithIdentifier: @"LoginModal" sender: self];
    }
}




#pragma mark UITableView


#pragma mark IBActions


- (void) dismissLoginModal: (id) sender {
    if ([modalController isKindOfClass: [IOSLoginViewController class]]) {
        [modalController performSegueWithIdentifier: @"LoginModalDismiss" sender: modalController];
    }
}

#pragma mark Callbacks

- (void) loginSucceeded: (NSDictionary *) dictionary {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self dismissLoginModal: nil];
    [_queue addOperation: [[SaveDataOperation alloc] init]];
    [SVProgressHUD dismissWithSuccess: @"Success!"];

    [UIView animateWithDuration: 0.5 animations: ^{
        blockerView.alpha = 0;
    }                completion: ^(BOOL completion) {
        [blockerView removeFromSuperview];
    }];
}

- (void) shouldSignOut {

    mainContentTop = mainContent.right;
    sidebarTop = sidebar.top;

    [UIView animateWithDuration: 0.5 animations: ^{
        mainContent.left = -(mainContent.width);
        shadowView.top = self.view.height;
        sidebar.alpha = 0;
    }                completion: ^(BOOL completion) {

        blockerView.alpha = 1;
        [self.view addSubview: blockerView];
        mainContent.right = mainContentTop;
        sidebar.top = sidebarTop;
        sidebar.alpha = 1;

        _model.loggedIn = NO;
        _model.jobs = nil;
        _model.tasks = nil;
        _model.currentUser = nil;
        [_queue addOperation: [[SaveDataOperation alloc] init]];
        [self performSegueWithIdentifier: @"LoginModal" sender: self];
    }];
}

- (void) keyboardWillShowForTextField: (UITextField *) textField {
    [super keyboardWillShowForTextField: textField];
    [self adjustModalShow];
}

- (void) keyboardWillHide: (NSNotification *) notification {
    [self adjustModalHide];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) adjustModalShow {
    if (modalController && [modalController isKindOfClass: [IOSLoginViewController class]]) {
        return;
    }

    NSLog(@"modalView = %@", modalView);
    if (modalView != nil) {
        [UIView animateWithDuration: modalRevealDuration animations: ^{
            CGFloat newPosition = 10;
            if (!originalModalTop) originalModalTop = modalView.top;
            modalView.top = newPosition;
            modalShadow.top = newPosition;
        }];
    }
}

- (void) adjustModalHide {
    if (modalController && [modalController isKindOfClass: [IOSLoginViewController class]]) {
        return;
    }

    NSLog(@"modalView = %@", modalView);
    if (modalView != nil) {
        [UIView animateWithDuration: 0.5 animations: ^{
            modalView.top = originalModalTop;
            modalShadow.top = originalModalTop;
        }];
    }
}
@end