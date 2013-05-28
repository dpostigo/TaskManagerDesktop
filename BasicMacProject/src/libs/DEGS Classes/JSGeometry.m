//
//  JSGeometry.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSGeometry.h"
#import "JSDimension.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@interface JSGeometry () {
    NSMutableArray *_transverseDimension;
}

@end

@implementation JSGeometry

# pragma mark - Setters and getters

- (NSArray *)transverseDimension
{
    return [_transverseDimension copy];
}

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"geometry"];
    
    if ( _propagationDimension ) [element addChild:[NSXMLElement elementWithName:@"propagation_dimension" stringValue:self.propagationDimension]];
    
    if ( [_transverseDimension count] ) {
        NSXMLElement *tranDimElement = [NSXMLElement elementWithName:@"transverse_dimensions"];
        for (JSDimension *dim in _transverseDimension) {
            [tranDimElement addChild:[dim exportAsXML]];
        }
        [element addChild:tranDimElement];
    }
    
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        if ([[anElement elementsForName:@"propagation_dimension"] count] > 0) {
            self.propagationDimension = [[[anElement elementsForName:@"propagation_dimension"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        
        if ( [[anElement elementsForName:@"transverse_dimensions"] count] > 0 ) {
            NSInteger childCount = [[anElement elementsForName:@"transverse_dimensions"][0] childCount];
            JSDimension *dimension;
            for ( int i = 0; i < childCount; i++ ) {
                NSXMLNode *child = [[anElement elementsForName:@"transverse_dimensions"][0] childAtIndex:i];
                if ([child kind] == NSXMLElementKind) {
                    dimension = [[JSDimension alloc] initFromXML:(NSXMLElement *)[[anElement elementsForName:@"transverse_dimensions"][0] childAtIndex:i]];
                    [self addTransverseDimension:dimension];
                }
            }
        }
    }
    return self;
}

# pragma mark - Utility methods

- (void)prepareForNewDimension:(JSDimension *)dimension
{
    dimension.parent = self;
    if (!_transverseDimension) _transverseDimension = [NSMutableArray array];
}

- (void)addTransverseDimension:(JSDimension *)dimension
{
    [self prepareForNewDimension:dimension];
    [_transverseDimension addObject:dimension];
}

- (void)addTransverseDimension:(JSDimension *)dimension atIndex:(NSUInteger)index
{
    [self prepareForNewDimension:dimension];
    [_transverseDimension insertObject:dimension atIndex:index];
}

- (void)deleteTransverseDimensionAtIndex:(NSUInteger)index
{
    [_transverseDimension removeObjectAtIndex:index];
}

- (void)deleteTransverseDimensionsAtIndexes:(NSIndexSet *)indexes
{
    [_transverseDimension removeObjectsAtIndexes:indexes];
}

- (NSUInteger)numberOfTransverseDimensions
{
    return [self.transverseDimension count];
}

- (NSDictionary *)dictionaryOfDimensionIdentifiers
{
    NSMutableDictionary *dict = [NSDictionary dictionary];
    for (JSDimension *dimension in self.transverseDimension) {
        for (NSString *dimensionIdentifier in [dimension dimensionIdentifiersForBasis]) [dict setObject:dimension forKey:dimensionIdentifier];
    }
    return [dict copy];
}

- (NSArray *)listOfDimensionsIdentifiersForBasis
{
    NSArray *dimensionsIdentifiers = [NSArray array];
    for (JSDimension *dimension in self.transverseDimension) {
        dimensionsIdentifiers = [dimensionsIdentifiers arrayByAddingObjectsFromArray:[dimension dimensionIdentifiersForBasis]];
    }
    return dimensionsIdentifiers;
}

- (NSArray *)listOfDimensionsIdentifiersForDimensions
{
    NSArray *dimensionsIdentifiers = [NSArray array];
    for (JSDimension *dimension in self.transverseDimension) {
        dimensionsIdentifiers = [dimensionsIdentifiers arrayByAddingObjectsFromArray:[dimension dimensionIdentifiersForDimension]];
    }
    return dimensionsIdentifiers;
}

- (NSNumber *)gridPointsForDimension:(NSString *)dimensionName
{
    for (JSDimension *dimension in self.transverseDimension) {
        if ([[dimension dimensionIdentifiersForBasis] indexOfObject:dimensionName] != NSNotFound) {
            return @([dimension.lattice integerValue]);
        }
    }
    return nil;
}

- (NSString *)description
{
    NSString *title = @"Geometry";
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    // geometry in DEGS skip the transverse_dimensions element and directly holds the children nodes of transverse_dimensions
    // we remove it from the components stack and move forward
    if ([[components objectAtIndex:0] isEqualToString:@"transverse_dimensions"]) {
        [components removeObjectAtIndex:0];
        return YES;
    }
    
    // here we translate the name of element from the xmds specification to DEGS implementation
    // for a description of the logic see the addObjectsFromPathComponents:toPathObjects: method in JSFeatures
    NSString *elementName = components[0];
    NSUInteger index = [elementName indexInString:&elementName];
    NSDictionary *mapping = @{ @"propagation_dimension" : @"propagationDimension",
                               @"dimension"             : @"transverseDimension"};
    NSString *newName = [mapping objectForKey:elementName];
    if (!newName) newName = elementName;
    newName = [newName stringByAppendingIndex:index];
    if ([newName isEqualToString:@"transverseDimension"]) newName = @"transverseDimension[0]";
    [components replaceObjectAtIndex:0 withObject:[newName stringByAppendingIndex:index]];
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}

@end
