//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPCustomWindowDelegateProxy.h"
#import "DPCustomWindow.h"


@implementation DPCustomWindowDelegateProxy {
}


- (NSMethodSignature *) methodSignatureForSelector: (SEL) selector {
    NSMethodSignature *signature = [[self.secondaryDelegate class] instanceMethodSignatureForSelector: selector];
    NSAssert(signature != nil, @"The method signature(%@) should not be nil becuase of the respondsToSelector: check", NSStringFromSelector(selector));
    return signature;
}

- (BOOL) respondsToSelector: (SEL) aSelector {
    if ([self.secondaryDelegate respondsToSelector: aSelector]) {
        return YES;
    } else if (aSelector == @selector(window:willPositionSheet:usingRect:)) {
        return YES;
    }
    return NO;
}

- (void) forwardInvocation: (NSInvocation *) anInvocation {
    if ([self.secondaryDelegate respondsToSelector: [anInvocation selector]]) {
        [anInvocation invokeWithTarget: self.secondaryDelegate];
    }
}

- (NSRect) window: (DPCustomWindow *) window willPositionSheet: (NSWindow *) sheet usingRect: (NSRect) rect {
    rect.origin.y = NSHeight(window.frame) - window.titleBarHeight;
    return rect;
}

- (BOOL) isKindOfClass: (Class) aClass {
    if (self.secondaryDelegate) {
        return [self.secondaryDelegate isKindOfClass: aClass];
    }
    return NO;
}

@end
