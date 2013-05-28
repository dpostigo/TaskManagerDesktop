//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BasicOutlineView : NSOutlineView {

    NSArray *topLevelItems;
    NSMutableDictionary *childrenDictionary;
}


@property(nonatomic, strong) NSArray *topLevelItems;
@property(nonatomic, strong) NSMutableDictionary *childrenDictionary;
- (void) expandParentsOfItem: (id) item;
- (void) selectItem: (id) item;
- (NSArray *) childrenForItem: (id) item;

@end