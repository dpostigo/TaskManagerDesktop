//
//  Dependencies.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSDependencies.h"

@implementation JSDependencies

@synthesize vectors = _vectors;
@synthesize basis = _basis;

- (NSXMLElement *)exportAsXML
{
    // we export something valid only if there is at least one vector in the list of dependencies
    if ([self.vectors count]) {
        
        NSXMLElement *dependeciesElement = [NSXMLElement elementWithName:@"dependencies"];
        
        if (_basis) [dependeciesElement addAttribute:[NSXMLNode attributeWithName:@"basis" stringValue:[self.basis componentsJoinedByString:@" "]]];
        
        if (_vectors) [dependeciesElement setStringValue:[self.vectors componentsJoinedByString:@" "]];
        
        return dependeciesElement;
    }
    return nil;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        NSString *vectorsString = [[anElement stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        self.vectors = [vectorsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([anElement attributeForName:@"basis"]) self.basis = [[[anElement attributeForName:@"basis"] stringValue] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return self;
}

@end
