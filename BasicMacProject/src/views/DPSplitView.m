//
//  DPSplitView.m
//  TaskManager
//
//  Created by Daniela Postigo on 5/26/13.
//  Copyright 2013 Dani Postigo. All rights reserved.
//

#import "DPSplitView.h"
#import "SplitViewContainer.h"


@implementation DPSplitView {

}


@synthesize splitContainers;

@synthesize dividerColor;

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        self.splitContainers = [[NSMutableArray alloc] init];

    }

    return self;
}


#pragma mark Display customization




- (void) awakeFromNib {
    [super awakeFromNib];

    for (NSView *view in self.subviews) {
        if ([view isKindOfClass: [SplitViewContainer class]]) {
            SplitViewContainer *splitContainer = (SplitViewContainer *) view;
            splitContainer.splitView = self;
            [splitContainers addObject: splitContainer];

            //            [self splitContainerUpdatedMaxHeight: splitContainer];
            //            [self splitContainerUpdatedMaxWidth: splitContainer];
        }
    }
}


- (void) splitContainerUpdatedMaxHeight: (SplitViewContainer *) container {
    CGFloat currentHeight = self.frame.size.height;
    CGFloat allowableHeight = currentHeight - container.maximumHeight;
    SplitViewContainer *otherContainer = [self otherSplitContainer: container];
    [otherContainer setMinimumHeight: allowableHeight shouldUpdate: YES];
}


- (void) splitContainerUpdatedMinHeight: (SplitViewContainer *) container {
    CGFloat currentHeight = self.frame.size.height;
    CGFloat allowableHeight = currentHeight - container.minimumHeight;
    SplitViewContainer *otherContainer = [self otherSplitContainer: container];
    [otherContainer setMaximumHeight: allowableHeight shouldUpdate: NO];

}

- (void) splitContainerUpdatedMaxWidth: (SplitViewContainer *) container {
    CGFloat currentHeight = self.frame.size.width;
    CGFloat allowableHeight = currentHeight - container.maximumWidth;
    SplitViewContainer *otherContainer = [self otherSplitContainer: container];

    NSLog(@"otherContainer = %@", otherContainer);
    [otherContainer setMinimumWidth: allowableHeight shouldUpdate: NO];

}


- (void) splitContainerUpdatedMinWidth: (SplitViewContainer *) container {
    CGFloat currentHeight = self.frame.size.width;
    CGFloat allowableHeight = currentHeight - container.minimumWidth;
    SplitViewContainer *otherContainer = [self otherSplitContainer: container];
    [otherContainer setMaximumWidth: allowableHeight shouldUpdate: NO];


}

- (SplitViewContainer *) otherSplitContainer: (SplitViewContainer *) container {
    for (SplitViewContainer *splitContainer in splitContainers) {
        if (splitContainer != container) {
            return splitContainer;
        }
    }
    return nil;
}

- (SplitViewContainer *) splitViewContainerAtIndex: (NSInteger) index {
    NSView *subview = [self.subviews objectAtIndex: index];
    if (subview && [subview isKindOfClass: [SplitViewContainer class]]) {
        SplitViewContainer *container = (SplitViewContainer *) subview;
        return container;
    }
    return nil;
}


@end