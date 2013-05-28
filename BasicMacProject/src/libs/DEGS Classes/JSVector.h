//
//  JSVector.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 3/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSGeneralVector.h"
#import "JSDependencies.h"

@interface JSVector : JSGeneralVector

@property (nonatomic, strong) NSArray *initialBasis;
@property (nonatomic) NSInteger initialisation;
@property (nonatomic, strong, readonly) NSArray *initialisationOptions;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *cdataString;
@property (nonatomic, strong) JSDependencies *dependencies;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
