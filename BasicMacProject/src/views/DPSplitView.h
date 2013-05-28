//
//  DPSplitView.h
//  TaskManager
//
//  Created by Daniela Postigo on 5/26/13.
//  Copyright 2013 Dani Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SplitViewContainer;

@interface DPSplitView : NSSplitView {
    NSMutableArray *splitContainers;

}

@property(nonatomic, strong) NSMutableArray *splitContainers;
- (void) splitContainerUpdatedMaxHeight: (SplitViewContainer *) container;
- (void) splitContainerUpdatedMaxWidth: (SplitViewContainer *) container;
- (void) splitContainerUpdatedMinHeight: (SplitViewContainer *) container;
- (void) splitContainerUpdatedMinWidth: (SplitViewContainer *) container;
- (SplitViewContainer *) otherSplitContainer: (SplitViewContainer *) container;
- (SplitViewContainer *) splitViewContainerAtIndex: (NSInteger) index1;
@end