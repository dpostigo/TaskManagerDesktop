//
//  JSPreamble.m
//  DEGS Model
//
//  Created by Jacopo Sabbatini on 11/12/12.
//  Copyright (c) 2012 Jacopo Sabbatini. All rights reserved.
//

#import "JSPreamble.h"
#import "JSXMDS.h"

@implementation JSPreamble

- (NSString *)description
{
    return @"Preamble";
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    if ([[components objectAtIndex:0] isEqualToString:@"description"]) [components replaceObjectAtIndex:0 withObject:@"scriptDescription"];
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}

@end
