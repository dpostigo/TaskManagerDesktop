//
//  JSFlexibleButton.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 30/10/12.
//
//

#import <Cocoa/Cocoa.h>

@class JSButtonStyle;

@interface JSFlexibleButton : NSButton

// should we track mouse over events?
@property (nonatomic) BOOL trackMouseInside;

// button look
@property (nonatomic, strong) JSButtonStyle *style;

@end
