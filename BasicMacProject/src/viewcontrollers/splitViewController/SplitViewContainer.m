//
// Created by Daniela Postigo on 5/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SplitViewContainer.h"


@implementation SplitViewContainer {
}


@synthesize maximumHeight;
@synthesize minimumHeight;


@synthesize maximumWidth;
@synthesize minimumWidth;


@synthesize splitView;

//
//- (void) setMinimumHeight: (CGFloat) minimumHeight1 {
//    [self setMinimumHeight: minimumHeight1 shouldUpdate: YES];
//}
//
//- (void) setMinimumWidth: (CGFloat) minimumWidth1 {
//    [self setMinimumWidth: minimumWidth1 shouldUpdate: YES];
//}
//
//- (void) setMaximumHeight: (CGFloat) maximumHeight1 {
//    [self setMaximumHeight: maximumHeight1 shouldUpdate: YES];
//}
//
//- (void) setMaximumWidth: (CGFloat) maximumWidth1 {
//    [self setMaximumWidth: maximumWidth1 shouldUpdate: YES];
//}
//
//
//- (void) setMinimumHeight: (CGFloat) minimumHeight1 shouldUpdate: (BOOL) shouldUpdate {
//    minimumHeight = minimumHeight1;
//    if (self.height < minimumHeight) self.height = minimumHeight;
////    if (shouldUpdate) [splitView splitContainerUpdatedMinHeight: self];
//}
//
//
//- (void) setMinimumWidth: (CGFloat) minimumWidth1 shouldUpdate: (BOOL) shouldUpdate {
//    minimumWidth = minimumWidth1;
//    if (self.width < minimumWidth) self.width = minimumWidth;
////    if (shouldUpdate) [splitView splitContainerUpdatedMinWidth: self];
//}
//
//- (void) setMaximumWidth: (CGFloat) maximumWidth1 shouldUpdate: (BOOL) shouldUpdate {
//    NSLog(@"maximumWidth1 = %f", maximumWidth1);
//    maximumWidth = maximumWidth1;
//    if (self.width > maximumWidth) self.width = maximumWidth;
//
//    if (shouldUpdate) {
//        NSLog(@"%s", __PRETTY_FUNCTION__);
//        NSLog(@"split view updated");
////        [splitView splitContainerUpdatedMaxWidth: self];
//    }
//}
//
//
//- (void) setMaximumHeight: (CGFloat) maximumHeight1 shouldUpdate: (BOOL) shouldUpdate {
//    maximumHeight = maximumHeight1;
//    if (self.height < maximumHeight) self.height = maximumHeight;
////    if (shouldUpdate) [splitView splitContainerUpdatedMaxHeight: self];
//}


@synthesize isLocked;
@end