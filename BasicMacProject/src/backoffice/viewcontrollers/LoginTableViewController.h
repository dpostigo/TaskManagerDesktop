//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicTableViewController.h"


@interface LoginTableViewController : BasicTableViewController <NSTextFieldDelegate> {

    __unsafe_unretained NSWindow *window;
    NSTextField *usernameField;
    NSTextField *passwordField;
}


@property(nonatomic, assign) NSWindow *window;
@property(nonatomic, strong) NSTextField *usernameField;
@property(nonatomic, strong) NSTextField *passwordField;
@end