//
//  JSButtonStyle.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 19/02/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSButtonStyle.h"

@implementation JSButtonStyle

- (id)initWithDecorations:(NSDictionary *)decorations
{
    self = [super init];
    if (self) {
        self.highlightDecoration = [decorations objectForKey:@"highlight"];
        self.normalDecoration = [decorations objectForKey:@"normal"];
        self.mouseOverDecoration = [decorations objectForKey:@"mouseOver"];
        self.selectionDecoration = [decorations objectForKey:@"selection"];
    }
    return self;
}

+ (id)defaultLightStyle
{
    JSButtonDecoration *decoration = [[JSButtonDecoration alloc] initWithColor:[NSColor whiteColor]];
    NSDictionary *decorations = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:decoration, decoration, decoration, decoration, nil] forKeys:[NSArray arrayWithObjects:@"normal", @"highlight", @"mouseOver", @"selection", nil]];
    JSButtonStyle *style = [[JSButtonStyle alloc] initWithDecorations:decorations];
    style.textColor = [NSColor whiteColor];
    return style;
}

+ (id)defaultDarkStyle
{
    JSButtonDecoration *decoration = [[JSButtonDecoration alloc] initWithColor:[NSColor blackColor]];
    NSDictionary *decorations = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:decoration, decoration, decoration, decoration, nil] forKeys:[NSArray arrayWithObjects:@"normal", @"highlight", @"mouseOver", @"selection", nil]];
    JSButtonStyle *style = [[JSButtonStyle alloc] initWithDecorations:decorations];
    style.textColor = [NSColor blackColor];
    return style;

}

@end
