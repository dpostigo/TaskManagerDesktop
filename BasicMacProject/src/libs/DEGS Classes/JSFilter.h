//
//  JSFilter.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"
#import "JSDependencies.h"

@interface JSFilter : JSNode

@property (nonatomic, strong) JSDependencies *dependencies;
@property (nonatomic, strong) NSString *evaluation;
@property (nonatomic, strong) NSString *name;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
