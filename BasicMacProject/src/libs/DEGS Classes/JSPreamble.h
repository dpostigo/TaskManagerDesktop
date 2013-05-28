//
//  JSPreamble.h
//  DEGS Model
//
//  Created by Jacopo Sabbatini on 11/12/12.
//  Copyright (c) 2012 Jacopo Sabbatini. All rights reserved.
//

// the preamble section is the the only class that does not provide its own initialiser and expoerter since there is little advantage in doing so

#import <Foundation/Foundation.h>
#import "JSNode.h"

@interface JSPreamble : JSNode

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *scriptDescription;

@end
