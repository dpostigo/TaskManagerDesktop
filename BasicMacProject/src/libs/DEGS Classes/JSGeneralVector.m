//
//  JSGeneralVector.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSGeneralVector.h"

@implementation JSGeneralVector

# pragma mark - Setters and getters

-(void)setType:(NSUInteger)type
{
    if (type <= ([self.typeOptions count]-1)) {
        _type = type;
    }
}

- (NSArray *)typeOptions
{
    return @[@"real", @"complex"];
}

@end
