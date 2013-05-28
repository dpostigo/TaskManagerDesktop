//
//  JSDriverTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 31/07/12.
//
//

#import "JSTableCellView.h"
#import "JSTextField.h"

// define the possible states for the cell
typedef enum _JSDriverCellState {
    JSDriverCellNoneOrDistributedMPIState         = 1,
    JSDriverCellMultiPathState                    = 0
} JSDriverCellState;

@interface JSDriverTableCellView : JSTableCellView

@property (strong) IBOutlet NSPopUpButton *typeButton;
@property (strong) IBOutlet JSTextField *pathsTextField;

@property (nonatomic, unsafe_unretained) id <JSTableCellViewDelegate> delegate;

- (void)setDriverCellState:(JSDriverCellState)newState;

@end
