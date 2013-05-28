//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicOperation.h"


@interface BasicSaveOperation : BasicOperation {

    NSMutableDictionary *saveDictionary;
}


- (void) testDearchive;
- (void) saveImagesForObjects: (NSArray *) objects;
@end