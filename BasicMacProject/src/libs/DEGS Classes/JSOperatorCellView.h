//
//  JSOperatorCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 23/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSTableCellView.h"
#import "JSTokenField.h"
#import "JSColorfulTextField.h"
#import "JSTextField.h"

typedef enum _JSOperatorCellState {
    JSOperatorCellFunctionState            = 0,
    JSOperatorCellDifferentialState        = 1
} JSOperatorCellState;

@interface JSOperatorCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet NSPopUpButton *kindButton;
@property (strong) IBOutlet NSPopUpButton *typeButton;
@property (strong) IBOutlet NSButton *constantCheckBox;
@property (strong) IBOutlet JSTokenField *namesTokenField;
@property (strong) IBOutlet JSColorfulTextField *definitionTextField;

@property (nonatomic, unsafe_unretained) id <JSTableCellViewDelegate> delegate;

- (void)setOperatorCellState:(JSOperatorCellState)newState;

@end
