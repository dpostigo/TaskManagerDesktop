//
//  JSDEOperator.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSOperator.h"
#import "JSXMDS.h"

@implementation JSOperator

@synthesize kind = _kind;
@synthesize type = _type;
@synthesize constant = _constant;
@synthesize names = _names;
@synthesize definition = _definition;

# pragma mark - Setters and getters

- (NSArray *)kindOptions
{
    return @[@"ip", @"ex", @"functions"];
}

-(void)setKind:(NSUInteger)kind
{
    if (kind <= ([self.kindOptions count]-1)) {
        _kind = kind;
    }
}

- (NSArray *)typeOptions
{
    return @[@"complex", @"real", @"imaginary"];
}

-(void)setType:(NSUInteger)type
{
    if (type <= ([self.typeOptions count]-1)) {
        _type = type;
    }
}

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"operator"];
    
    if (_name) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    [element addAttribute:[NSXMLNode attributeWithName:@"kind" stringValue:(self.kindOptions)[self.kind]]];
    NSString *kindString = (self.kindOptions)[self.kind];
    if (![kindString isEqualToString:@"functions"]) {
        [element addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:(self.typeOptions)[self.type]]];
        if (self.constant) {
            [element addAttribute:[NSXMLNode attributeWithName:@"constant" stringValue:@"yes"]];
        } else {
            [element addAttribute:[NSXMLNode attributeWithName:@"constant" stringValue:@"no"]];
        }
        
        if (_names) {
            NSXMLElement *namesElement = [NSXMLElement elementWithName:@"operator_names"];
            [namesElement setStringValue:[self.names componentsJoinedByString:@" "]];
            [element addChild:namesElement];
        }
    }
    
    if (_definition) {
        NSXMLNode *definitionText = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
        [definitionText setStringValue:self.definition];
        [element addChild:definitionText];
    }
    
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        
        if ([anElement attributeForName:@"name"]) self.name = [[anElement attributeForName:@"name"] stringValue];
        
        if ([anElement attributeForName:@"kind"]) {
            NSString *kindString = [[anElement attributeForName:@"kind"] stringValue];
            self.kind = [self.kindOptions indexOfObject:kindString];
        }
        
        if ([anElement attributeForName:@"type"]) {
            NSString *typeString = [[anElement attributeForName:@"type"] stringValue];
            self.type = [self.typeOptions indexOfObject:typeString];
        }
        
        if ([anElement attributeForName:@"constant"]) {
            NSString *constantString = [[anElement attributeForName:@"constant"] stringValue];
            if ([constantString isEqualToString:@"yes"]) {
                self.constant = TRUE;
            } else {
                self.constant = FALSE;
            }
        }
        
        if ([[anElement elementsForName:@"operator_names"] count]) {
            NSString *namesElementString = [[[anElement elementsForName:@"operator_names"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.names = [namesElementString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
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
    NSString *title = @"Operator";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    // we want to skip the operator stack in the name pile as it is not a xmds element but merely our internal construction hence we don't want it to be part of the tree description
    if (![[self.parent parent] isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [[self.parent parent] description], title];
    return title;
}

@end
