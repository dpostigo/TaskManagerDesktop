//
//  JSOutput.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 16/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@class JSGroup;

@interface JSOutput : JSNode

@property (nonatomic) NSUInteger format;
@property (readonly, nonatomic, strong) NSArray *formatOptions;
@property (nonatomic, strong) NSString *filename;
@property (readonly) NSArray *groups;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@property (readonly) NSUInteger numberOfGroups;
- (void)addGroup:(JSGroup *)group;
- (void)addGroup:(JSGroup *)group atIndex:(NSUInteger)index;
- (void)deleteGroupAtIndex:(NSUInteger)index;
- (void)deleteGroupsAtIndexes:(NSIndexSet *)indexes;

- (NSArray *)listOfMomentsIdentifiers;

@end
