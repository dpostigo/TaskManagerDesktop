//
//  JSBottomBarView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 16/10/12.
//
//

#import <Cocoa/Cocoa.h>
#import "KGNoise.h"

@protocol JSBottomBarDelegate <NSObject>

@optional

// inform the delegate of clicks on any of the left group of buttons (add, delete and back)
- (void)addElement:(id)sender;
- (void)deleteElement:(id)sender;
- (void)backButtonPressed:(id)sender;
- (void)helpButtonPressed:(id)sender;

@end

@interface JSBottomBarView : KGNoiseLinearGradientView

@property (nonatomic, unsafe_unretained) id <JSBottomBarDelegate> delegate;

// these methods are hooks to change the state and look of the left group of buttons (add, delete and back)
- (void)showBackButton:(BOOL)show withAnimation:(BOOL)animate;
- (void)enableNewButton:(BOOL)newState;
- (void)enableDeleteButton:(BOOL)newState;

// each view controller wants to set the label for the new button. Some view controllers need to add vectors, other arguments etc.
- (void)setNewLabel:(NSString *)newLabel;

@end
