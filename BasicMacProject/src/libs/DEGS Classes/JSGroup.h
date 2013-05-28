//
//  JSGroup.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 16/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"
#import "JSVectors.h"
#import "JSOperatorStack.h"
#import "JSDependencies.h"

@interface JSGroup : JSNode

@property (nonatomic, strong) NSArray *samplingBasis;
@property BOOL initialSample;
@property (nonatomic, strong) JSDependencies *dependencies;
@property (nonatomic, strong) NSArray *moments;
@property (nonatomic, strong) NSString *definition;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) JSVectors *computedVectors;
@property (nonatomic, strong) JSOperatorStack *operators;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
