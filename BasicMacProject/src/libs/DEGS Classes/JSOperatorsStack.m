//
//  JSOperatorsStack.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 21/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSOperatorsStack.h"
#import "JSOperators.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@interface JSOperatorsStack () {
    NSMutableArray *_operators;
}

@end

@implementation JSOperatorsStack

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
    for (JSOperators *operators in _operators) {
        NSXMLElement *newOperatorsNode = [operators exportAsXML];
        [elementsArray addObject:newOperatorsNode];
    }
    return elementsArray;
}

- (id)initFromXMLElements:(NSArray *)elements
{
    if (self = [super init]) {
        for (NSXMLElement *anElement in elements) {
            JSOperators *newOperators = [[JSOperators alloc] initFromXML:anElement];
            if (newOperators) [self addOperators:newOperators];
        }
    }
    return self;
}

# pragma mark - Utility methods

- (void)prepareForNewOperators:(JSOperators *)operators
{
    operators.parent = self;
    if (!_operators) _operators = [NSMutableArray array];
}

- (void)addOperators:(JSOperators *)operators
{
    [self prepareForNewOperators:operators];
    [_operators addObject:operators];
}

- (void)addOperators:(JSOperators *)operators atIndex:(NSUInteger)index
{
    [self prepareForNewOperators:operators];
    [_operators insertObject:operators atIndex:index];
}

- (void)deleteOperatorsAtIndex:(NSUInteger)index
{
    [_operators removeObjectAtIndex:index];
}

- (void)deleteOperatorsAtIndexes:(NSIndexSet *)indexes
{
    [_operators removeObjectsAtIndexes:indexes];
}

- (NSString *)description
{
    NSString *title = @"Operators";
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    NSString *elementName = components[0];
    NSUInteger index = [elementName indexInString:&elementName];
    
    // if the elementName was operators but the index was NSNotFound it means that the element is unique and we want the first object in the stack
    // the element at index 0 in the operators array
    if ([elementName isEqualToString:@"operators"] && index == NSNotFound) index = 0;
    
    [components replaceObjectAtIndex:0 withObject:[elementName stringByAppendingIndex:index]];
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}

@end
