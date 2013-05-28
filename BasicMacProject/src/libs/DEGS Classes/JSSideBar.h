//
//  JSSideBar.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 2/11/12.
//
//

#import "KGNoise.h"

@class JSSideBar, JSButtonStyle;

@protocol JSSideBarDelegate <NSObject>

@optional
// newSelection is a dictionary containing the index and title of the new selection
- (BOOL)sidebar:(JSSideBar *)sidebar shouldChangeSelectionTo:(NSDictionary *)newSelection;
- (void)sidebar:(JSSideBar *)sidebar didChangeSelectionTo:(NSDictionary *)newSelection;
@end

@interface JSSideBar : KGNoiseView

// This is a NSArray of NSDictionary containing title (as NSString) and image (as NSImage) of the buttons
@property (strong, nonatomic) NSArray *buttons;

// JSButtonStyle controls the look of the buttons in the sidebar
@property (strong, nonatomic) JSButtonStyle *buttonsStyle;

// you need to provide a title and an image for any new button
-(void)addButtonWithTitle:(NSString*)title image:(NSImage*)image;

// you can access and remove buttons both by their title or their index
-(void)removeButtonWithTitle:(NSString*)title;
-(void)removeButtonAtIndex:(NSInteger)index;
-(void)selectButtonWithIndex:(NSUInteger)index;
-(void)selectButtonWithTitle:(NSString *)title;

// These readonly methods return the identifier for the current selection
@property (readonly) NSUInteger selectionIndex;
@property (readonly) NSString *selectionTitle;

@property (nonatomic, retain) id<JSSideBarDelegate> delegate;

// Do we want to draw the previous and next buttons?
@property (nonatomic) BOOL hasStepButtons;

@end
