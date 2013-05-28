//
// Created by Daniela Postigo on 5/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPImageManager.h"


@implementation DPImageManager {

}


@synthesize queue;
@synthesize imageDictionary;

@synthesize shouldCache;

+ (DPImageManager *) sharedManager {
    static DPImageManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


- (id) init {
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc] init];


    }

    return self;
}


@end