//
//  JSFilters.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@class JSFilter;

@interface JSFilters : JSNode

@property (nonatomic) NSUInteger where;
@property (readonly, nonatomic, strong) NSArray *whereOptions;
@property (readonly) NSArray *filters;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@property (readonly) NSUInteger numberOfFilters;

- (void)addFilter:(JSFilter *)filter;
- (void)addFilter:(JSFilter *)filter atIndex:(NSUInteger)index;
- (void)deleteFilterAtIndex:(NSUInteger)index;
- (void)deleteFiltersAtIndexes:(NSIndexSet *)indexes;

@end
