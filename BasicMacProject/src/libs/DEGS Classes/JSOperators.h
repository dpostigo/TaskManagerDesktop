//
//  JSOperators.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"
#import "JSDependencies.h"
#import "JSOperatorStack.h"

// The structure of an Operators element is as follow:
//   Operator               this can be of three kind
//                          1) function (implemented in JSFunctionOperator)
//                          2) differential operator (implemented in JSDEOperator)
//                          3) cross-propagation (currently not implemented)
//   name                   the name of the element
//   integrationVectors     the vectors over which to carry the integration
//   evaluation             this string contains the actual differential equation to be integrated
//   dimensions             the transverse dimensions used in the integration
//   dependencies           eventual depencies needed to evaluate the differential equation

@interface JSOperators : JSNode

@property (nonatomic, strong) JSOperatorStack *operators;
@property (nonatomic, strong) NSArray *integrationVectors;
@property (nonatomic, strong) JSDependencies *dependencies;
@property (nonatomic, strong) NSString *evaluation;
@property (nonatomic, strong) NSArray *dimensions;
@property (nonatomic, strong) NSString *name;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
