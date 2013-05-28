//
// Created by Daniela Postigo on 5/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RowObject.h"


@interface TableSection : RowObject {
    NSString *title;
    NSMutableArray *rows;
}


@property(nonatomic, strong) NSMutableArray *rows;
@property(nonatomic, retain) NSString *title;
- (id) initWithTitle: (NSString *) aTitle;

- (id) initWithTitle: (NSString *) aTitle content: (id) aContent;
@end