//
//  JSDependencies.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@interface JSDependencies : JSNode

@property (nonatomic, strong) NSArray *vectors;
@property (nonatomic, strong) NSArray *basis;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
