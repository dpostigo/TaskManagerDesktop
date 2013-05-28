//
//  JSSequence.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/11/12.
//
//

#import "JSSequence.h"
#import "JSFilter.h"
#import "JSIntegrate.h"
#import "JSBreakpoint.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@interface JSSequence () {
    NSMutableArray *_operations;
}

// these methods provide a bridge between a notation of the form "vectorClass[index]" as used in the xmds specification and the notation "vectors[index]" used in DEGS
- (NSUInteger)indexOfElementOfKind:(Class)elementClass atIndex:(NSUInteger)index;
- (id)elementOfKind:(Class)elementClass atIndex:(NSUInteger)index;

- (JSIntegrate *)integrateAtIndex:(NSUInteger)index;
- (JSFilter *)filterAtIndex:(NSUInteger)index;
- (JSBreakpoint *)breakpointAtIndex:(NSUInteger)index;

@end

@implementation JSSequence

# pragma mark - Setters and getters

- (NSArray *)operations
{
    return [_operations copy];
}

- (NSUInteger)numberOfElements
{
    return [_operations count];
}

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"sequence"];
    for (id sequenceElement in _operations) {
        [element addChild:[sequenceElement exportAsXML]];
    }
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        for (NSXMLElement *sequenceChild in [anElement children]) {
            if ([[sequenceChild name] isEqualToString:@"filter"]) {
                JSFilter *newFilter = [[JSFilter alloc] initFromXML:sequenceChild];
                [self addElement:newFilter];
            }
            if ([[sequenceChild name] isEqualToString:@"integrate"]) {
                JSIntegrate *newIntegrate = [[JSIntegrate alloc] initFromXML:sequenceChild];
                [self addElement:newIntegrate];
            }
            if ([[sequenceChild name] isEqualToString:@"breakpoint"]) {
                JSBreakpoint *newBreakpoint = [[JSBreakpoint alloc] initFromXML:sequenceChild];
                [self addElement:newBreakpoint];
            }
        }
    }
    return self;
}

# pragma mark - Utility methods

- (void)prepareForNewElement:(JSNode *)element
{
    element.parent = self;
    if (!_operations) _operations = [NSMutableArray array];
}

- (void)addElement:(JSNode *)element
{
    [self prepareForNewElement:element];
    [_operations addObject:element];
}

- (void)addElement:(JSNode *)element atIndex:(NSUInteger)index
{
    [self prepareForNewElement:element];
    [_operations insertObject:element atIndex:index];
}

- (void)deleteElementAtIndex:(NSUInteger)index
{
    [_operations removeObjectAtIndex:index];
}

- (void)deleteElementsAtIndexes:(NSIndexSet *)indexes
{
    [_operations removeObjectsAtIndexes:indexes];
}


- (NSString *)description
{
    NSString *title = @"Sequence";
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (NSUInteger)indexOfElementOfKind:(Class)elementClass atIndex:(NSUInteger)index
{
    // if the index of the asked vector is greater than the number of vectors we return right away and save the search
    if (index>self.numberOfElements) return NSNotFound;
    
    NSInteger _index = -1;
    for (NSUInteger i = 0; i < [_operations count]; i++) {
        if ([[_operations objectAtIndex:i]  isKindOfClass:elementClass]) _index++;
        if (_index == index) return i;
    }
    return NSNotFound;
}

- (id)elementOfKind:(Class)elementClass atIndex:(NSUInteger)index
{
    NSUInteger _index = [self indexOfElementOfKind:elementClass atIndex:index];
    if (_index != NSNotFound) return [_operations objectAtIndex:_index];
    else return nil;
}

- (JSIntegrate *)integrateAtIndex:(NSUInteger)index
{
    return (JSIntegrate *)[self elementOfKind:[JSIntegrate class] atIndex:index];
}

- (JSFilter *)filterAtIndex:(NSUInteger)index
{
    return (JSFilter *)[self elementOfKind:[JSFilter class] atIndex:index];
}

- (JSBreakpoint *)breakpointAtIndex:(NSUInteger)index
{
    return (JSBreakpoint *)[self elementOfKind:[JSBreakpoint class] atIndex:index];
}

// see addObjectsFromPathComponents:toPathObjects: in JSVectors for comments on this method
- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    NSString *elementName = components[0];
    NSUInteger index = [elementName indexInString:&elementName];
    if (![elementName isEqualToString:@"filter"] && ![elementName isEqualToString:@"integrate"] && ![elementName isEqualToString:@"breakpoint"]) return NO;
    
    if (index == NSNotFound) index = 0;
    if ([elementName isEqualToString:@"filter"]) [pathObjects addObject:[self filterAtIndex:index]];
    if ([elementName isEqualToString:@"integrate"]) [pathObjects addObject:[self integrateAtIndex:index]];
    if ([elementName isEqualToString:@"breakpoint"]) [pathObjects addObject:[self breakpointAtIndex:index]];
    [components removeObjectAtIndex:0];
    return YES;
}

@end
