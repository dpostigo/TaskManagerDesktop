//
//  JSFeatures.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 9/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@class JSArgument;

@interface JSFeatures : JSNode

@property BOOL autoVectorise;
@property BOOL benchmark;
@property BOOL bing;
@property BOOL diagnostics;
@property BOOL errorCheck;
@property BOOL haltNonFinite;
@property BOOL openMP;
@property (nonatomic) NSUInteger fftw;
@property (readonly, nonatomic, strong) NSArray *fftwOptions;
@property NSUInteger fftwThreads;
@property (nonatomic) NSUInteger precision;
@property (readonly, nonatomic, strong) NSArray *precisionOptions;
@property (nonatomic) NSUInteger validation;
@property (readonly, nonatomic, strong) NSArray *validationOptions;
@property (nonatomic, strong) NSString *chunkedOutput;
@property (nonatomic, strong) NSString *cflags;
@property (nonatomic, strong) NSString *globals;
@property (nonatomic, strong) NSString *argumentsGlobals;
@property (readonly) NSArray *arguments;
@property (readonly) NSUInteger numberOfArguments;

// bridges methods to add or delete an argument from the list
- (void)addArgument:(JSArgument *)argument;
- (void)addArgument:(JSArgument *)argument atIndex:(NSUInteger)index;
- (void)deleteArgumentAtIndex:(NSUInteger)index;
- (void)deleteArgumentsAtIndexes:(NSIndexSet *)indexes;


- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

- (NSArray *)listOfArgumentsIdentifiers;

@end
