//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"


@interface BasicListViewController : BasicViewController {

    NSMutableArray *dataSource;
}


@property(nonatomic, strong) NSMutableArray *dataSource;
- (void) prepareDataSource;
@end