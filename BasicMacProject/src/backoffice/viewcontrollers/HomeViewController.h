//
// Created by Daniela Postigo on 5/8/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "ModalEnabledViewController.h"


@interface HomeViewController : ModalEnabledViewController {

    IBOutlet UIView *sidebar;
    IBOutlet UIView *mainContent;
    UIImageView *blockerView;

}


@end