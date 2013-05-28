//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicTableCellView.h"
#import "BasicTokenField.h"


@interface BasicTokenCell : BasicTableCellView {
    IBOutlet BasicTokenField *tokenField;
}


@property(nonatomic, strong) BasicTokenField *tokenField;
@end