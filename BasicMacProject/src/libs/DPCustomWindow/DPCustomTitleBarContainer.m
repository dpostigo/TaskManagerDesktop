//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DPCustomTitleBarContainer.h"


@implementation DPCustomTitleBarContainer {
}


- (void) mouseDragged: (NSEvent *) theEvent {
    NSWindow *window = [self window];
    NSPoint where = [window convertBaseToScreen: [theEvent locationInWindow]];
    if ([window isMovableByWindowBackground]) {
        [super mouseDragged: theEvent];
        return;
    }
    NSUInteger masks = [window styleMask];
    if (!(masks & NSFullScreenWindowMask)) {
        NSPoint origin = [window frame].origin;
        while ((theEvent = [NSApp nextEventMatchingMask: NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSLeftMouseUpMask untilDate: [NSDate distantFuture] inMode: NSEventTrackingRunLoopMode dequeue: YES]) && ([theEvent type] != NSLeftMouseUp)) {
            @autoreleasepool {
                NSPoint now = [window convertBaseToScreen: [theEvent locationInWindow]];
                origin.x += now.x - where.x;
                origin.y += now.y - where.y;
                [window setFrameOrigin: origin];
                where = now;
            }
        }
    }
}

@end