//
//  AMDarkButton.h
//  Button
//
//  Created by ampatspell on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VeryBasicButtonCell.h"


@interface BasicButtonCell : VeryBasicButtonCell {

    NSColor *textColor;

    NSShadow *textShadow;
    NSShadow *disabledTextShadow;

    NSColor *disabledTextColor;
}


@property(nonatomic, strong) NSColor *textColor;
@property(nonatomic, strong) NSColor *disabledTextColor;
@property(nonatomic, strong) NSShadow *textShadow;
@property(nonatomic, strong) NSShadow *disabledTextShadow;
@end
