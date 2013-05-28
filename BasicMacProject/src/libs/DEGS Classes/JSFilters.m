//
//  JSFilters.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSFilters.h"
#import "JSFilter.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@interface JSFilters () {
    NSMutableArray *_filters;
}

@end

@implementation JSFilters

@synthesize where = _where;

# pragma mark - Setters and getters

- (NSArray *)whereOptions
{
    return @[@"step start", @"step end"];
}

-(void)setWhere:(NSUInteger)where
{
    if (where <= ([self.whereOptions count]-1)) {
        _where = where;
    }
}

-(NSArray *)filters
{
    return [_filters copy];
}

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"filters"];
    [element addAttribute:[NSXMLNode attributeWithName:@"where" stringValue:(self.whereOptions)[self.where]]];
    
    for (JSFilter *filter in _filters) {
        [element addChild:[filter exportAsXML]];
    }
    
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        if ([anElement attributeForName:@"where"]) {
            NSString *whereString = [[anElement attributeForName:@"where"] stringValue];
            self.where = [self.whereOptions indexOfObject:whereString];
        }
        for (NSXMLElement *filterElement in [anElement elementsForName:@"filter"]) {
            JSFilter *newFilter = [[JSFilter alloc] initFromXML:filterElement];
            [self addFilter:newFilter];
        }
    }
    return self;
}

# pragma mark - Utility methods

- (void)prepareForNewFilter:(JSFilter *)filter
{
    filter.parent = self;
    if (!_filters) _filters = [NSMutableArray array];
}

- (void)addFilter:(JSFilter *)filter
{
    [self prepareForNewFilter:filter];
    [_filters addObject:filter];
}

- (void)addFilter:(JSFilter *)filter atIndex:(NSUInteger)index;
{
    [self prepareForNewFilter:filter];
    [_filters insertObject:filter atIndex:index];
}

- (void)deleteFilterAtIndex:(NSUInteger)index
{
    [_filters removeObjectAtIndex:index];
}

- (void)deleteFiltersAtIndexes:(NSIndexSet *)indexes
{
    [_filters removeObjectsAtIndexes:indexes];
}

- (NSUInteger)numberOfFilters
{
    return [self.filters count];
}

- (NSString *)description
{
    NSString *title = @"Filters";
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    NSString *elementName = components[0];
    NSUInteger index = [elementName indexInString:&elementName];
    
    // Filters in DEGS maps its filter elements into a filters array
    if ([elementName isEqualToString:@"filter"]) {
        elementName = @"filters";
        
        // in the XPath specification if an element is unique it has no index in the path description. This means that the index returned by indexInString: was NSNotFound which is ignored by the stringByAppendingIndex: method. DEGS needs an index in order to be able to access the element in array properties and in this case NSNotFound means that the element is unique hence we assign an index 0 to it
        if (index == NSNotFound) index = 0;
    }
    
    [components replaceObjectAtIndex:0 withObject:[elementName stringByAppendingIndex:index]];
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}

@end
