//
// Created by dpostigo on 2/20/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicSplitView.h"


@implementation BasicSplitView {
    NSMutableArray *unconstrainedSizes;
}


- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {
        unconstrainedSizes = [[NSMutableArray alloc] init];
    }

    return self;
}


#pragma mark Convenience

- (void) setSize: (CGFloat) size ofSubview: (NSView *) subview animated: (BOOL) animated {
    NSUInteger index = [self.subviews indexOfObject: subview];
    [self setSize: size ofSubviewAtIndex: index animated: animated completition: ^(BOOL completion) {
    }];
}

- (void) setMaxSize: (CGFloat) aSize ofSubview: (NSView *) subview {
    NSUInteger index = [self.subviews indexOfObject: subview];
    if (index == -1) return;
    [self setMaxSize: aSize ofSubviewAtIndex: index];
}

- (void) setMinSize: (CGFloat) aSize ofSubview: (NSView *) subview {
    NSUInteger index = [self.subviews indexOfObject: subview];
    if (index == -1) return;
    [self setMinSize: aSize ofSubviewAtIndex: index];
}

- (void) constrainView: (NSView *) aView {
    BOOL isCollapsed = [self isSubviewCollapsed: aView];
    if (isCollapsed) {
        [self constrainCollapsedView: aView toSize: 0];
    } else {
        CGFloat currentSize = self.isVertical ? aView.width: aView.height;
        [self constrainExpandedView: aView toSize: currentSize];
    }
}

- (void) constrainCollapsedView: (NSView *) aView toSize: (CGFloat) size {
    [self storeMinMax];
    [self setMinSize: size ofSubview: aView];
    [self setMinSize: size ofSubview: aView];
}

- (void) constrainExpandedView: (NSView *) aView toSize: (CGFloat) size {
    [self storeMinMax];
    [self setMaxSize: size ofSubview: aView];
    [self setMinSize: size ofSubview: aView];
}

- (void) unconstrainView: (NSView *) aView {
    NSUInteger index = [self.subviews indexOfObject: aView];
    if (index != -1) {

        CGPoint point = [[unconstrainedSizes objectAtIndex: index] pointValue];
        CGFloat minSize = point.x;
        CGFloat maxSize = point.y;
        [self setMinSize: minSize ofSubviewAtIndex: index];
        [self setMaxSize: maxSize ofSubview: aView];
    }
}

- (void) storeMinMax {
    unconstrainedSizes = [[NSMutableArray alloc] init];
    for (NSView *subview in self.subviews) {
        NSUInteger index = [self.subviews indexOfObject: subview];
        CGFloat maxSize = [self maxSizeForSubviewAtIndex: index];
        CGFloat minSize = [self minSizeForSubviewAtIndex: index];
        CGPoint point = CGPointMake(minSize, maxSize);
        [unconstrainedSizes addObject: [NSValue valueWithPoint: point]];
    }
}

@end