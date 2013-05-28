//
// Created by Daniela Postigo on 5/7/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "VeryBasicViewController.h"


@interface BasicArrayViewController : VeryBasicViewController {

    NSMutableArray *arraySource;
    IBOutlet NSArrayController *arrayController;
}


@property(nonatomic, strong) NSMutableArray *arraySource;
@property(nonatomic, strong) NSArrayController *arrayController;
- (void) prepareDataSource;
@end