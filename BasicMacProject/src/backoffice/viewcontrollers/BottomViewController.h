//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"

@class YRKSpinningProgressIndicator;

@interface BottomViewController : BasicViewController {

    IBOutlet NSButton *settingsButton;
    IBOutlet YRKSpinningProgressIndicator *indicator;
    IBOutlet NSTextField *statusLabel;
    IBOutlet NSView *statusIndicatorContainer;

    NSColor *indicatorColor;
}
@end