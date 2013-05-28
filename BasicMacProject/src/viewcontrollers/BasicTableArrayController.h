//
// Created by Daniela Postigo on 4/21/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "VeryBasicViewController.h"
#import "BasicArrayViewController.h"


@interface BasicTableArrayController : BasicArrayViewController <NSTableViewDataSource, NSTableViewDelegate> {

    IBOutlet NSTableView *table;
}

@end