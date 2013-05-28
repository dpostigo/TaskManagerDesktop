//
//  JSNoiseVectorTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTableCellView.h"
#import "JSTokenField.h"
#import "JSTextField.h"

typedef enum _JSNoiseVectorCellState {
    JSNoiseVectorCellWithoutMeanState        = 1,
    JSNoiseVectorCellWithMeanState       = 0
} JSNoiseVectorCellState;

@interface JSNoiseVectorTableCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet NSPopUpButton *typeButton;
@property (strong) IBOutlet JSTokenField *componentsTokenField;
@property (strong) IBOutlet JSTokenField *dimensionsTokenField;
@property (strong) IBOutlet JSTokenField *initialBasisTokenField;
@property (strong) IBOutlet NSPopUpButton *methodButton;
@property (strong) IBOutlet NSPopUpButton *kindButton;
@property (strong) IBOutlet JSTextField *seedTextField;
@property (strong) IBOutlet JSTextField *meanTextField;

@property (nonatomic, unsafe_unretained) id <JSTableCellViewDelegate> delegate;

- (void)setNoiseVectorCellState:(JSNoiseVectorCellState)newState;

@end
