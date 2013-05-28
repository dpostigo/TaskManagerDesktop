//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableRowObject.h"


@interface BasicTokenField : NSTokenField {
    __unsafe_unretained TableRowObject *rowObject;
}


@property(nonatomic, assign) TableRowObject *rowObject;
@end