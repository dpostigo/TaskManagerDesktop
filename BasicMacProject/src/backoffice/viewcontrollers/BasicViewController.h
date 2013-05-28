//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "VeryBasicViewController.h"


@interface BasicViewController : VeryBasicViewController {

    IBOutlet NSScrollView *mainScrollView;
    IBOutlet NSTextField *titleLabel;
}


@property(nonatomic, strong) NSTextField *titleLabel;

@end