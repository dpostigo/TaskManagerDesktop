//
//  JSNoiseVector.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSGeneralVector.h"

@interface JSNoiseVector : JSGeneralVector

@property (nonatomic, strong) NSArray *initialBasis;
@property (nonatomic) NSUInteger method;
@property (nonatomic, strong, readonly) NSArray *methodOptions;
@property (nonatomic, strong) NSString *seed;
@property (nonatomic) NSUInteger kind;
@property (nonatomic, strong, readonly) NSArray *kindOptions;
@property (nonatomic, strong) NSString *mean;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
