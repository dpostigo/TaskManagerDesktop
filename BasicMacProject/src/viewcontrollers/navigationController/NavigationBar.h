//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicWhiteView.h"


@interface NavigationBar : BasicWhiteView {
    IBOutlet NSButton *backButtonItem;
    IBOutlet NSTextField *titleLabel;
    CGFloat barButtonHeight;
}


@property(nonatomic, strong) NSButton *backButtonItem;
@property(nonatomic) CGFloat barButtonHeight;
@property(nonatomic, strong) NSTextField *titleLabel;
@end