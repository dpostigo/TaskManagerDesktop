//
//  JSDimension.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@interface JSDimension : JSNode

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger type;
@property (nonatomic, strong, readonly) NSArray *typeOptions;
@property (nonatomic, strong) NSString *lattice;
@property (nonatomic, strong) NSString *domainStart;
@property (nonatomic, strong) NSString *domainEnd;
@property (nonatomic, strong) NSArray *aliases;
@property (nonatomic) NSUInteger transform;
@property (nonatomic, readonly, strong) NSArray *transformOptions;
@property (nonatomic, strong) NSString *volumePrefactor;
@property (nonatomic, strong) NSNumber *spectralLattice;
@property (nonatomic, strong) NSString *lengthScale;
@property NSUInteger order;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

- (NSArray *)dimensionIdentifiersForBasis;
- (NSArray *)dimensionIdentifiersForDimension;

@end
