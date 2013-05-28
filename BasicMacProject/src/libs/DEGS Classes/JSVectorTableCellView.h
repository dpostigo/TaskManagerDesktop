//
//  JSVectorTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTableCellView.h"
#import "JSColorfulTextField.h"
#import "JSTokenField.h"
#import "JSTextField.h"

typedef enum _JSVectorCellState {
    JSVectorCellInZeroState        = 0,
    JSVectorCellInFilenameState    = 1,
    JSVectorCellInCDATAState       = 2
} JSVectorCellState;

@interface JSVectorTableCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet NSPopUpButton *typeButton;
@property (strong) IBOutlet JSTokenField *componentsTokenField;
@property (strong) IBOutlet JSTokenField *dimensionsTokenField;
@property (strong) IBOutlet JSTokenField *initialBasisTokenField;
@property (strong) IBOutlet NSPopUpButton *initialisationButton;
@property (strong) IBOutlet JSTextField *filenameTextField;
@property (strong) IBOutlet JSTokenField *dependenciesTokenField;
@property (strong) IBOutlet JSTokenField *dependenciesBasisTokenField;
@property (strong) IBOutlet JSColorfulTextField *initialisationTextField;

@property (nonatomic, unsafe_unretained) id <JSTableCellViewDelegate> delegate;

- (void)setVectorCellState:(JSVectorCellState)newState;

@end
