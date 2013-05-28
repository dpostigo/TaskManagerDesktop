//
// Created by Daniela Postigo on 5/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DPSplitView.h"


@interface SplitViewContainer : NSView {
    __unsafe_unretained DPSplitView *splitView;

    CGFloat maximumHeight;
    CGFloat minimumHeight;

    CGFloat maximumWidth;
    CGFloat minimumWidth;

    BOOL isLocked;
}


@property(nonatomic) CGFloat maximumHeight;
@property(nonatomic) CGFloat minimumHeight;
@property(nonatomic) CGFloat maximumWidth;
@property(nonatomic) CGFloat minimumWidth;
@property(nonatomic, assign) DPSplitView *splitView;
@property(nonatomic) BOOL isLocked;
- (void) setMinimumHeight: (CGFloat) minimumHeight1 shouldUpdate: (BOOL) shouldUpdate;
- (void) setMinimumWidth: (CGFloat) minimumWidth1 shouldUpdate: (BOOL) shouldUpdate;
- (void) setMaximumWidth: (CGFloat) maximumWidth1 shouldUpdate: (BOOL) shouldUpdate;
- (void) setMaximumHeight: (CGFloat) maximumHeight1 shouldUpdate: (BOOL) shouldUpdate;
@end