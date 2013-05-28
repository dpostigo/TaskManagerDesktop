//
//  JSTreeController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 18/04/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSTreeController.h"

#import "JSPreambleViewController.h"
#import "JSFeaturesViewController.h"
#import "JSGeometryViewController.h"
#import "JSVectorViewController.h"
#import "JSSequenceViewController.h"
#import "JSOutputViewController.h"
#import "JSOperatorsViewController.h"
#import "JSOperatorViewController.h"
#import "JSFiltersViewController.h"

//#import "JSAppDelegate.h"

#define CONTENTVIEW_COLOR [NSColor colorWithCalibratedRed:0.94f green:0.93f blue:0.83f alpha:1.0f]
#define CONTENTVIEW_NOISE_ALPHA 0.7f
#define VIEW_SLIDING_DURATION 0.3f

#define BOTTOM_BAR_FIRST_COLOR [NSColor colorWithCalibratedWhite:0.8980f alpha:1.0f]
#define BOTTOM_BAR_SECOND_COLOR [NSColor colorWithCalibratedWhite:0.6901f alpha:1.0f]

@interface JSTreeController()

// returns the index of a section given its name using the section names property
- (NSUInteger)mainSectionIndexForString:(NSString *)mainSectionName;

// returns the index of a section given an object in the xmds tree
- (NSUInteger)mainSectionIndexForObject:(JSNode *)object;

// various methods to create the sections view controllers
- (JSSectionViewController *)viewControllerForObject:(id)object;
- (JSSectionViewController *)subsectionViewControllerForObject:(id)object;
- (JSSectionViewController *)mainSectionViewControllerForObject:(id)object;
- (JSSectionViewController *)viewControllerForPathObjects:(NSArray *)pathObjects;

// utility method to actually executes the swap of view controllers
- (void)slideNewViewController:(JSSectionViewController *)newViewController fromDirection:(JSSlidingDirection)direction;

// returns the index of a cell in the section view controller table for object
- (NSUInteger)cellIndexForObject:(JSNode *)object;

@end

@implementation JSTreeController

# pragma mark - setters and getters

- (JSViewWithSlidingViews *)contentView
{
    if (!_contentView) {
        _contentView = [[JSViewWithSlidingViews alloc] init];
        _contentView.backgroundColor = CONTENTVIEW_COLOR;
        _contentView.noiseOpacity = CONTENTVIEW_NOISE_ALPHA;
        [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // we want to be notified when the contentView slide in a new view so that we can update the pathBar on top and other things we may want to do in the future
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(slidingViewChangedView:)
                                                     name:JSViewWithSlidingViewDidChangedView object:self.contentView];
    }
    return _contentView;
}

- (JSBottomBarView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[JSBottomBarView alloc] init];
        _bottomBar.backgroundColor = BOTTOM_BAR_FIRST_COLOR;
        _bottomBar.alternateBackgroundColor = BOTTOM_BAR_SECOND_COLOR;
        _bottomBar.delegate = self;
        [_bottomBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _bottomBar;
}

- (NSViewController *)currentViewController
{
    return self.contentView.currentViewController;
}

# pragma mark - controller exchange

- (void)switchToPreviousViewController
{
    [self switchToMainViewControllerWithTag:self.currentTag-1];
}

- (void)switchToNextViewController
{
    [self switchToMainViewControllerWithTag:self.currentTag+1];
}

// we create the new view controller for the section represented by tag and pass it to the contentView that slide its view in
- (void)switchToMainViewControllerWithTag:(unsigned short)tag
{
    JSSectionViewController *newViewController;
    [[NSAnimationContext currentContext] setDuration:VIEW_SLIDING_DURATION];
    switch (tag)
    {
        case 0:
            newViewController = [[JSPreambleViewController alloc] initWithPreamble:self.xmds.preamble];
            break;
        case 1:
            newViewController = [[JSFeaturesViewController alloc] initWithFeatures:self.xmds.features driver:self.xmds.driver];
            break;
        case 2:
            newViewController = [[JSGeometryViewController alloc] initWithGeometry:self.xmds.geometry];
            break;
        case 3:
            newViewController = [[JSVectorViewController alloc] initWithVectors:self.xmds.vectors];
            break;
        case 4:
            newViewController = [[JSSequenceViewController alloc] initWithSequence:self.xmds.sequence];
            break;
        case 5:
            newViewController = [[JSOutputViewController alloc] initWithOutput:self.xmds.output];
            break;
    }
    
    if ( self.currentTag <= tag ) {
        [self slideNewViewController:newViewController fromDirection:JSSlidingFromTop];
    } else {
        [self slideNewViewController:newViewController fromDirection:JSSlidingFromBottom];
    }
}

- (void)switchToMainViewControllerWithName:(NSString *)sectionName
{
    NSUInteger tagForNewViewController = [self mainSectionIndexForString:sectionName];
    [self switchToMainViewControllerWithTag:tagForNewViewController];
}

- (void)showCellForPathObjects:(NSArray *)pathObjects
{
    // first we walk the path backwards until we find an object handled by a section view controller
    JSSectionViewController *newViewController = nil;
    for (NSUInteger i = pathObjects.count - 1; i > 0; i--) {
        id currentObject = pathObjects[i];
        newViewController = [self viewControllerForObject:currentObject];
        if (newViewController) {
            NSUInteger tagForNewViewController = [self mainSectionIndexForString:[pathObjects[1] description]];
            
            if ( self.currentTag <= tagForNewViewController ) {
                [self slideNewViewController:newViewController fromDirection:JSSlidingFromTop];
            } else {
                [self slideNewViewController:newViewController fromDirection:JSSlidingFromBottom];
            }
            
            NSUInteger cellIndex = [self cellIndexForObject:pathObjects[i+1]];
            if (cellIndex != NSNotFound) [[newViewController mainTableView] selectRowIndexes:[NSIndexSet indexSetWithIndex:cellIndex+[newViewController biasCells]] byExtendingSelection:NO];
            break;
        }
    }
}

- (void)showSubsectionForObject:(id)object
{
    JSSectionViewController *subsectionViewController = [self subsectionViewControllerForObject:object];
    [self slideNewViewController:subsectionViewController fromDirection:JSSlidingFromRight];
}

- (void)slideNewViewController:(JSSectionViewController *)newViewController fromDirection:(JSSlidingDirection)direction
{
    id object = newViewController.representedObject;
    if ([object isKindOfClass:[NSDictionary class]]) object = [(NSDictionary *)object objectForKey:@"features"];
    _currentTag = [self mainSectionIndexForObject:object];
    newViewController.treeController = self;
    [self.contentView slideViewController:newViewController fromDirection:direction];
    [newViewController viewDidAppear];
}

# pragma mark - retrieve view controllers

- (JSSectionViewController *)viewControllerForObject:(id)object
{
    JSSectionViewController *viewController = [self subsectionViewControllerForObject:object];
    if (viewController) return viewController;
    return [self mainSectionViewControllerForObject:object];
}

- (JSSectionViewController *)subsectionViewControllerForObject:(id)object
{
    JSSectionViewController *viewController = nil;
    
    if ([object isKindOfClass:[JSOperatorsStack class]]) viewController = [[JSOperatorsViewController alloc] initWithOperators:object];
    
    if ([object isKindOfClass:[JSFilters class]]) viewController = [[JSFiltersViewController alloc] initWithFilters:object];
    
    if ([object isKindOfClass:[JSOperatorStack class]]) viewController = [[JSOperatorViewController alloc] initWithOperator:object];
    
    if ([object isKindOfClass:[JSVectors class]]) viewController = [[JSVectorViewController alloc] initWithVectors:object];
    
    return viewController;
}

- (JSSectionViewController *)mainSectionViewControllerForObject:(id)object
{
    JSSectionViewController *viewController = nil;
    
    if ([object isKindOfClass:[JSPreamble class]]) viewController = [[JSPreambleViewController alloc] initWithPreamble:object];
    
    if ([object isKindOfClass:[JSFeatures class]]) viewController = [[JSFeaturesViewController alloc] initWithFeatures:object driver:self.xmds.driver];
    
    if ([object isKindOfClass:[JSDriver class]]) viewController = [[JSFeaturesViewController alloc] initWithFeatures:self.xmds.features driver:object];
    
    if ([object isKindOfClass:[JSGeometry class]]) viewController = [[JSGeometryViewController alloc] initWithGeometry:object];
    
    if ([object isKindOfClass:[JSVectors class]]) viewController = [[JSVectorViewController alloc] initWithVectors:object];
    
    if ([object isKindOfClass:[JSSequence class]]) viewController = [[JSSequenceViewController alloc] initWithSequence:object];
    
    if ([object isKindOfClass:[JSOutput class]]) viewController = [[JSOutputViewController alloc] initWithOutput:object];
    
    return viewController;
}

- (JSSectionViewController *)viewControllerForPathObjects:(NSArray *)pathObjects
{
    // first we walk the path backwards until we find an object handled by a section view controller
    JSSectionViewController *newViewController = nil;
    for (NSUInteger i = pathObjects.count - 1; i > 0; i--) {
        id currentObject = pathObjects[i];
        newViewController = [self viewControllerForObject:currentObject];
        if (newViewController) break;
    }
    return newViewController;
}

- (NSUInteger)cellIndexForObject:(JSNode *)object
{
    NSUInteger cellIndex = NSNotFound;
    id parentObject = [object parent];
    if ([parentObject isKindOfClass:[JSFeatures class]]) {
        cellIndex = [[parentObject arguments] indexOfObject:object];
        if (cellIndex == NSNotFound) cellIndex = 1;
    } else if ([parentObject isKindOfClass:[JSGeometry class]]) {
        cellIndex = [[parentObject transverseDimension] indexOfObject:object];
        if (cellIndex == NSNotFound) cellIndex = 0;
    } else if ([parentObject isKindOfClass:[JSVectors class]]) {
        cellIndex = [[parentObject vectors] indexOfObject:object];
    } else if ([parentObject isKindOfClass:[JSSequence class]]) {
        cellIndex = [[parentObject operations] indexOfObject:object];
    } else if ([parentObject isKindOfClass:[JSOperatorsStack class]]) {
        cellIndex = [[parentObject operators] indexOfObject:object];
    } else if ([parentObject isKindOfClass:[JSFilters class]]) {
        cellIndex = [[parentObject filters] indexOfObject:object];
        if (cellIndex == NSNotFound) cellIndex = 0;
    } else if ([parentObject isKindOfClass:[JSOperatorStack class]]) {
        cellIndex = [[parentObject operators] indexOfObject:object];
    } else if ([parentObject isKindOfClass:[JSOutput class]]) {
        cellIndex = [[parentObject groups] indexOfObject:object];
        if (cellIndex == NSNotFound) cellIndex = 0;
    }
    return cellIndex;
}

- (NSUInteger)mainSectionIndexForObject:(JSNode *)object
{
    return [self mainSectionIndexForString:[[object pathObjects][1] description]];
}

- (NSUInteger)mainSectionIndexForString:(NSString *)sectionName
{
    return [self.mainSectionNames indexOfObject:sectionName];
}

# pragma mark - sliding view delegate methods

// we got informed that the contentView (JSViewWithSlidingViews) has put in a new view so we want to do 2 things
// 1: change the items in the path bar
// 2: make the table view in the current view controller (mainTableView) the first responder
- (void)slidingViewChangedView:(NSNotification *)aNotification
{
    NSWindow *window = [self.contentView window];
    [window makeFirstResponder:[(JSSectionViewController *) self.contentView.currentViewController mainTableView]];
    
    if ([self.delegate respondsToSelector:@selector(treeController:didShowViewController:)]) {
        [self.delegate treeController:self didShowViewController:self.currentViewController];
    }
}

# pragma mark - Bottom bar delegate methods

- (void)addElement:(id)sender
{
    [(JSSectionViewController *) self.contentView.currentViewController addElement:sender];
}

- (void)deleteElement:(id)sender
{
    [(JSSectionViewController *) self.contentView.currentViewController deleteElement:sender];
}

- (void)backButtonPressed:(id)sender
{
    JSNode *parentObject = [(JSNode *) self.currentViewController.representedObject parent];
    JSSectionViewController *backViewController = [self viewControllerForPathObjects:[parentObject pathObjects]];
    [self slideNewViewController:backViewController fromDirection:JSSlidingFromLeft];
    NSUInteger cellIndex = [self cellIndexForObject:parentObject];
    if (cellIndex != NSNotFound)
        [[backViewController mainTableView] selectRowIndexes:[NSIndexSet indexSetWithIndex:cellIndex+[backViewController biasCells]] byExtendingSelection:NO];
}

// we ask the app delegate to show the help for the section we currently showing
- (void)helpButtonPressed:(id)sender
{
//    JSAppDelegate *appDelegate = (JSAppDelegate *)[[NSApplication sharedApplication] delegate];
//    [appDelegate showHelpPageForElementWithName:[(JSSectionViewController *) self.contentView.currentViewController sectionSuffix]];
}

@end
