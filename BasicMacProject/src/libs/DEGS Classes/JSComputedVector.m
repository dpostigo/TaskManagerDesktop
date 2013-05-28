//
//  JSComputedVector.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSComputedVector.h"
#import "JSXMDS.h"

@implementation JSComputedVector

@synthesize dependencies = _dependencies;
@synthesize definition = _definition;

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

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"computed_vector"];
    
    if (_name) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    NSString *typeString = (self.typeOptions)[self.type];
    [element addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:typeString]];
    
    if (_dimensions) {
        NSString *dimensionsString = [self.dimensions componentsJoinedByString:@" "];
        [element addAttribute:[NSXMLNode attributeWithName:@"dimensions" stringValue:dimensionsString]];
    }
    
    if (_components) {
        NSXMLElement *componentsElement = [NSXMLElement elementWithName:@"components"];
        [componentsElement setStringValue:[self.components componentsJoinedByString:@" "]];
        [element addChild:componentsElement];
    }
    
    if (_definition) {
        NSXMLElement *evaluationElement = [NSXMLElement elementWithName:@"evaluation"];
        NSXMLNode *evaluationText = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
        [evaluationText setStringValue:self.definition];
        if (_dependencies) {
            NSXMLElement *dependeciesElement = [self.dependencies exportAsXML];
            [evaluationElement addChild:dependeciesElement];
        }
        [evaluationElement addChild:evaluationText];
        [element addChild:evaluationElement];
    }
    
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        if ([anElement attributeForName:@"name"]) self.name = [[anElement attributeForName:@"name"] stringValue];
        
        if ([anElement attributeForName:@"type"]) {
            NSString *typeString = [[anElement attributeForName:@"type"] stringValue];
            self.type = [self.typeOptions indexOfObject:typeString];
        }
        
        if ([anElement attributeForName:@"dimensions"]) {
            self.dimensions = [[[anElement attributeForName:@"dimensions"] stringValue] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([[anElement elementsForName:@"components"] count]) {
            NSString *componentsString = [[[anElement elementsForName:@"components"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.components = [componentsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([[anElement elementsForName:@"evaluation"] count]) {
            NSXMLElement *evaluationElement = [anElement elementsForName:@"evaluation"][0];
            if ([[evaluationElement elementsForName:@"dependencies"] count]) {
                NSXMLElement *dependeciesElement = [evaluationElement elementsForName:@"dependencies"][0];
                self.dependencies = [[JSDependencies alloc] initFromXML:dependeciesElement];
            }
            for (NSXMLNode *child in [evaluationElement children]) {
                if ([child kind] == NSXMLTextKind) {
                    self.definition = [child.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                }
            } 
        }
    }
    return self;
}

# pragma mark - Utility methods

- (NSString *)description
{
    NSString *title = @"Computed Vector";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}


@end
