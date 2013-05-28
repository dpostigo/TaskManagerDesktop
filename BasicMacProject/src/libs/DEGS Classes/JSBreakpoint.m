//
//  JSBreakpoint.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSBreakpoint.h"
#import "JSDependencies.h"
#import "JSXMDS.h"

@implementation JSBreakpoint

@synthesize filename = _filename;
@synthesize dependencies = _dependencies;
@synthesize format = _format;
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

- (NSArray *)formatOptions
{
    return @[@"ascii", @"binary", @"hdf5"];
}

-(void)setFormat:(NSUInteger)format
{
    if (format <= ([self.formatOptions count]-1)) {
        _format = format;
    }
}

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"breakpoint"];
    
    if ( _name ) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    if (_filename) [element addAttribute:[NSXMLNode attributeWithName:@"filename" stringValue:self.filename]];
    
    NSString *formatString = (self.formatOptions)[self.format];
    [element addAttribute:[NSXMLNode attributeWithName:@"format" stringValue:formatString]];
    
    if (_dependencies) {
        NSXMLElement *dependeciesElement = [self.dependencies exportAsXML];
        [element addChild:dependeciesElement];
    }
    
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        
        if ([anElement attributeForName:@"name"]) self.name = [[anElement attributeForName:@"name"] stringValue];
        
        if ([anElement attributeForName:@"filename"]) self.filename = [[anElement attributeForName:@"filename"] stringValue];
        
        if ([anElement attributeForName:@"format"]) {
            NSString *formatString = [[anElement attributeForName:@"format"] stringValue];
            self.format = [self.formatOptions indexOfObject:formatString];
        }
        
        if ([[anElement elementsForName:@"dependencies"] count]) {
            NSXMLElement *dependeciesElement = [anElement elementsForName:@"dependencies"][0];
            self.dependencies = [[JSDependencies alloc] initFromXML:dependeciesElement];
        }
    }
    return self;
}

# pragma mark - Utility methods

- (NSString *)description
{
    NSString *title = @"Breakpoint";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

@end
