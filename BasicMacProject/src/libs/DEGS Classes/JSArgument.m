//
//  JSArgument.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSArgument.h"
#import "JSXMDS.h"

@implementation JSArgument

- (NSArray *)typeOptions {
    return @[@"integer", @"real", @"string"];
}

- (void)setType:(NSInteger)type
{
    if (type <= ([self.typeOptions count]-1)) {
        _type = type;
    }
}

- (NSXMLElement *)exportAsXML
{
    NSXMLElement *element = [NSXMLElement elementWithName:@"argument"];
    
    if (_name) [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
    
    NSString *typeString = (self.typeOptions)[self.type];
    [element addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:typeString]];
    
    if (_defaultValue) [element addAttribute:[NSXMLNode attributeWithName:@"default_value" stringValue:self.defaultValue]];
    
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
        
        if ([anElement attributeForName:@"default_value"]) self.defaultValue = [[anElement attributeForName:@"default_value"] stringValue];
        
    }
    return self;
}

- (NSString *)description
{
    NSString *title = @"Argument";
    if (_name) title = [title stringByAppendingFormat:@" - %@", self.name];
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}

@end
