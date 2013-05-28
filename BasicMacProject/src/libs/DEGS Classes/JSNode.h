//
//  JSNode.h
//  DEGS Model
//
//  Created by Jacopo Sabbatini on 11/12/12.
//  Copyright (c) 2012 Jacopo Sabbatini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSXMDS;

@interface JSNode : NSObject

// the parent of the current leaf
@property (nonatomic, strong) id parent;

// the root element of the tree
@property (readonly) JSXMDS *root;

// The following property and method are used to provide a mapping by the name of an element in the xmds specification and the name of the equivalent property in DEGS implementation.
- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects;

// return the chain of objects from the current node to the root node
- (NSArray *)pathObjects;

@end
