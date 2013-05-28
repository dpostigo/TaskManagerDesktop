//
//  JSGroup.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 16/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSGroup.h"
#import "JSOperator.h"
#import "JSComputedVector.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@implementation JSGroup

@synthesize samplingBasis = _samplingBasis;
@synthesize initialSample;
@synthesize definition = _definition;
@synthesize dependencies = _dependencies;
@synthesize moments = _moments;
@synthesize name = _name;
@synthesize operators = _operators;
@synthesize computedVectors = _computedVectors;

# pragma mark - Setters and getters

- (JSOperatorStack *)operators
{
    if (!_operators) {
        _operators = [[JSOperatorStack alloc] init];
        _operators.parent = self;
    }
    return _operators;
}

- (void)setOperators:(JSOperatorStack *)operators
{
    _operators = operators;
    _operators.parent = self;
}

- (JSVectors *)computedVectors
{
    if (!_computedVectors) {
        _computedVectors = [[JSVectors alloc] init];
        _computedVectors.allowsComputedVectorsOnly = YES;
        _computedVectors.parent = self;
    }
    return _computedVectors;
}

- (void)setComputedVectors:(JSVectors *)computedVectors
{
    _computedVectors = computedVectors;
    _computedVectors.parent = self;
    _computedVectors.allowsComputedVectorsOnly = YES;
}

- (JSDependencies *)dependencies
{
    if (!_dependencies) {
        _dependencies = [[JSDependencies alloc] init];
        _dependencies.parent = self;
    }
    return _dependencies;
}

- (void)setDependencies:(JSDependencies *)dependencies
{
    _dependencies = dependencies;
    _dependencies.parent = self;
}

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *samplingElement = [NSXMLElement elementWithName:@"sampling_group"];
    
    if (_name) [samplingElement addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    if (_samplingBasis) {
        [samplingElement addAttribute:[NSXMLNode attributeWithName:@"basis" stringValue:[self.samplingBasis componentsJoinedByString:@" "]]];
    }
    if (self.initialSample) {
        [samplingElement addAttribute:[NSXMLNode attributeWithName:@"initial_sample" stringValue:@"yes"]];
    } else {
        [samplingElement addAttribute:[NSXMLNode attributeWithName:@"initial_sample" stringValue:@"no"]];
    }
    
    if (_operators) {
        for (JSOperator *operator in self.operators.operators) {
            NSXMLElement *newOperatorNode = [operator exportAsXML];
            [samplingElement addChild:newOperatorNode];
        }
    }
    
    if (_computedVectors) {
        for (JSComputedVector *computedVector in self.computedVectors.vectors) {
            NSXMLElement *newComputedVectorNode = [computedVector exportAsXML];
            [samplingElement addChild:newComputedVectorNode];
        }
    }
    
    if (_moments) [samplingElement addChild:[NSXMLElement elementWithName:@"moments" stringValue:[self.moments componentsJoinedByString:@" "]]];
    if (_dependencies) [samplingElement addChild:[self.dependencies exportAsXML]];
    
    if (_definition) {
        NSXMLNode *definitionText = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
        [definitionText setStringValue:self.definition];
        [samplingElement addChild:definitionText];
    }
    return samplingElement;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        
        if ([anElement attributeForName:@"name"]) self.name = [[anElement attributeForName:@"name"] stringValue];
        
        if ([anElement attributeForName:@"basis"]) self.samplingBasis = [[[anElement attributeForName:@"basis"] stringValue] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        self.initialSample = NO;
        if ([anElement attributeForName:@"initial_sample"]) {
            if ([[[anElement attributeForName:@"initial_sample"] stringValue] isEqualToString:@"yes"]) {
                self.initialSample = YES;
            }
        }
        
        if ([[anElement elementsForName:@"operator"] count]) {
            self.operators = [[JSOperatorStack alloc] initFromXMLElements:[anElement elementsForName:@"operator"]];
        }
        
        if ([[anElement elementsForName:@"computed_vector"] count]) {
            self.computedVectors = [[JSVectors alloc] initFromXMLElements:[anElement elementsForName:@"computed_vector"]];
        }
        
        if ([[anElement elementsForName:@"moments"] count]) {
            NSString *momentsString = [[[anElement elementsForName:@"moments"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.moments = [momentsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        if ([[anElement elementsForName:@"dependencies"] count]) self.dependencies = [[JSDependencies alloc] initFromXML:[anElement elementsForName:@"dependencies"][0]];
        for (NSXMLNode *child in [anElement children]) {
            if ([child kind] == NSXMLTextKind) {
                self.definition = [child.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
        }
    }
    return self;
}

# pragma mark - Utility methods

- (NSString *)description
{
    NSString *title = @"Group";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    NSString *elementName = components[0];
    
    // add the middle layers for computed_vector and operator used in DEGS to the pathObjects stack
    if ([elementName isEqualToString:@"computed_vector"]) {
        [pathObjects addObject:self.computedVectors];
        return YES;
    }
    
    if ([elementName isEqualToString:@"operator"]) {
        [pathObjects addObject:self.operators];
        return YES;
    }
    
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}


@end
