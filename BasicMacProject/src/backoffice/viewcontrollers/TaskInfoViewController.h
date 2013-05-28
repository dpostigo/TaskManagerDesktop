//
// Created by Daniela Postigo on 5/9/13.
// Copyright (c) 2013 Daniela Postigo. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "BasicTableArrayController.h"
//#import "DPTokenTextField.h"
#import "TaskDetailViewController.h"
#import "BasicTableViewController.h"


@interface TaskInfoViewController : BasicTableViewController
//        <TokenTextFieldDelegate>
{
    __unsafe_unretained TaskDetailViewController *detailController;
    CGFloat firstHeight;
}


@property(nonatomic) CGFloat firstHeight;
@property(nonatomic, assign) TaskDetailViewController *detailController;
@end