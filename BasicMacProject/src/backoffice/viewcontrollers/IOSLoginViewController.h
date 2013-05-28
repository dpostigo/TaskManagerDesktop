//
// Created by dpostigo on 2/24/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicTableArrayController.h"
#import "BasicTableViewControllerProtocol.h"
#import "CBLayer.h"


@interface IOSLoginViewController : BasicTableArrayController <BasicTableViewControllerProtocol> {

    IBOutlet UIView *footerView;

    IBOutlet UIButton *loginButton;
    IBOutlet CBLayer *signUpButton;

    CGSize modalSize;
}


@property(nonatomic, strong) CBLayer *signUpButton;
@property(nonatomic) CGSize modalSize;
- (IBAction) handleLogin: (id) sender;
- (IBAction) handleSignup: (id) sender;

@end