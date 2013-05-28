//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OutlineSection.h"


@implementation OutlineSection {
}


@synthesize isExpandable;

- (id) initWithTitle: (NSString *) aTitle {
    return [self initWithTitle: aTitle isExpandable: YES];
}

- (id) initWithTitle: (NSString *) aTitle isExpandable: (BOOL) aIsExpandable {
    self = [super initWithTitle: aTitle];
    if (self) {
        self.isExpandable = aIsExpandable;
    }

    return self;
}

- (id) initWithTitle: (NSString *) aTitle isExpandable: (BOOL) aIsExpandable cellIdentifier: (NSString *) aIdentifier {
    self = [super initWithTitle: aTitle];
    if (self) {
        self.isExpandable = aIsExpandable;
        self.cellIdentifier = aIdentifier;
    }

    return self;
}

@end