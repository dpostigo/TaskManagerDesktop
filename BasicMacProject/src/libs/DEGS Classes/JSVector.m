//
//  JSVector.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSVector.h"
#import "JSXMDS.h"

@implementation JSVector

@synthesize dependencies = _dependencies;

# pragma mark - Setters and getters

-(void)setInitialisation:(NSInteger)initialisation
{
    if (initialisation <= ([self.initialisationOptions count]-1)) {
        _initialisation = initialisation;
    }
}

- (NSArray *)initialisationOptions
{
    return @[@"zero", @"cdata", @"hdf5", @"xsil"];
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
    NSXMLElement *element = [NSXMLElement elementWithName:@"vector"];
    
    if (_name) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    NSString *typeString = (self.typeOptions)[self.type];
    [element addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:typeString]];
    
    if ([_dimensions count] > 0) {
        NSString *dimensionsString = [self.dimensions componentsJoinedByString:@" "];
        [element addAttribute:[NSXMLNode attributeWithName:@"dimensions" stringValue:dimensionsString]];
    }
    
    if ([_initialBasis count] > 0) {
        NSString *initialBasisString = [self.initialBasis componentsJoinedByString:@" "];
        [element addAttribute:[NSXMLNode attributeWithName:@"initial_basis" stringValue:initialBasisString]];
    }
    
    if ([_components count] > 0) {
        NSXMLElement *componentsElement = [NSXMLElement elementWithName:@"components"];
        [componentsElement setStringValue:[self.components componentsJoinedByString:@" "]];
        [element addChild:componentsElement];
    }
    
    NSString *initialisationString = (self.initialisationOptions)[self.initialisation];
    if (![initialisationString isEqualToString:@"zero"]) {
        NSXMLElement *initialisationElement = [NSXMLElement elementWithName:@"initialisation"];
        
        if ([initialisationString isEqualToString:@"cdata"]) {
            NSXMLNode *initialisationText = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
            if (_cdataString) [initialisationText setStringValue:self.cdataString];
            if (_dependencies) {
                NSXMLElement *dependeciesElement = [self.dependencies exportAsXML];
                [initialisationElement addChild:dependeciesElement];
            }
            [initialisationElement addChild:initialisationText];
        } else if ([initialisationString isEqualToString:@"xsil"] || [initialisationString isEqualToString:@"hdf5"]) {
            [initialisationElement addAttribute:[NSXMLNode attributeWithName:@"kind" stringValue:initialisationString]];
            if (_filename) [initialisationElement addChild:[NSXMLElement elementWithName:@"filename" stringValue:self.filename]];
        }
        [element addChild:initialisationElement];
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
        
        if ([anElement attributeForName:@"initial_basis"]) {
            self.initialBasis = [[[anElement attributeForName:@"initial_basis"] stringValue] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([[anElement elementsForName:@"components"] count]) {
            NSString *componentsString = [[[anElement elementsForName:@"components"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.components = [componentsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([[anElement elementsForName:@"initialisation"] count]) {
            NSXMLElement *initialisationElement = [anElement elementsForName:@"initialisation"][0];
            if ([initialisationElement attributeForName:@"kind"]) {
                NSString *kindString = [[initialisationElement attributeForName:@"kind"] stringValue];
                self.initialisation = [self.initialisationOptions indexOfObject:kindString];
                self.filename = [[initialisationElement elementsForName:@"filename"][0] stringValue];
            } else {
                self.initialisation = [self.initialisationOptions indexOfObject:@"cdata"];
                if ([[initialisationElement elementsForName:@"dependencies"] count]) {
                    NSXMLElement *dependeciesElement = [initialisationElement elementsForName:@"dependencies"][0];
                    self.dependencies = [[JSDependencies alloc] initFromXML:dependeciesElement];
                }
                for (NSXMLNode *child in [initialisationElement children]) {
                    if ([child kind] == NSXMLTextKind) {
                        self.cdataString = [child.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    }
                }
            }
        } else {
            self.initialisation = [self.initialisationOptions indexOfObject:@"zero"];
        }
    }
    return self;
}

# pragma mark - Utility methods

- (NSString *)description
{
    NSString *title = @"Vector";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

@end
