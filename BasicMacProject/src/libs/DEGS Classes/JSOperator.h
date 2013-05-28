//
//  JSOperator.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 7/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@interface JSOperator : JSNode  

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger kind;
@property (readonly, nonatomic, strong) NSArray *kindOptions;
@property (nonatomic) NSUInteger type;
@property (readonly, nonatomic, strong) NSArray *typeOptions;
@property BOOL constant;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSString *definition;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
