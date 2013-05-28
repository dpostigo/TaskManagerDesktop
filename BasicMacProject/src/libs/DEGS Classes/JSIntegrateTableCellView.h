//
//  JSIntegrateTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 10/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTableCellView.h"
#import "JSTextField.h"

typedef enum _JSIntegrateCellState {
    JSIntegrateCellWithTolerance           = 0,
    JSIntegrateCellWithoutTolerance        = 1
} JSIntegrateCellState;

@interface JSIntegrateTableCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet NSPopUpButton *algorithmButton;
@property (strong) IBOutlet JSTextField *toleranceTextField;
@property (strong) IBOutlet JSTextField *stepsTextField;
@property (strong) IBOutlet JSTextField *intervalTextField;
@property (strong) IBOutlet JSTextField *samplesTextField;
@property (strong) IBOutlet NSButton *filtersButton;
@property (strong) IBOutlet NSButton *operatorsButton;
@property (strong) IBOutlet NSButton *computedVectorButton;

@property (nonatomic, unsafe_unretained) id <JSTableCellViewDelegate> delegate;

- (void)setIntegrateCellState:(JSIntegrateCellState)newState;

@end
