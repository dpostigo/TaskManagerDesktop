//
//  JSXMDS.m
//  DEGS Model
//
//  Created by Jacopo Sabbatini on 11/12/12.
//  Copyright (c) 2012 Jacopo Sabbatini. All rights reserved.
//

#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@interface JSXMDS() {
    NSMutableDictionary *_globalIdentifiers;
}

@end

@implementation JSXMDS

@synthesize preamble = _preamble;
@synthesize features = _features;
@synthesize driver = _driver;
@synthesize geometry = _geometry;
@synthesize vectors = _vectors;
@synthesize sequence = _sequence;
@synthesize output = _output;

# pragma mark - Setters and getters

// we override all the setters and getters for the sections so that we can set their parent property, keep the state of the tree valid and avoid loose branches
// also the getters for the section make use of lazy instantiation

-(JSPreamble *)preamble
{
    if (!_preamble) {
        _preamble = [[JSPreamble alloc] init];
        _preamble.parent = self;
    }
    return _preamble;
}

- (void)setPreamble:(JSPreamble *)preamble
{
    _preamble = preamble;
    _preamble.parent = self;
}

- (JSFeatures *)features
{
    if (!_features) {
        _features = [[JSFeatures alloc] init];
        _features.parent = self;
    }
    return _features;
}

- (void)setFeatures:(JSFeatures *)features
{
    _features = features;
    _features.parent = self;
}

- (JSDriver *)driver
{
    if (!_driver) {
        _driver = [[JSDriver alloc] init];
        _driver.parent = self;
    }
    return _driver;
}

- (void)setDriver:(JSDriver *)driver
{
    _driver = driver;
    _driver.parent = self;
}

- (JSGeometry *)geometry
{
    if (!_geometry) {
        _geometry = [[JSGeometry alloc] init];
        _geometry.parent = self;
    }
    return _geometry;
}

- (void)setGeometry:(JSGeometry *)geometry
{
    _geometry = geometry;
    _geometry.parent = self;
}

- (JSVectors *)vectors
{
    if (!_vectors) {
        _vectors = [[JSVectors alloc] init];
        _vectors.parent = self;
    }
    return _vectors;
}

- (void)setVectors:(JSVectors *)vectors
{
    _vectors = vectors;
    _vectors.parent = self;
}

- (JSSequence *)sequence
{
    if (!_sequence) {
        _sequence = [[JSSequence alloc] init];
        _sequence.parent = self;
    }
    return _sequence;
}

- (void)setSequence:(JSSequence *)sequence
{
    _sequence = sequence;
    _sequence.parent = self;
}

- (JSOutput *)output
{
    if (!_output) {
        _output = [[JSOutput alloc] init];
        _output.parent = self;
    }
    return _output;
}

- (void)setOutput:(JSOutput *)output
{
    _output = output;
    _output.parent = self;
}

- (NSDictionary *)globalIdentifiers
{
    return [_globalIdentifiers copy];
}

# pragma mark - Initialise and export

// every section class has its own exporter to an NSXMLElement so all we need to do is to check that the ivar for the sections are not nil, ask them to produce their own xml representation and add it to the root element of the xmds script
- (NSXMLDocument *)exportAsXMLDocument
{
    NSXMLElement *rootElement = [NSXMLElement elementWithName:@"simulation"];
    [rootElement addAttribute:[NSXMLNode attributeWithName:@"xmds-version" stringValue:@"2"]];
    
    // the preamble is the only section class that doesn't provide it's own exporter so we have to do it ourselves here
    // there was little advantage in letting the preamble have its own exporter
    if (_preamble) {
        if ( self.preamble.name ) [rootElement addChild:[NSXMLElement elementWithName:@"name" stringValue:self.preamble.name]];
        if ( self.preamble.author ) [rootElement addChild:[NSXMLElement elementWithName:@"author" stringValue:self.preamble.author]];
        if ( self.preamble.scriptDescription ) [rootElement addChild:[NSXMLElement elementWithName:@"description" stringValue:self.preamble.scriptDescription]];
    }
    
    if (_features) {
        NSXMLElement *featuresNode = [self.features exportAsXML];
        [rootElement addChild:featuresNode];
    }

    if (_driver) {
        NSXMLElement *driverNode = [self.driver exportAsXML];
        if (driverNode) [rootElement addChild:driverNode];
    }
    
    if (_geometry) {
        NSXMLElement *geometryNode = [self.geometry exportAsXML];
        [rootElement addChild:geometryNode];
    }
    
    if (_vectors) {
        // there is no warpper element for the vectors in the xmds specification
        // so vectors actually exports an array of NSXMLElements and we need to add each one of them to the root element
        for (NSXMLElement *element in [self.vectors exportAsXMLElements]) [rootElement addChild:element];
    }
    
    if (_sequence) {
        NSXMLElement *sequenceNode = [self.sequence exportAsXML];
        [rootElement addChild:sequenceNode];
    }

    if (_output) {
        NSXMLElement *outputElement = [self.output exportAsXML];
        [rootElement addChild:outputElement];
    }
    
    NSXMLDocument *theXMLDocument = [[NSXMLDocument alloc] initWithRootElement:rootElement];
    return theXMLDocument;
}

// again: every section class provides its own initialiser from a NSXMLElement so all we need to do is to grab the relevant element and initialise the section with it 
- (id)initFromXMLDocument:(NSXMLDocument *)aDocument
{
    if ( self = [super init] ) {
        NSXMLElement *rootElement = [aDocument rootElement];
        
        // the preamble section is the only one without its own initialiser so we have to do it ourselves here
        if ( [[rootElement elementsForName:@"name"] count] ) self.preamble.name = [[[rootElement elementsForName:@"name"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ( [[rootElement elementsForName:@"author"] count] ) self.preamble.author = [[[rootElement elementsForName:@"author"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ( [[rootElement elementsForName:@"description"] count] ) self.preamble.scriptDescription =[[[rootElement elementsForName:@"description"][0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // the elementsForName: method of NSXMLElement returns an empty array in the case it hasn't found any element with that name hence checking for the return to be not nil is not sufficient to guarantee the presence of the element
        if ( [[rootElement elementsForName:@"features"] count] ) {
            NSXMLElement *featuresNode = [rootElement elementsForName:@"features"][0];
            self.features = [[JSFeatures alloc] initFromXML:featuresNode];
        }
        
        if ( [[rootElement elementsForName:@"driver"] count] ) {
            NSXMLElement *driverNode = [rootElement elementsForName:@"driver"][0];
            self.driver = [[JSDriver alloc] initFromXML:driverNode];
        }
        
        if ( [[rootElement elementsForName:@"geometry"] count] ) {
            NSXMLElement *geometryNode = [rootElement elementsForName:@"geometry"][0];
            self.geometry = [[JSGeometry alloc] initFromXML:geometryNode];
        }
        
        // again: there is no wrapper element for the vectors in the xmds specification
        // we grab all the vectors elements from the script, put them in an array and pass it to the JSVectors class that will initialise a vector from each NSXMLElement in such array
        NSMutableArray *vectorsElements = [NSMutableArray array];
        for (NSXMLElement *noiseVector in [rootElement elementsForName:@"noise_vector"]) [vectorsElements addObject:noiseVector];
        for (NSXMLElement *vector in [rootElement elementsForName:@"vector"]) [vectorsElements addObject:vector];
        for (NSXMLElement *computedVector in [rootElement elementsForName:@"computed_vector"]) [vectorsElements addObject:computedVector];
        if ([vectorsElements count]) self.vectors = [[JSVectors alloc] initFromXMLElements:vectorsElements];
        
        if ([[rootElement elementsForName:@"sequence"] count]) {
            JSSequence *newSequence = [[JSSequence alloc] initFromXML:[rootElement elementsForName:@"sequence"][0]];
            self.sequence = newSequence;
        }
        
        if ([[rootElement elementsForName:@"output"] count]) {
            self.output = [[JSOutput alloc] initFromXML:[rootElement elementsForName:@"output"][0]];
        }
        
    }
    return self;
}

// high level methods that returns dictionary of identifier calling their low-level correspondent
- (NSDictionary *)dimensionIdentifiesDictionary
{
    return [self.geometry dictionaryOfDimensionIdentifiers];
}

- (NSDictionary *)vectorsIdentifiesDictionary
{
    return [self.vectors dictionaryOfVectorIdentifiers];
}

// high level methods that return the identifiers in the xmds script
// each one of the them call their respective low level implementation in the appropriate section
- (NSArray *)listOfDimensionsIdentifiersForBasis
{
    return [self.geometry listOfDimensionsIdentifiersForBasis];
}

- (NSArray *)listOfDimensionsIdentifiersForDimensions
{
    return [self.geometry listOfDimensionsIdentifiersForDimensions];
}

- (NSArray *)listOfVectorsIdentifiers
{
    return [self.vectors listOfVectorsIdentifiers];
}

- (NSArray *)listOfVectorComponentsIdentifiers
{
    return [self.vectors listOfVectorComponentsIdentifiers];
}

- (NSArray *)listOfArgumentsIdentifiers
{
    return [self.features listOfArgumentsIdentifiers];
}

- (NSArray *)listOfMomentsIdentifiers
{
    return [self.output listOfMomentsIdentifiers];
}

- (NSArray *)listOfDimensionsForSubstring:(NSString *)substring
{
    if (!substring) return [NSArray array];
    NSArray *dimensionIdentifiers = [self listOfDimensionsIdentifiersForDimensions];
    if ([substring length] == 0) return dimensionIdentifiers;
    NSMutableArray *matchingIdentifiers = [NSMutableArray array];
    for (NSString *dimensionIdentifier in dimensionIdentifiers) {
        if ([dimensionIdentifier hasPrefix:substring]) [matchingIdentifiers addObject:dimensionIdentifier];
    }
    return [matchingIdentifiers copy];
}

- (NSArray *)listOfBasisForSubstring:(NSString *)substring
{
    if (!substring) return [NSArray array];
    NSArray *dimensionIdentifiers = [self listOfDimensionsIdentifiersForBasis];
    if ([substring length] == 0) return dimensionIdentifiers;
    NSMutableArray *matchingIdentifiers = [NSMutableArray array];
    for (NSString *dimensionIdentifier in dimensionIdentifiers) {
        if ([dimensionIdentifier hasPrefix:substring]) [matchingIdentifiers addObject:dimensionIdentifier];
    }
    return [matchingIdentifiers copy];
}

- (NSArray *)listOfVectorsForSubstring:(NSString *)substring
{
    if (!substring) return [NSArray array];
    NSArray *vectorIdentifiers = [self listOfVectorsIdentifiers];
    if ([substring length] == 0) return [NSArray array];
    NSMutableArray *matchingIdentifiers = [NSMutableArray array];
    for (NSString *vectorIdentifier in vectorIdentifiers) {
        if ([vectorIdentifier hasPrefix:substring]) [matchingIdentifiers addObject:vectorIdentifier];
    }
    return [matchingIdentifiers copy];
}

- (NSArray *)listOfComponentsForSubstring:(NSString *)substring
{
    if (!substring) return [NSArray array];
    NSArray *vectorComponentsIdentifiers = [self listOfVectorComponentsIdentifiers];
    if ([substring length] == 0) return vectorComponentsIdentifiers;
    NSMutableArray *matchingIdentifiers = [NSMutableArray array];
    for (NSString *componentIdentifier in vectorComponentsIdentifiers) {
        if ([componentIdentifier hasPrefix:substring]) [matchingIdentifiers addObject:componentIdentifier];
    }
    return [matchingIdentifiers copy];
}

- (NSArray *)listOfArgumentsForSubstring:(NSString *)substring
{
    if (!substring) return [NSArray array];
    NSArray *argumentsIdentifiers = [self listOfArgumentsIdentifiers];
    if ([substring length] == 0) return argumentsIdentifiers;
    NSMutableArray *matchingIdentifiers = [NSMutableArray array];
    for (NSString *argumentIdentifier in argumentsIdentifiers) {
        if ([argumentIdentifier hasPrefix:substring]) [matchingIdentifiers addObject:argumentIdentifier];
    }
    return [matchingIdentifiers copy];
}

- (NSArray *)listOfMomentsForSubstring:(NSString *)substring
{
    if (!substring) return [NSArray array];
    NSArray *momentsIdentifiers = [self listOfMomentsIdentifiers];
    if ([substring length] == 0) return momentsIdentifiers;
    NSMutableArray *matchingIdentifiers = [NSMutableArray array];
    for (NSString *momentsIdentifier in momentsIdentifiers) {
        if ([momentsIdentifier hasPrefix:substring]) [matchingIdentifiers addObject:momentsIdentifier];
    }
    return [matchingIdentifiers copy];
}

- (NSNumber *)gridPointsForDimension:(NSString *)dimensionName
{
    return [self.geometry gridPointsForDimension:dimensionName];
}

# pragma mark - Path reconstruction methods

- (NSArray *)objectPathForString:(NSString *)XPath error:(NSError **)error
{
    NSMutableArray *pathObjects = [NSMutableArray arrayWithObject:self];
    NSMutableArray *components = [[XPath pathComponents] mutableCopy];
    while (components.count) {
        BOOL success = [[pathObjects lastObject] addObjectsFromPathComponents:components toPathObjects:pathObjects];
        if (!success) {
            *error = [NSError errorWithDomain:@"com.DEGS.compile" code:100 userInfo:@{ NSLocalizedDescriptionKey : @"Invalid XPath" }];
            return nil;
        }
    }
    return [pathObjects copy];
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    NSString *elementName = [components[0] stringByTrimmingIndex];
    if ([elementName isEqualToString:@"name"] || [elementName isEqualToString:@"author"] || [elementName isEqualToString:@"description"]) {
        [pathObjects addObject:self.preamble];
        return YES;
    }
    if ([elementName isEqualToString:@"vector"] || [elementName isEqualToString:@"noise_vector"] || [elementName isEqualToString:@"computed_vector"]) {
        [pathObjects addObject:self.vectors];
        return YES;
    }
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}

@end
