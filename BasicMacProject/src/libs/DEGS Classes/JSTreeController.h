//
//  JSTreeController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 18/04/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSViewWithSlidingViews.h"
#import "JSBottomBarView.h"
#import "JSXMDS.h"

@class JSTreeController, JSSectionViewController;

@protocol JSTreeControllerDelegate <NSObject>

@optional

- (void)treeController:(JSTreeController *)treeController didShowViewController:(NSViewController *)viewController;

@end


@interface JSTreeController : NSObject <JSBottomBarDelegate>

// tree controller delegate that receives message about changed view controllers
@property (nonatomic, unsafe_unretained) id <JSTreeControllerDelegate> delegate;

// This property keep track of the tag of the current section
@property (readonly) NSUInteger currentTag;

// the views composing the tree controller
@property (nonatomic, strong) JSViewWithSlidingViews *contentView;
@property (nonatomic, strong) JSBottomBarView *bottomBar;

// the model
@property (nonatomic, strong) JSXMDS *xmds;

// utility methods to change view controllers
- (void)switchToMainViewControllerWithTag:(unsigned short)tag;
- (void)switchToMainViewControllerWithName:(NSString *)sectionName;
- (void)switchToPreviousViewController;
- (void)switchToNextViewController;
- (void)showCellForPathObjects:(NSArray *)pathObjects;
- (void)showSubsectionForObject:(id)object;

// the current view controller
@property (nonatomic, strong, readonly) NSViewController *currentViewController;

// these are the main sections we handle
@property (nonatomic, strong) NSArray *mainSectionNames;

@end
