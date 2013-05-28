//
//  JSGeneralVector.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

// placeholder class from which all the classes for the possible vectors are subclassed
// It holds the common properties whose ivar are declared as protected because they need to be accessed by the subclassed during the initialisation and export processes

#import <Foundation/Foundation.h>
#import "JSNode.h"

@interface JSGeneralVector : JSNode {
    NSString *_name;
    NSArray *_dimensions;
    NSArray *_components;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger type;
@property (nonatomic, strong, readonly) NSArray *typeOptions;
@property (nonatomic, strong) NSArray *dimensions;
@property (nonatomic, strong) NSArray *components;

@end
