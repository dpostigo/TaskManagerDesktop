//
//  JSFeatures.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 9/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSFeatures.h"
#import "JSArgument.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@interface JSFeatures() {
    NSMutableArray *_arguments;
}

@end

@implementation JSFeatures

# pragma mark - Setters and getters

- (NSArray *)fftwOptions
{
    return @[@"measure", @"patient", @"exhaustive", @"estimate"];
}

- (void)setFftw:(NSUInteger)fftw
{
    if (fftw <= ([self.fftwOptions count]-1)) {
        _fftw = fftw;
    }
}

- (NSArray *)precisionOptions
{
    return @[@"double", @"single"];
}

- (void)setPrecision:(NSUInteger)precision
{
    if (precision <= ([self.precisionOptions count]-1)) {
        _precision = precision;
    }
}

- (NSArray *)validationOptions
{
    return @[@"compile-time", @"none", @"run-time"];
}

- (void)setValidation:(NSUInteger)validation
{
    if (validation <= ([self.validationOptions count]-1)) {
        _validation = validation;
    }
}

- (NSArray *)arguments
{
    return [_arguments copy];
}

# pragma mark - Initialisers and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *featuresNode = [NSXMLElement elementWithName:@"features"];
    if (self.autoVectorise) [featuresNode addChild:[NSXMLElement elementWithName:@"auto_vectorise"]];
    if (self.benchmark) [featuresNode addChild:[NSXMLElement elementWithName:@"benchmark"]];
    if (self.bing) [featuresNode addChild:[NSXMLElement elementWithName:@"bing"]];
    if (self.diagnostics) [featuresNode addChild:[NSXMLElement elementWithName:@"diagnostics"]];
    if (self.errorCheck) [featuresNode addChild:[NSXMLElement elementWithName:@"error_check"]];
    if (self.openMP) [featuresNode addChild:[NSXMLElement elementWithName:@"openmp"]];
    if (self.haltNonFinite) [featuresNode addChild:[NSXMLElement elementWithName:@"halt_non_finite"]];
    
    NSXMLElement *fftwElement = [NSXMLElement elementWithName:@"fftw"];
    NSString *fftwPlan = (self.fftwOptions)[self.fftw];
    [fftwElement addAttribute:[NSXMLNode attributeWithName:@"plan" stringValue:fftwPlan]];
    if (_fftwThreads) [fftwElement addAttribute:[NSXMLNode attributeWithName:@"threads" stringValue:[@(_fftwThreads) stringValue]]];
    [featuresNode addChild:fftwElement];
    
    NSString *precision = (self.precisionOptions)[self.precision];
    NSXMLElement *precisionElement = [NSXMLElement elementWithName:@"precision" stringValue:precision];
    [featuresNode addChild:precisionElement];
    
    NSXMLElement *validationElement = [NSXMLElement elementWithName:@"validation"];
    NSString *validationKind = (self.validationOptions)[self.validation];
    [validationElement addAttribute:[NSXMLNode attributeWithName:@"kind" stringValue:validationKind]];
    [featuresNode addChild:validationElement];
    
    if ( _chunkedOutput ) {
        NSXMLElement *chunkedOutputElement = [NSXMLElement elementWithName:@"chunked_output"];
        [chunkedOutputElement addAttribute:[NSXMLNode attributeWithName:@"size" stringValue:self.chunkedOutput]];
        [featuresNode addChild:chunkedOutputElement];
    }
    
    if ( _cflags ) {
        NSXMLElement *cflagsElement = [NSXMLElement elementWithName:@"cflags"];
        NSXMLNode *cflagsText = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
        [cflagsText setStringValue:self.cflags];
        [cflagsElement addChild:cflagsText];
        [featuresNode addChild:cflagsText];
    }
    
    if ( _globals ) {
        NSXMLElement *globalsElement = [NSXMLElement elementWithName:@"globals"];
        NSXMLNode *globalsText = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
        [globalsText setStringValue:self.globals];
        [globalsElement addChild:globalsText];
        [featuresNode addChild:globalsElement];
    }
    
    if ( [_arguments count] || _argumentsGlobals ) {
        NSXMLElement *argumentsElement = [NSXMLElement elementWithName:@"arguments"];
        for (JSArgument *argument in _arguments) {
            [argumentsElement addChild:[argument exportAsXML]];
        }
        if ( _argumentsGlobals ) {
            NSXMLNode *argumentsGlobalsText = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
            [argumentsGlobalsText setStringValue:self.argumentsGlobals];
            [argumentsElement addChild:argumentsGlobalsText];
        }
        [featuresNode addChild:argumentsElement];
    }
    
    return featuresNode;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        if ( [[anElement elementsForName:@"benchmark"] count] ) self.benchmark = YES;
        if ( [[anElement elementsForName:@"bing"] count] ) self.bing = YES;
        if ( [[anElement elementsForName:@"auto_vectorise"] count] ) self.autoVectorise = YES;
        if ( [[anElement elementsForName:@"openmp"] count] ) self.openMP = YES;
        if ( [[anElement elementsForName:@"error_check"] count] ) self.errorCheck = YES;
        if ( [[anElement elementsForName:@"diagnostics"] count] ) self.diagnostics = YES;
        if ( [[anElement elementsForName:@"halt_non_finite"] count] ) self.haltNonFinite = YES;
        
        if ( [[anElement elementsForName:@"fftw"] count] ) {
            NSString *fftwPlan = [[[anElement elementsForName:@"fftw"][0] attributeForName:@"plan"] stringValue];
            self.fftw = [self.fftwOptions indexOfObject:fftwPlan];
            NSString *fftwThreads = [[[anElement elementsForName:@"fftw"][0] attributeForName:@"threads"] stringValue];
            self.fftwThreads = [fftwThreads integerValue];
        }
        
        if ( [[anElement elementsForName:@"validation"] count] ) {
            NSString *validationKind = [[[anElement elementsForName:@"validation"][0] attributeForName:@"kind"] stringValue];
            self.validation = [self.validationOptions indexOfObject:validationKind];
        }
        
        if ( [[anElement elementsForName:@"precision"] count] ) {
            NSString *precisionKind = [[anElement elementsForName:@"precision"][0] stringValue];
            self.precision = [self.precisionOptions indexOfObject:precisionKind];
        }
        
        if ( [[anElement elementsForName:@"chunked_output"] count] ) {
            NSString *chunksSize = [[[anElement elementsForName:@"chunked_output"][0] attributeForName:@"size"] stringValue];
            self.chunkedOutput = chunksSize;
        }
        
        if ( [[anElement elementsForName:@"cflags"] count] ) {
            self.cflags = [[[[anElement elementsForName:@"cflags"][0] childAtIndex:0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        
        if ( [[anElement elementsForName:@"arguments"] count] ) {
            NSXMLElement *argumentsNode = [anElement elementsForName:@"arguments"][0];
            NSUInteger childCount = [argumentsNode childCount];
            JSArgument *argument;
            for ( int i = 0; i < childCount; i++ ) {
                NSXMLNode *child = [argumentsNode childAtIndex:i];
                if ([child kind] == NSXMLElementKind) {
                    argument = [[JSArgument alloc] initFromXML:(NSXMLElement *)child];
                    [self addArgument:argument];
                } else if ( [child kind] == NSXMLTextKind ) {
                    self.argumentsGlobals = [child stringValue];
                }
            }
        }
        
        if ( [[anElement elementsForName:@"globals"] count] ) {
            self.globals = [[[[anElement elementsForName:@"globals"][0] childAtIndex:0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        
    }
    return self;
}

# pragma mark - Utility methods

- (void)prepareForNewArgument:(JSArgument *)argument
{
    argument.parent = self;
    if (!_arguments) _arguments = [NSMutableArray array];
}

// this bridge method guarantees that the tree is always in a valid state and that no loose leaves exist by setting the parent of argument to features every time an argument is added
- (void)addArgument:(JSArgument *)argument
{
    [self prepareForNewArgument:argument];
    [_arguments addObject:argument];
}

- (void)addArgument:(JSArgument *)argument atIndex:(NSUInteger)index
{
    [self prepareForNewArgument:argument];
    [_arguments insertObject:argument atIndex:index];
}

- (void)deleteArgumentAtIndex:(NSUInteger)index
{
    [_arguments removeObjectAtIndex:index];
}

- (void)deleteArgumentsAtIndexes:(NSIndexSet *)indexes
{
    [_arguments removeObjectsAtIndexes:indexes];
}

- (NSUInteger)numberOfArguments
{
    return [_arguments count];
}

- (NSArray *)listOfArgumentsIdentifiers
{
    NSArray *argumentsIdentifiers = [NSArray array];
    for (JSArgument *argument in self.arguments) {
        if (argument.name) argumentsIdentifiers = [argumentsIdentifiers arrayByAddingObject:argument.name];
    }
    return argumentsIdentifiers;
}

- (NSString *)description
{
    NSString *title = @"Features";
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    // features in DEGS skip the arguments element and directly holds the children nodes of arguments
    // we remove it from the components stack and move forward
    if ([[components objectAtIndex:0] isEqualToString:@"arguments"]) {
        [components removeObjectAtIndex:0];
        return YES;
    }
    
    // here we translate the name of element from the xmds specification to DEGS implementation
    NSString *elementName = components[0];
    NSUInteger index = [elementName indexInString:&elementName];
    
    // the dictionary provide a relation between the names of the elements in features in xmds and in DEGS
    // only the elements that have a different name are listed
    NSDictionary *mapping = @{ @"argument"       : @"arguments",
                               @"auto_vectorise" : @"autoVectorise",
                               @"chunked_output" : @"chunkedOutput",
                               @"error_check"    : @"errorCheck",
                               @"halt_non_finite": @"haltNonFinite",
                               @"openmp"         : @"openMP"};
    NSString *newName = [mapping objectForKey:elementName];
    
    // if newName is nil it means that the name of the element is the same
    if (!newName) newName = elementName;
    
    // recombine the index
    newName = [newName stringByAppendingIndex:index];
    
    // in the XPath specification if an element is unique it has no index in the path description. This means that the index returned by indexInString: was NSNotFound which is ignored by the stringByAppendingIndex: method. DEGS needs an index in order to be able to access the element in array properties and in this case NSNotFound means that the element is unique hence we assign an index 0 to it
    if ([newName isEqualToString:@"arguments"]) newName = @"arguments[0]";
    
    [components replaceObjectAtIndex:0 withObject:newName];
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}

@end
