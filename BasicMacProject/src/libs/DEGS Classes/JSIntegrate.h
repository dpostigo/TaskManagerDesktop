//
//  JSIntegrate.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@class JSFilters, JSOperatorsStack, JSVectors;

@interface JSIntegrate : JSNode

@property (nonatomic) NSUInteger algorithm;
@property (readonly, nonatomic, strong) NSArray *algorithmOptions;
@property (nonatomic, strong) NSString *interval;
@property (nonatomic, strong) NSNumber *steps;
@property (nonatomic, strong) NSNumber *tolerance;
@property (nonatomic, strong) NSArray *samples;
@property (nonatomic, strong) JSFilters *filters;
@property (nonatomic, strong) JSOperatorsStack *operators;
@property (nonatomic, strong) JSVectors *computedVectors;
@property (nonatomic, strong) NSString *name;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
