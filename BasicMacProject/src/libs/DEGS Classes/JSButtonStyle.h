//
//  JSButtonStyle.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 19/02/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSButtonDecoration.h"

@interface JSButtonStyle : NSObject

// decorations is a dictionary where the key represent the type of decoration and the value is the decoration itself
- (id)initWithDecorations:(NSDictionary *)decorations;

// returns a style where all the decorations and text are white
+ (id)defaultLightStyle;

// returns a style where all the decorations and text are black
+ (id)defaultDarkStyle;

// properties describing the decoration of button in all its possible states
@property (nonatomic, strong) JSButtonDecoration *highlightDecoration;
@property (nonatomic, strong) JSButtonDecoration *normalDecoration;
@property (nonatomic, strong) JSButtonDecoration *selectionDecoration;
@property (nonatomic, strong) JSButtonDecoration *mouseOverDecoration;

@property (nonatomic, strong) NSColor *textColor;

@end
