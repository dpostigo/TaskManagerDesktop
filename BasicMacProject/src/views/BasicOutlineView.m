//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicOutlineView.h"
#import "SidebarTableCellView.h"


@implementation BasicOutlineView {
}


@synthesize topLevelItems;
@synthesize childrenDictionary;


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {

        childrenDictionary = [NSMutableDictionary new];
        [self sizeLastColumnToFit];

        self.floatsGroupRows = NO;

        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration: 0];
        [self expandItem: nil expandChildren: YES];
        [NSAnimationContext endGrouping];
    }

    return self;
}


- (void) expandParentsOfItem: (id) item {
    while (item != nil) {
        id parent = [self parentForItem: item];
        if (![self isExpandable: parent])
            break;
        if (![self isItemExpanded: parent])
            [self expandItem: parent];
        item = parent;
    }
}


- (void) selectItem: (id) item {
    NSInteger itemIndex = [self rowForItem: item];
    if (itemIndex < 0) {
        [self expandParentsOfItem: item];
        itemIndex = [self rowForItem: item];
        if (itemIndex < 0)
            return;
    }

    [self selectRowIndexes: [NSIndexSet indexSetWithIndex: itemIndex] byExtendingSelection: NO];
}


- (NSArray *) childrenForItem: (id) item {
    NSArray *children;

    if (item == nil) {
        children = topLevelItems;
    } else {
        children = [childrenDictionary objectForKey: item];
    }

    return children;
}



@end