//
// Created by dpostigo on 2/20/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DMSplitView.h"


@interface BasicSplitView : DMSplitView


- (void) setSize: (CGFloat) size1 ofSubview: (NSView *) subview animated: (BOOL) animated;
- (void) setMaxSize: (CGFloat) aSize ofSubview: (NSView *) subview;
- (void) setMinSize: (CGFloat) aSize ofSubview: (NSView *) subview;
- (void) constrainView: (NSView *) aView;
- (void) constrainExpandedView: (NSView *) aView toSize: (CGFloat) size1;
- (void) unconstrainView: (NSView *) aView;
@end