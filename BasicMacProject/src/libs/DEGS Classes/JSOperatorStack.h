//
//  JSOperatorStack.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 21/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSNode.h"

// The JSOperatorStack class is a wrapper class to hold an array of JSOperator. It's not part of the xmds specification

@class JSOperator;

@interface JSOperatorStack : JSNode

@property (readonly) NSArray *operators;

@property (readonly) NSUInteger numberOfOperators;
- (void)addOperator:(JSOperator *)Operator;
- (void)addOperator:(JSOperator *)Operator atIndex:(NSUInteger)index;
- (void)deleteOperatorAtIndex:(NSUInteger)index;
- (void)deleteOperatorsAtIndexes:(NSIndexSet *)indexes;

- (NSArray *)exportAsXMLElements;
- (id)initFromXMLElements:(NSArray *)elements;

@end
