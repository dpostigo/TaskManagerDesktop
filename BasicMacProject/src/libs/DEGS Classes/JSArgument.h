//
//  JSArgument.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@interface JSArgument : JSNode

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic) NSInteger type;
@property (readonly, nonatomic, strong) NSArray *typeOptions;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
