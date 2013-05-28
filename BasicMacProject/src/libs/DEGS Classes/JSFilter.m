//
//  JSFilter.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSFilter.h"
#import "JSXMDS.h"

@implementation JSFilter

@synthesize dependencies = _dependencies;
@synthesize evaluation = _evaluation;
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

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"filter"];

    if ( _name ) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    if (_dependencies) {
        NSXMLElement *dependeciesElement = [self.dependencies exportAsXML];
        [element addChild:dependeciesElement];
    }
    if (_evaluation) {
        NSXMLNode *filterText = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
        [filterText setStringValue:self.evaluation];
        [element addChild:filterText];
    }
    
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        if ([anElement attributeForName:@"name"]) self.name = [[anElement attributeForName:@"name"] stringValue];
        
        if ( [[anElement elementsForName:@"dependencies"] count] ) {
            self.dependencies = [[JSDependencies alloc] initFromXML:[anElement elementsForName:@"dependencies"][0]];
        }
        for (NSXMLNode *child in [anElement children]) {
            if ([child kind] == NSXMLTextKind) {
                self.evaluation = [[child.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
            }
        }
    }
    return self;
}

# pragma mark - Utility methods

- (NSString *)description
{
    NSString *title = @"Filter";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

@end
