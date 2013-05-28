//
//  JSIntegrate.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSIntegrate.h"
#import "JSFilters.h"
#import "JSOperatorsStack.h"
#import "JSVectors.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"


@implementation JSIntegrate

//@synthesize algorithm = _algorithm;
//@synthesize interval = _interval;
//@synthesize steps = _steps;
//@synthesize tolerance = _tolerance;
//@synthesize samples = _samples;
//@synthesize name = _name;
@synthesize operators = _operators;
@synthesize filters = _filters;
@synthesize computedVectors = _computedVectors;

# pragma mark - Setters and getters

- (NSArray *)algorithmOptions
{
    return @[@"ARK45", @"RK4", @"RK9", @"ARK89", @"SI", @"SIC"];
}

-(void)setAlgorithm:(NSUInteger)algorithm
{
    if (algorithm <= ([self.algorithmOptions count]-1)) {
        _algorithm = algorithm;
    }
}

- (JSFilters *)filters
{
    if (!_filters) {
        _filters = [[JSFilters alloc] init];
        _filters.parent = self;
    }
    return _filters;
}

- (void)setFilters:(JSFilters *)filters
{
    _filters = filters;
    _filters.parent = self;
}

- (JSOperatorsStack *)operators
{
    if (!_operators) {
        _operators = [[JSOperatorsStack alloc] init];
        _operators.parent = self;
    }
    return _operators;
}

- (void)setOperators:(JSOperatorsStack *)operators
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
# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"integrate"];

    if ( _name ) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    NSString *algorithmString = (self.algorithmOptions)[self.algorithm];
    [element addAttribute:[NSXMLNode attributeWithName:@"algorithm" stringValue:algorithmString]];
    
    if (_interval) [element addAttribute:[NSXMLNode attributeWithName:@"interval" stringValue:self.interval]];
    
    if (_steps) [element addAttribute:[NSXMLNode attributeWithName:@"steps" stringValue:[self.steps stringValue]]];
    
    if (_tolerance && ([algorithmString isEqualToString:@"ARK45"] || [algorithmString isEqualToString:@"ARK89"])) [element addAttribute:[NSXMLNode attributeWithName:@"tolerance" stringValue:[self.tolerance stringValue]]];
    
    if (_samples) {
        NSString *samplesString = [self.samples componentsJoinedByString:@" "];
        [element addChild:[NSXMLElement elementWithName:@"samples" stringValue:samplesString]];
    }
    
    if ( _filters && [_filters numberOfFilters]) [element addChild:[self.filters exportAsXML]];
    
    if ( _operators && [_operators numberOfOperators]) {
        for (NSXMLElement *operatorsElement in [self.operators exportAsXMLElements]) [element addChild:operatorsElement];
    }
    
    if (_computedVectors && [_computedVectors numberOfVectors]) {
        for (NSXMLElement *computedVectorElement in [self.computedVectors exportAsXMLElements]) [element addChild:computedVectorElement];
    }
            
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        
        if ([anElement attributeForName:@"name"]) self.name = [[anElement attributeForName:@"name"] stringValue];
        
        if ([anElement attributeForName:@"algorithm"]) {
            NSString *algorithmString = [[anElement attributeForName:@"algorithm"] stringValue];
            self.algorithm = [self.algorithmOptions indexOfObject:algorithmString];
        }
        
        if ([anElement attributeForName:@"interval"]) self.interval = [[anElement attributeForName:@"interval"] stringValue];
        
        if ([anElement attributeForName:@"steps"]) self.steps = [NSNumber numberWithInt:[[[anElement attributeForName:@"steps"] stringValue] integerValue]];
        
        if ([anElement attributeForName:@"tolerance"]) self.tolerance = @([[[anElement attributeForName:@"tolerance"] stringValue] floatValue]);
        
        if ([[anElement elementsForName:@"samples"] count]) {
            NSString *samplesString = [[[anElement elementsForName:@"samples"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.samples = [samplesString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([[anElement elementsForName:@"filters"] count]) {
            self.filters = [[JSFilters alloc] initFromXML:[anElement elementsForName:@"filters"][0]];
        }
        
        NSMutableArray *operatorsElements = [[anElement elementsForName:@"operators"] mutableCopy];
        if ([operatorsElements count]) self.operators = [[JSOperatorsStack alloc] initFromXMLElements:operatorsElements];
        
        NSMutableArray *computedVectorElements = [[anElement elementsForName:@"computed_vector"] mutableCopy];
        if ([computedVectorElements count]) self.computedVectors = [[JSVectors alloc] initFromXMLElements:computedVectorElements];
    }
    return self;
    
}

# pragma mark - Utility methods

- (NSString *)description
{
    NSString *title = @"Integrate";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    // the only special case we need to handle here is an "operators" element. In that case we just need to append the JSOperatorsStack to the pathObjects stack
    NSString *elementName = [components[0] stringByTrimmingIndex];
    if ([elementName isEqualToString:@"operators"]) {
        [pathObjects addObject:self.operators];
        return YES;
    }
    
    // every other case can be resolved by the super implementation
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}


@end
