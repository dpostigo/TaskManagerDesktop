//
//  JSVectors.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/11/12.
//
//

#import "JSVectors.h"
#import "JSGeneralVector.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@interface JSVectors () {
    NSMutableArray *_vectors;
}

// these methods provide a bridge between a notation of the form "vectorClass[index]" as used in the xmds specification and the notation "vectors[index]" used in DEGS
- (NSUInteger)indexOfVectorOfKind:(Class)vectorClass atIndex:(NSUInteger)index;
- (JSGeneralVector *)vectorOfKind:(Class)vectorClass atIndex:(NSUInteger)index;

@end

@implementation JSVectors

# pragma mark - Setters and getters

-(NSArray *)vectors
{
    return [_vectors copy];
}

- (NSUInteger)numberOfVectors
{
    return [self.vectors count];
}

# pragma mark - Initialiser and exporter

- (NSArray *)exportAsXMLElements
{
    NSMutableArray *elementsArray = [NSMutableArray array];
    for (id vector in _vectors) {
        NSXMLElement *newVectorNode = [vector exportAsXML];
        [elementsArray addObject:newVectorNode];
    }
    return elementsArray;
}

- (id)initFromXMLElements:(NSArray *)elements
{
    if (self = [super init]) {
        for (NSXMLElement *anElement in elements) {
            JSGeneralVector *newVector;
            if ([[anElement name] isEqualToString:@"vector"]) {
                newVector = [[JSVector alloc] initFromXML:anElement];
            } else if ([[anElement name] isEqualToString:@"noise_vector"]) {
                newVector = [[JSNoiseVector alloc] initFromXML:anElement];
            } else if ([[anElement name] isEqualToString:@"computed_vector"]) {
                newVector = [[JSComputedVector alloc] initFromXML:anElement];
            }
            if (newVector) [self addVector:newVector];
        }
    }
    return self;
}

# pragma mark - Utility methods

- (BOOL)prepareForNewVector:(JSGeneralVector *)vector
{
    if (_allowsComputedVectorsOnly && ![vector isKindOfClass:[JSComputedVector class]]) {
        NSLog(@"Error: trying to add a vector different from JSComputedVector to a JSVectors part of a sampling group");
        return NO;
    }
    vector.parent = self;
    if (!_vectors) _vectors = [NSMutableArray array];
    return YES;
}

- (void)addVector:(JSGeneralVector *)vector
{
    if ([self prepareForNewVector:vector]) [_vectors addObject:vector];
}

- (void)addVector:(JSGeneralVector *)vector atIndex:(NSUInteger)index
{
    if ([self prepareForNewVector:vector]) [_vectors insertObject:vector atIndex:index];
}

- (void)deleteVectorAtIndex:(NSUInteger)index
{
    [_vectors removeObjectAtIndex:index];
}

- (void)deleteVectorsAtIndexes:(NSIndexSet *)indexes
{
    [_vectors removeObjectsAtIndexes:indexes];
}

- (NSDictionary *)dictionaryOfVectorIdentifiers
{
    NSMutableDictionary *dict = [NSDictionary dictionary];
    for (JSGeneralVector *vector in self.vectors) {
        if (vector.name) [dict setObject:vector forKey:vector.name];
    }
    return [dict copy];
}

- (NSArray *)listOfVectorsIdentifiers
{
    NSArray *vectorsIdentifiers = [NSArray array];
    for (JSGeneralVector *vector in self.vectors) {
        if (vector.name) vectorsIdentifiers = [vectorsIdentifiers arrayByAddingObject:vector.name];
    }
    return vectorsIdentifiers;
}

- (NSArray *)listOfVectorComponentsIdentifiers
{
    NSArray *vectorComponentsIdentifiers = [NSArray array];
    for (JSGeneralVector *vector in self.vectors) {
        if (vector.components) {
            vectorComponentsIdentifiers = [vectorComponentsIdentifiers arrayByAddingObjectsFromArray:vector.components];
            if ([vector isKindOfClass:[JSVector class]] && self.root.geometry.propagationDimension.length) {
                for (NSString *component in vector.components) {
                    vectorComponentsIdentifiers = [vectorComponentsIdentifiers arrayByAddingObject:[NSString stringWithFormat:@"d%@_d%@", component, self.root.geometry.propagationDimension]];
                }
            }
        }
    }
    return vectorComponentsIdentifiers;
}

- (NSString *)description
{
    NSString *title;
    if (self.allowsComputedVectorsOnly) title = @"Computed Vectors";
    else title = @"Vectors";
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (NSUInteger)indexOfVectorOfKind:(Class)vectorClass atIndex:(NSUInteger)index
{
    // if the index of the asked vector is greater than the number of vectors we return right away and save the search
    if (index>self.numberOfVectors) return NSNotFound;
    
    NSInteger _index = -1;
    for (NSUInteger i = 0; i < [_vectors count]; i++) {
        if ([[_vectors objectAtIndex:i]  isKindOfClass:vectorClass]) _index++;
        if (_index == index) return i;
    }
    return NSNotFound;
}

- (JSGeneralVector *)vectorOfKind:(Class)vectorClass atIndex:(NSUInteger)index
{
    NSUInteger _index = [self indexOfVectorOfKind:vectorClass atIndex:index];
    if (_index != NSNotFound) return [_vectors objectAtIndex:_index];
    else return nil;
}

- (JSComputedVector *)computedVectorAtIndex:(NSUInteger)index
{
    return (JSComputedVector *)[self vectorOfKind:[JSComputedVector class] atIndex:index];
}

- (JSVector *)vectorAtIndex:(NSUInteger)index
{
    return (JSVector *)[self vectorOfKind:[JSVector class] atIndex:index];
}

- (JSNoiseVector *)noiseVectorAtIndex:(NSUInteger)index
{
    return (JSNoiseVector *)[self vectorOfKind:[JSNoiseVector class] atIndex:index];
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    NSString *elementName = components[0];
    NSUInteger index = [elementName indexInString:&elementName];
    
    // if the elementName is not one of the following three we don't hold nor handle it so exit and return NO as success
    if (![elementName isEqualToString:@"vector"] && ![elementName isEqualToString:@"noise_vector"] && ![elementName isEqualToString:@"computed_vector"]) return NO;
    
    // in the XPath specification if an element is unique it has no index in the path description. This means that the index returned by indexInString: was NSNotFound which is ignored by the stringByAppendingIndex: method. DEGS needs an index in order to be able to access the element in array properties and in this case NSNotFound means that the element is unique hence we assign an index 0 to it
    if (index == NSNotFound) index = 0;
    if ([elementName isEqualToString:@"vector"]) [pathObjects addObject:[self vectorAtIndex:index]];
    if ([elementName isEqualToString:@"noise_vector"]) [pathObjects addObject:[self noiseVectorAtIndex:index]];
    if ([elementName isEqualToString:@"computed_vector"]) [pathObjects addObject:[self computedVectorAtIndex:index]];
    [components removeObjectAtIndex:0];
    return YES;
}

@end
