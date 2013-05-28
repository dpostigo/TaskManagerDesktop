//
//  JSComputedVector.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSGeneralVector.h"
#import "JSDependencies.h"

@interface JSComputedVector : JSGeneralVector

@property (nonatomic, strong) JSDependencies *dependencies;
@property (nonatomic, strong) NSString *definition;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end