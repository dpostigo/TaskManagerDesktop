//
//  JSOperatorsStack.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 21/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSNode.h"

// The JSOperatorsStack class is a wrapper class that holds an array of JSoperators elements. It's not part of the xmds specification

@class JSOperators;

@interface JSOperatorsStack : JSNode

@property (readonly) NSArray *operators;

@property (readonly) NSUInteger numberOfOperators;
- (void)addOperators:(JSOperators *)operators;
- (void)addOperators:(JSOperators *)operators atIndex:(NSUInteger)index;
- (void)deleteOperatorsAtIndex:(NSUInteger)index;
- (void)deleteOperatorsAtIndexes:(NSIndexSet *)indexes;

- (NSArray *)exportAsXMLElements;
- (id)initFromXMLElements:(NSArray *)elements;

@end
