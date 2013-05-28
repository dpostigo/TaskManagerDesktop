//
//  JSGeometry.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@class JSDimension;

@interface JSGeometry : JSNode

@property (nonatomic, strong) NSString *propagationDimension;
@property (readonly) NSArray *transverseDimension;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@property (readonly) NSUInteger numberOfTransverseDimensions;
- (void)addTransverseDimension:(JSDimension *)dimension;
- (void)addTransverseDimension:(JSDimension *)dimension atIndex:(NSUInteger)index;
- (void)deleteTransverseDimensionAtIndex:(NSUInteger)index;
- (void)deleteTransverseDimensionsAtIndexes:(NSIndexSet *)indexes;

// compile a dictionary of all transverse dimension identifiers with their related dimension object
- (NSDictionary *)dictionaryOfDimensionIdentifiers;

// compile a list of identifiers for the transverse dimensions
- (NSArray *)listOfDimensionsIdentifiersForBasis;
- (NSArray *)listOfDimensionsIdentifiersForDimensions;

- (NSNumber *)gridPointsForDimension:(NSString *)dimensionName;

@end
