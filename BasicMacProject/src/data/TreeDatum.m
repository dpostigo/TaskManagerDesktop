//
//  TreeDatum.m
//  TreeTest
//
//  Created by Brent Burton on 4/2/09.
//  Copyright 2009 Designed Recreations. All rights reserved.
//

#import "TreeDatum.h"


@implementation TreeDatum


@synthesize name;
@synthesize value;


+ (TreeDatum *) treeDatumFromName: (NSString *) name value: (NSString *) value {
    TreeDatum *td = [[TreeDatum alloc] init];
    td.name = name;
    td.value = value;

    return td;
}

@end
