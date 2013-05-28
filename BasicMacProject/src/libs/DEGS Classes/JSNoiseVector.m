//
//  JSNoiseVector.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSNoiseVector.h"
#import "JSXMDS.h"

@implementation JSNoiseVector

@synthesize seed = _seed;
@synthesize method = _method;
@synthesize initialBasis = _initialBasis;
@synthesize kind = _kind;

# pragma mark - Setters and getters

- (NSArray *)methodOptions
{
    return @[@"posix", @"mkl", @"solirte", @"dsfmt"];
}

- (NSArray *)kindOptions
{
    return @[@"gauss", @"wiener", @"poissonian", @"jump", @"uniform"];
}

-(void)setMethod:(NSUInteger)method
{
    if (method <= ([self.methodOptions count]-1)) {
        _method = method;
    }
}

-(void)setKind:(NSUInteger)kind
{
    if (kind <= ([self.kindOptions count]-1)) {
        _kind = kind;
    }
}

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"noise_vector"];
    
    if (_name) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    NSString *typeString = (self.typeOptions)[self.type];
    [element addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:typeString]];
    
    NSString *kindString = (self.kindOptions)[self.kind];
    [element addAttribute:[NSXMLNode attributeWithName:@"kind" stringValue:kindString]];
    
    NSString *methodString = (self.methodOptions)[self.method];
    [element addAttribute:[NSXMLNode attributeWithName:@"method" stringValue:methodString]];
    
    if (_mean) {
        if (self.method == 2) [element addAttribute:[NSXMLNode attributeWithName:@"mean-density" stringValue:self.mean]];
        if (self.method == 3) [element addAttribute:[NSXMLNode attributeWithName:@"mean-rate" stringValue:self.mean]];
    }
    
    if (_dimensions) {
        NSString *dimensionsString = [self.dimensions componentsJoinedByString:@" "];
        [element addAttribute:[NSXMLNode attributeWithName:@"dimensions" stringValue:dimensionsString]];
    }
    
    if (_initialBasis) {
        NSString *initialBasisString = [self.initialBasis componentsJoinedByString:@" "];
        [element addAttribute:[NSXMLNode attributeWithName:@"initial_basis" stringValue:initialBasisString]];
    }
    
    if (_seed) [element addAttribute:[NSXMLNode attributeWithName:@"seed" stringValue:self.seed]];
    
    if (_components) {
        NSXMLElement *componentsElement = [NSXMLElement elementWithName:@"components"];
        [componentsElement setStringValue:[self.components componentsJoinedByString:@" "]];
        [element addChild:componentsElement];
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
        
        if ([anElement attributeForName:@"method"]) {
            NSString *methodString = [[anElement attributeForName:@"method"] stringValue];
            self.method = [self.methodOptions indexOfObject:methodString];
        }
        
        if ([anElement attributeForName:@"mean"]) {
            self.mean = [[anElement attributeForName:@"mean"] stringValue];
        }
        
        if ([anElement attributeForName:@"mean-density"]) {
            self.mean = [[anElement attributeForName:@"mean-density"] stringValue];
        }
        
        if ([anElement attributeForName:@"mean-rate"]) {
            self.mean = [[anElement attributeForName:@"mean-rate"] stringValue];
        }
        
        if ([anElement attributeForName:@"kind"]) {
            NSString *kindString = [[anElement attributeForName:@"kind"] stringValue];
            self.kind = [self.kindOptions indexOfObject:kindString];
        }
        
        if ([anElement attributeForName:@"seed"]) {
            self.seed = [[anElement attributeForName:@"seed"] stringValue];
        }
        
        if ([anElement attributeForName:@"dimensions"]) {
            self.dimensions = [[[anElement attributeForName:@"dimensions"] stringValue] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([anElement attributeForName:@"initial_basis"]) {
            self.initialBasis = [[[anElement attributeForName:@"initial_basis"] stringValue] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([[anElement elementsForName:@"components"] count]) {
            NSString *componentsString = [[[anElement elementsForName:@"components"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.components = [componentsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    return self;
}

# pragma mark - Utility methods

- (NSString *)description
{
    NSString *title = @"Noise Vector";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

@end
