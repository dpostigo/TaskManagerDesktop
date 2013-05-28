//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableRowObject.h"


@interface OutlineRowObject : TableRowObject {
    BOOL isExpandable;
}


@property(nonatomic) BOOL isExpandable;
- (id) initWithTextLabel: (NSString *) aTextLabel isExpandable: (BOOL) aIsExpandable;
@end