//
//  JSVectors.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/11/12.
//
//

#import "JSNode.h"
#import "JSNoiseVector.h"
#import "JSVector.h"
#import "JSComputedVector.h"

@class JSGeneralVector;

@interface JSVectors : JSNode

// this class can be used in JSGroup or JSIntegrate to hold a list of the computed vectors
// if this property is true we only allow computed vectors to be added to the list of vectors
// also the description of the class changes if we are part of a sampling group
@property (nonatomic) BOOL allowsComputedVectorsOnly;

@property (readonly) NSArray *vectors;

@property (readonly) NSUInteger numberOfVectors;
- (void)addVector:(JSGeneralVector *)vector;
- (void)addVector:(JSGeneralVector *)vector atIndex:(NSUInteger)index;
- (void)deleteVectorAtIndex:(NSUInteger)index;
- (void)deleteVectorsAtIndexes:(NSIndexSet *)indexes;

- (NSArray *)exportAsXMLElements;
- (id)initFromXMLElements:(NSArray *)elements;

// compile a dictionary of all transverse dimension identifiers with their related dimension object
- (NSDictionary *)dictionaryOfVectorIdentifiers;

// compile lists of vector names and vector components
- (NSArray *)listOfVectorsIdentifiers;
- (NSArray *)listOfVectorComponentsIdentifiers;

// convenience methods to recover vectors from the notation "vectorClass[index]" used in the xmds specification
- (JSComputedVector *)computedVectorAtIndex:(NSUInteger)index;
- (JSVector *)vectorAtIndex:(NSUInteger)index;
- (JSNoiseVector *)noiseVectorAtIndex:(NSUInteger)index;

@end
