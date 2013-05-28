//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicSaveOperation.h"


@implementation BasicSaveOperation {
}


- (id) init {
    self = [super init];
    if (self) {
        saveDictionary = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void) main {
    [super main];
    NSArray *keys = [saveDictionary allKeys];
    for (NSString *key in keys) {
        id object = [saveDictionary objectForKey: key];
        [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: object] forKey: key];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) testDearchive {
    NSArray *array = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: @"items"];
    if (data != nil) {
        array = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        NSLog(@"array.count = %lu", array.count);
    } else {
    }
}

- (void) saveImagesForObjects: (NSArray *) objects {
    //
    //    NSError *error = nil;
    //    NSString *imagesDirectory = [Model imagesDirectoryPath];
    //    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath: imagesDirectory];
    //    if (!directoryExists) {
    //        [[NSFileManager defaultManager] createDirectoryAtPath: imagesDirectory withIntermediateDirectories: YES attributes: nil error: &error];
    //    }
    //
    //    for (BasicContentObject *object in objects) {
    //        if (object.image != nil && object.isUpdated) {
    //            object.imageId = [BasicContentObject uniqueId];
    //
    //            NSString *imagePath = [NSString stringWithFormat: @"%@/%@", imagesDirectory, object.imageId];
    //            NSLog(@"imagesDirectory = %@", imagesDirectory);
    //            NSLog(@"imagePath = %@", imagePath);
    //            [self saveImage: object.image toPath: imagePath];
    //        }
    //    }
}


//- (void) saveImage: (NSImage *) image toPath: (NSString *) path {
//    NSArray *representations = [image representations];
//    NSData *bitmapData = [NSBitmapImageRep representationOfImageRepsInArray: representations usingType: NSJPEGFileType properties: nil];
//
//
//    //    NSData *imageData = [image TIFFRepresentation];
//    //    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData: imageData];
//    //    NSDictionary *imageProps = [NSDictionary dictionaryWithObject: [NSNumber numberWithFloat: 1.0] forKey: NSImageCompressionFactor];
//    //    imageData = [imageRep representationUsingType: NSJPEGFileType properties: imageProps];
//    [bitmapData writeToFile: path atomically: NO];
//
//    NSError *error = nil;
//    [bitmapData writeToFile: path options: NSDataWritingAtomic error: &error];
//
//    if (error) {
//        NSLog(@"error = %@", error);
//    }
//}

@end