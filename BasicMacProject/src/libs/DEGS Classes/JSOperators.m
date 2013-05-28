//
//  JSOperators.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSOperators.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@implementation JSOperators

@synthesize operators = _operators;
@synthesize integrationVectors = _integrationVectors;
@synthesize dependencies = _dependencies;
@synthesize evaluation = _evaluation;
@synthesize dimensions = _dimensions;
@synthesize name = _name;

# pragma mark - Setters and getters

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

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"operators"];
    
    if (_name) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    if (_dimensions) [element addAttribute:[NSXMLNode attributeWithName:@"dimensions" stringValue:[self.dimensions componentsJoinedByString:@" "]]];
    
    if ( _operators && [_operators numberOfOperators]) {
        for (NSXMLElement *operatorElement in [self.operators exportAsXMLElements]) [element addChild:operatorElement];
    }
    
    if (_integrationVectors) {
        NSXMLElement *integrationVectors = [NSXMLElement elementWithName:@"integration_vectors" stringValue:[self.integrationVectors componentsJoinedByString:@" "]];
        [element addChild:integrationVectors];
    }
    
    if (_dependencies) [element addChild:[self.dependencies exportAsXML]];
    
    if (_evaluation) {
        NSXMLNode *evalutationText = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
        [evalutationText setStringValue:self.evaluation];
        [element addChild:evalutationText];
    }
    
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        
        if ([anElement attributeForName:@"name"]) {
            self.name = [[anElement attributeForName:@"name"] stringValue];
        }
        
        if ([anElement attributeForName:@"dimensions"]) {
            NSString *dimensionsString = [[anElement attributeForName:@"dimensions"] stringValue];
            self.dimensions = [dimensionsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        NSArray *operatorElements = [anElement elementsForName:@"operator"];
        if ([operatorElements count]) self.operators = [[JSOperatorStack alloc] initFromXMLElements:operatorElements];
        
        if ([[anElement elementsForName:@"integration_vectors"] count]) {
            NSString *integrationVectorsString = [[[anElement elementsForName:@"integration_vectors"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.integrationVectors = [integrationVectorsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([[anElement elementsForName:@"dependencies"] count]) {
            NSXMLElement *dependenciesElement = [anElement elementsForName:@"dependencies"][0];
            self.dependencies = [[JSDependencies alloc] initFromXML:dependenciesElement];
        }
        
        for (NSXMLNode *child in [anElement children]) {
            if ([child kind] == NSXMLTextKind) {
                self.evaluation = [child.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
        }
    }
    return self;
}

# pragma mark - Utility methods

- (NSString *)description
{
    NSString *title = @"Operators";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    // we want to skip the operators stack in the name pile as it is not a xmds element but merely our internal construction hence we don't want it to be part of the tree description
    if (![[self.parent parent] isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [[self.parent parent] description], title];
    return title;
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    NSString *elementName = components[0];
    
    // DEGS use a middle layer (the JSOperatorStack) to hold a stack of operator
    if ([elementName isEqualToString:@"operator"]) {
        [pathObjects addObject:self.operators];
        return YES;
    }
    
    if ([elementName isEqualToString:@"integration_vectors"]) elementName = @"integrationVectors";
    
    [components replaceObjectAtIndex:0 withObject:elementName];
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}


@end
