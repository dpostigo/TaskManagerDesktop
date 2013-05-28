//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OutlineRowObject.h"


@implementation OutlineRowObject {
}


@synthesize isExpandable;


- (id) initWithTextLabel: (NSString *) aTextLabel isExpandable: (BOOL) aIsExpandable {
    self = [super init];
    if (self) {
        self.textLabel = aTextLabel;
        self.isExpandable = aIsExpandable;
    }

    return self;
}


@end