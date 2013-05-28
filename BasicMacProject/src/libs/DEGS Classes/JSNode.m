//
//  JSNode.m
//  DEGS Model
//
//  Created by Jacopo Sabbatini on 11/12/12.
//  Copyright (c) 2012 Jacopo Sabbatini. All rights reserved.
//

#import "JSNode.h"
#import "NSString+JSAdditions.h"
#import "JSXMDS.h"

# pragma mark - Empty object placeholder for invalid XPaths

@interface JSInvalidPathObject : NSObject

@end

@implementation JSInvalidPathObject

@end

# pragma mark - JSNode implementation

@implementation JSNode

// we use recursion to compute the root. We go up the tree using the parent property until we find a node of JSXMDS class which is the root
- (JSXMDS *)root
{
    if ([self.parent isKindOfClass:[JSXMDS class]]) return self.parent;
    return ((JSNode *)self.parent).root;
}

- (id)valueForKey:(NSString *)key
{
    // first let's look if the key has an index part
    NSUInteger index = [key indexInString:&key];
    
    if (index!=NSNotFound)
        return [[super valueForKey:key] objectAtIndex:index];
    else
        return [super valueForKey:key];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return [[JSInvalidPathObject alloc] init];
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    if (components.count == 0) return YES;
    NSString *elementName = components[0];
    id object = [self valueForKey:elementName];
    if ([object isKindOfClass:[JSInvalidPathObject class]])
        return NO;
    else {
        [components removeObjectAtIndex:0];
        [pathObjects addObject:object];
        return YES;
    }
}

- (NSArray *)pathObjects
{
    if ([self isKindOfClass:[JSXMDS class]] || !(self.parent)) return [NSArray arrayWithObject:self];
    return [[(JSNode *)self.parent pathObjects] arrayByAddingObject:self];
}

@end
