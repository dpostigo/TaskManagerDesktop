//
// Created by Daniela Postigo on 5/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSImageView+DPImageManager.h"
#import "DPImageManager.h"


@implementation NSImageView (DPImageManager)


- (void) setImageWithURL: (NSURL *) url; {
    NSError *error = nil;
    NSData *data = nil;
    NSString *key = [url absoluteString];
    DPImageManager *manager = [DPImageManager sharedManager];

    NSImage *image = [manager.imageDictionary objectForKey: key];

    if (image != nil) {
        self.image = image;
    } else {
        dispatch_async(dispatch_queue_create("getAsynchronIconsGDQueue", NULL),
                ^{
                    NSImage *newImage = [[NSImage alloc] initWithContentsOfURL: url];
                    if (manager.shouldCache) [manager.imageDictionary setObject: newImage forKey: key];
                    self.image = newImage;
                });

    }
}

@end