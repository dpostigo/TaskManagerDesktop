//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableSection.h"


@interface OutlineSection : TableSection {
     BOOL isExpandable;
}


@property(nonatomic) BOOL isExpandable;
- (id) initWithTitle: (NSString *) aTitle isExpandable: (BOOL) aIsExpandable;
- (id) initWithTitle: (NSString *) aTitle isExpandable: (BOOL) aIsExpandable cellIdentifier: (NSString *) aIdentifier;
@end