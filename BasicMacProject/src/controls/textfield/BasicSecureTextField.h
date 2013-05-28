//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableRowObject.h"
#import "TableSection.h"


@interface BasicSecureTextField : NSSecureTextField {
    __unsafe_unretained TableRowObject *rowObject;
    __unsafe_unretained TableSection *tableSection;
}


@property(nonatomic, assign) TableRowObject *rowObject;
@property(nonatomic, assign) TableSection *tableSection;
@end