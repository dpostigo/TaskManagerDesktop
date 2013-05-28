//
//  JSBreakpoint.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@class JSDependencies;

@interface JSBreakpoint : JSNode

@property (nonatomic, strong) NSString *filename;
@property (nonatomic) NSUInteger format;
@property (readonly, nonatomic, strong) NSArray *formatOptions;
@property (nonatomic, strong) JSDependencies *dependencies;
@property (nonatomic, strong) NSString *name;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
