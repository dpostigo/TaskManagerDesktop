//
// Created by Daniela Postigo on 5/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicCustomWindow.h"
#import "DMSplitView.h"
#import "BasicSplitView.h"


@interface BasicFullWindow : BasicCustomWindow {
    IBOutlet BasicSplitView *mainSplitView;
    IBOutlet BasicSplitView *bottomSplitView;

    IBOutlet NSView *mainView;
    IBOutlet NSView *sidebarView;
    IBOutlet NSView *topView;
    IBOutlet NSView *bottomView;
}


@property(nonatomic, strong) NSView *mainView;
@property(nonatomic, strong) BasicSplitView *mainSplitView;
@property(nonatomic, strong) BasicSplitView *bottomSplitView;
@end