//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DPCustomWindowButton.h"
#import "DPTitleBarView.h"


@interface DPCustomWindow : NSWindow {

    CGFloat cornerRadius;
    CGFloat titleBarHeight;
    DPTitleBarView *titleBarView;

    BOOL centerFullScreenButton;
    BOOL centerTrafficLightButtons;
    BOOL verticalTrafficLightButtons;
    BOOL hideTitleBarInFullScreen;
    BOOL showsBaselineSeparator;

    CGFloat trafficLightButtonsLeftMargin;
    CGFloat trafficLightButtonsTopMargin;
    CGFloat fullScreenButtonRightMargin;
    CGFloat fullScreenButtonTopMargin;
    CGFloat trafficLightSeparation;

    BOOL showsTitle;
    BOOL showsTitleInFullscreen;
    DPCustomWindowButton *closeButton;
    DPCustomWindowButton *minimizeButton;
    DPCustomWindowButton *zoomButton;
    DPCustomWindowButton *fullScreenButton;

    NSColor *titleBarStartColor;
    NSColor *titleBarEndColor;
    NSColor *baselineSeparatorColor;
    NSColor *titleTextColor;
    NSShadow *titleTextShadow;

    NSColor *inactiveTitleBarStartColor;
    NSColor *inactiveTitleBarEndColor;
    NSColor *inactiveBaselineSeparatorColor;
    NSColor *inactiveTitleTextColor;
    NSShadow *inactiveTitleTextShadow;
}


typedef void (^INAppStoreWindowTitleBarDrawingBlock)(BOOL drawsAsMainWindow,
        CGRect drawingRect, CGPathRef clippingPath);
@property(nonatomic, strong) INAppStoreWindowTitleBarDrawingBlock titleBarDrawingBlock;

@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic) CGFloat titleBarHeight;
@property(nonatomic, strong) DPTitleBarView *titleBarView;
@property(nonatomic) BOOL centerFullScreenButton;
@property(nonatomic) BOOL centerTrafficLightButtons;
@property(nonatomic) BOOL verticalTrafficLightButtons;
@property(nonatomic) BOOL hideTitleBarInFullScreen;
@property(nonatomic) BOOL showsBaselineSeparator;
@property(nonatomic) CGFloat trafficLightButtonsLeftMargin;
@property(nonatomic) CGFloat trafficLightButtonsTopMargin;
@property(nonatomic) CGFloat fullScreenButtonRightMargin;
@property(nonatomic) CGFloat fullScreenButtonTopMargin;
@property(nonatomic) CGFloat trafficLightSeparation;
@property(nonatomic) BOOL showsTitle;
@property(nonatomic) BOOL showsTitleInFullscreen;
@property(nonatomic, strong) DPCustomWindowButton *closeButton;
@property(nonatomic, strong) DPCustomWindowButton *minimizeButton;
@property(nonatomic, strong) DPCustomWindowButton *zoomButton;
@property(nonatomic, strong) DPCustomWindowButton *fullScreenButton;
@property(nonatomic, strong) NSColor *titleBarStartColor;
@property(nonatomic, strong) NSColor *titleBarEndColor;
@property(nonatomic, strong) NSColor *baselineSeparatorColor;
@property(nonatomic, strong) NSColor *titleTextColor;
@property(nonatomic, strong) NSShadow *titleTextShadow;
@property(nonatomic, strong) NSColor *inactiveTitleBarStartColor;
@property(nonatomic, strong) NSColor *inactiveTitleBarEndColor;
@property(nonatomic, strong) NSColor *inactiveBaselineSeparatorColor;
@property(nonatomic, strong) NSColor *inactiveTitleTextColor;
@property(nonatomic, strong) NSShadow *inactiveTitleTextShadow;
@end
