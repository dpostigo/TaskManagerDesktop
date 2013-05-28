//
//  JSOutput.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 16/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSOutput.h"
#import "JSGroup.h"
#import "JSXMDS.h"
#import "NSString+JSAdditions.h"

@interface JSOutput () {
    NSMutableArray *_groups;
}

@end

@implementation JSOutput

@synthesize format = _format;
@synthesize filename = _filename;

# pragma mark - Setters and getters

-(NSArray *)groups
{
    return [_groups copy];
}

- (NSArray *)formatOptions
{
    return @[@"hdf5", @"binary", @"ascii"];
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
    NSXMLElement *element = [NSXMLElement elementWithName:@"output"];
    [element addAttribute:[NSXMLNode attributeWithName:@"format" stringValue:(self.formatOptions)[self.format]]];
    if (_filename) [element addAttribute:[NSXMLNode attributeWithName:@"filename" stringValue:self.filename]];
    
    for (JSGroup *group in _groups) {
        [element addChild:[group exportAsXML]];
    }
    
    return element;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        
        if ([anElement attributeForName:@"format"]) {
            NSString *formatString = [[anElement attributeForName:@"format"] stringValue];
            self.format = [self.formatOptions indexOfObject:formatString];
        }
        
        if ([anElement attributeForName:@"filename"]) self.filename = [[anElement attributeForName:@"filename"] stringValue];
        
        for (NSXMLElement *group in [anElement elementsForName:@"sampling_group"]) {
            JSGroup *newGroup = [[JSGroup alloc] initFromXML:group];
            [self addGroup:newGroup];
        }
        
        // xmds also support a legacy definition of sampling group
        // it defines group tags and inside group tags it defines the sampling elements
        for (NSXMLElement *group in [anElement elementsForName:@"group"]) {
            if ([group elementsForName:@"sampling"].count) {
                JSGroup *newGroup = [[JSGroup alloc] initFromXML:[group elementsForName:@"sampling"][0]];
                [self addGroup:newGroup];
            }
        }
    }
    return self;
}

# pragma mark - Utility methods

- (NSUInteger)numberOfGroups
{
    return [_groups count];
}

- (void)prepareForNewGroup:(JSGroup *)group
{
    group.parent = self;
    if (!_groups) _groups = [NSMutableArray array];
}

- (void)addGroup:(JSGroup *)group
{
    [self prepareForNewGroup:group];
    [_groups addObject:group];
}

- (void)addGroup:(JSGroup *)group atIndex:(NSUInteger)index
{
    [self prepareForNewGroup:group];
    [_groups insertObject:group atIndex:index];
}

- (void)deleteGroupAtIndex:(NSUInteger)index
{
    [_groups removeObjectAtIndex:index];
}

- (void)deleteGroupsAtIndexes:(NSIndexSet *)indexes
{
    [_groups removeObjectsAtIndexes:indexes];
}

- (NSArray *)listOfMomentsIdentifiers
{
    NSArray *momentsIdentifiers = [NSArray array];
    for (JSGroup *group in self.groups) {
        momentsIdentifiers = [momentsIdentifiers arrayByAddingObjectsFromArray:group.moments];
    }
    return momentsIdentifiers;
}

- (NSString *)description
{
    NSString *title = @"Output";
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

- (BOOL)addObjectsFromPathComponents:(NSMutableArray *)components toPathObjects:(NSMutableArray *)pathObjects
{
    NSString *elementName = components[0];
    NSUInteger index = [elementName indexInString:&elementName];
    
    if ([elementName isEqualToString:@"sampling_group"]) {
        elementName = @"groups";
        
        // in the XPath specification if an element is unique it has no index in the path description. This means that the index returned by indexInString: was NSNotFound which is ignored by the stringByAppendingIndex: method. DEGS needs an index in order to be able to access the element in array properties and in this case NSNotFound means that the element is unique hence we assign an index 0 to it
        if (index == NSNotFound) index = 0;
    }
    [components replaceObjectAtIndex:0 withObject:[elementName stringByAppendingIndex:index]];
    return [super addObjectsFromPathComponents:components toPathObjects:pathObjects];
}

@end
