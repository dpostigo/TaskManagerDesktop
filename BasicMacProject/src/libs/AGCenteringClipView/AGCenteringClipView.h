//
//  AGCenteringClipView.h
//  CenteredScroll
//
//  Created by Seth Willits on 12/4/08.
//  Copyright 2008 Araelium Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AGCenteringClipView : NSClipView {
    NSPoint mLookingAt; // the proportion up and across the view, not coordinates.
}


- (void) centerDocument;

@end
