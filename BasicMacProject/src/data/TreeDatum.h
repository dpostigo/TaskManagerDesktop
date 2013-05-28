//
//  TreeDatum.h
//  TreeTest
//
//  Created by Brent Burton on 4/2/09.
//  Copyright 2009 Designed Recreations. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TreeDatum : NSObject {
    NSString *name;
    NSString *value;
}


@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *value;
+ (TreeDatum *) treeDatumFromName: (NSString *) name value: (NSString *) value;

@end
