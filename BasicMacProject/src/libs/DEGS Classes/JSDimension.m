//
//  JSDimension.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSDimension.h"
#import "JSXMDS.h"

@implementation JSDimension

@synthesize name = _name;
@synthesize domainStart = _domainStart;
@synthesize domainEnd = _domainEnd;
@synthesize type = _type;
@synthesize lattice = _lattice;
@synthesize aliases = _aliases;
@synthesize transform = _transform;
@synthesize volumePrefactor = _volumePrefactor;

# pragma mark - Setters and getters

- (NSArray *)typeOptions
{
    return @[@"real", @"integer"];
}

-(void)setType:(NSUInteger)type
{
    if (type <= ([self.typeOptions count]-1)) {
        _type = type;
    }
}

- (NSArray *)transformOptions
{
    return @[@"dft", @"dst", @"dct", @"bessel", @"spherical-bessel", @"hermite-gauss", @"none"];
}

-(void)setTransform:(NSUInteger)transform
{
    if (transform <= ([self.transformOptions count]-1)) {
        _transform = transform;
    }
}

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"dimension"];
    if ( _name ) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];

    NSString *typeString = (self.typeOptions)[self.type];
    [element addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:typeString]];
    
    if ( _lattice ) [element addAttribute:[NSXMLNode attributeWithName:@"lattice" stringValue:self.lattice]];
    
    NSString *transformString = (self.transformOptions)[self.transform];
    [element addAttribute:[NSXMLNode attributeWithName:@"transform" stringValue:transformString]];
    
    // is the dimension transform bessel?
    NSRange besselRange = [transformString rangeOfString:@"bessel"];
    if (besselRange.location != NSNotFound) [element addAttribute:[NSXMLNode attributeWithName:@"order" stringValue:[@(_order) stringValue]]];
        
    if ( _domainStart && _domainEnd) {
        NSString *domainString = @"(";
        domainString = [domainString stringByAppendingString:self.domainStart];
        domainString = [domainString stringByAppendingString:@","];
        domainString = [domainString stringByAppendingString:self.domainEnd];
        domainString = [domainString stringByAppendingString:@")"];
        [element addAttribute:[NSXMLNode attributeWithName:@"domain" stringValue:domainString]];
    }
    
    if (_aliases) [element addAttribute:[NSXMLNode attributeWithName:@"aliases" stringValue:[self.aliases componentsJoinedByString:@" "]]];
    
    if ( _volumePrefactor ) [element addAttribute:[NSXMLNode attributeWithName:@"volume_prefactor" stringValue:self.volumePrefactor]];
    if ( _spectralLattice ) [element addAttribute:[NSXMLNode attributeWithName:@"spectral_lattice" stringValue:[self.spectralLattice stringValue]]];
    if ( _lengthScale) [element addAttribute:[NSXMLNode attributeWithName:@"length_scale" stringValue:self.lengthScale]];
    
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        if ([anElement attributeForName:@"name"]) self.name = [[anElement attributeForName:@"name"] stringValue];
        
        if ( [anElement attributeForName:@"type"] ) {
            NSString *typeString = [[anElement attributeForName:@"type"] stringValue];
            self.type = [self.typeOptions indexOfObject:typeString];
        }
        
        if ([anElement attributeForName:@"lattice"]) self.lattice = [[anElement attributeForName:@"lattice"] stringValue];
        
        if ([anElement attributeForName:@"domain"]) [self processDomainString:[[anElement attributeForName:@"domain"] stringValue]];
        
        if ( [anElement attributeForName:@"transform"] ) {
            NSString *transformString = [[anElement attributeForName:@"transform"] stringValue];
            self.transform = [self.transformOptions indexOfObject:transformString];
        }
        
        if ( [anElement attributeForName:@"order"] ) self.order = [[[anElement attributeForName:@"order"] stringValue] integerValue];
         
        if ( [anElement attributeForName:@"aliases"] ) {
            self.aliases = [[[anElement attributeForName:@"aliases"] stringValue] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ( [anElement attributeForName:@"volume_prefactor"] ) {
            self.volumePrefactor = [[anElement attributeForName:@"volume_prefactor"] stringValue];
        }
        
        if ( [anElement attributeForName:@"length_scale"] ) {
            self.lengthScale = [[anElement attributeForName:@"length_scale"] stringValue];
        }
        
        if ( [anElement attributeForName:@"spectral_lattice"] ) {
            self.spectralLattice = @([[[anElement attributeForName:@"spectral_lattice"] stringValue] floatValue]);
        }
    }
    return self;
}

# pragma mark - Utility methods

-(void)processDomainString:(NSString *)domainString
{
    domainString = [domainString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    domainString = [domainString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
    NSArray *domainLimits = [domainString componentsSeparatedByString:@","];
    self.domainStart = [domainLimits[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.domainEnd = [domainLimits[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSArray *)dimensionIdentifiersForBasis
{
    if ( _name ) {
        NSMutableArray *dimensionNames = [NSMutableArray arrayWithObject:self.name];
        if ([(self.transformOptions)[self.transform] isEqualToString:@"hermite-gauss"]) {
            [dimensionNames addObject:[@"n" stringByAppendingString:self.name]];
            [dimensionNames addObject:[self.name stringByAppendingString:@"_4f"]];
        }
        [dimensionNames addObject:[@"k" stringByAppendingString:self.name]];
        return [dimensionNames copy];
    }
    return nil;
}

// at the moment this return the same thing of a basis call but we may need different things here.
- (NSArray *)dimensionIdentifiersForDimension
{
    return [self dimensionIdentifiersForBasis];
}

- (NSString *)description
{
    NSString *title = @"Dimension";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

@end
