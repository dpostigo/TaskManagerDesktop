//
//  JSOperatorStack.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 21/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSOperatorStack.h"
#import "JSOperator.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@interface JSOperatorStack () {
    NSMutableArray *_operators;
}

@end

@implementation JSOperatorStack

# pragma mark - Setters and getters

-(NSArray *)operators
{
    return [_operators copy];
}

- (NSUInteger)numberOfOperators
{
    return [self.operators count];
}

# pragma mark - Initialiser and exporter

- (NSArray *)exportAsXMLElements
{
    NSMutableArray *elementsArray = [NSMutableArray array];
    for (JSOperator *Operator in _operators) {
        NSXMLElement *newOperatorNode = [Operator exportAsXML];
        [elementsArray addObject:newOperatorNode];
    }
    return elementsArray;
}

- (id)initFromXMLElements:(NSArray *)elements
{
    if (self = [super init]) {
        for (NSXMLElement *anElement in elements) {
            JSOperator *newOperator = [[JSOperator alloc] initFromXML:anElement];
            if (newOperator) [self addOperator:newOperator];
        }
    }
    return self;
}

# pragma mark - Utility methods

- (void)prepareForNewOperator:(JSOperator *)operator
{
    [operator setParent:self];
    if (!_operators) _operators = [NSMutableArray array];
}

- (void)addOperator:(JSOperator *)operator
{
    [self prepareForNewOperator:operator];
    [_operators addObject:operator];
}

- (void)addOperator:(JSOperator *)operator atIndex:(NSUInteger)index
{
    [self prepareForNewOperator:operator];
    [_operators insertObject:operator atIndex:index];
}

- (void)deleteOperatorAtIndex:(NSUInteger)index
{
    [_operators removeObjectAtIndex:index];
}

- (void)deleteOperatorsAtIndexes:(NSIndexSet *)indexes
{
    [_operators removeObjectsAtIndexes:indexes];
}

- (NSString *)description
{
    NSString *title = @"Operator";
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    NSString *elementName = components[0];
    NSUInteger index = [elementName indexInString:&elementName];
    
    if ([elementName isEqualToString:@"operator"]) elementName = @"operators";
    if ([elementName isEqualToString:@"operators"] && index == NSNotFound) index = 0;
    [components replaceObjectAtIndex:0 withObject:[elementName stringByAppendingIndex:index]];
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}

@end
