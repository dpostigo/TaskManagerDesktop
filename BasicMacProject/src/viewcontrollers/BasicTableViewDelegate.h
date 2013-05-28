//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicTableViewController.h"


@interface BasicTableViewDelegate : NSObject <NSTableViewDataSource, NSTableViewDataSource, NSTableViewDelegate> {
    BasicTableViewController *viewController;
    NSMutableArray *dataSource;

}


@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) BasicTableViewController *viewController;
- (id) initWithViewController: (BasicTableViewController *) aViewController;

@end