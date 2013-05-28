//
// Created by Daniela Postigo on 5/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TableSection.h"


@implementation TableSection {
}


@synthesize rows;
@synthesize title;

- (id) initWithTitle: (NSString *) aTitle {
    self = [super init];
    if (self) {
        self.title = aTitle;
        self.rows = [[NSMutableArray alloc] init];
    }

    return self;
}

- (id) initWithTitle: (NSString *) aTitle content: (id) aContent {
    self = [super init];
    if (self) {
        self.title = aTitle;
        self.rows = [[NSMutableArray alloc] init];
        self.content = aContent;
    }

    return self;
}

@end