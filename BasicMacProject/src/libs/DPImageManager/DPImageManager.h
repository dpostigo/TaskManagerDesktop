//
// Created by Daniela Postigo on 5/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface DPImageManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {

    BOOL shouldCache;
    NSMutableDictionary *imageDictionary;
    NSOperationQueue *queue;
}

@property(nonatomic, strong) NSOperationQueue *queue;
@property(nonatomic, strong) NSMutableDictionary *imageDictionary;
@property(nonatomic) BOOL shouldCache;
+ (DPImageManager *) sharedManager;

- (void) loadImage: (NSURL *) url;
@end