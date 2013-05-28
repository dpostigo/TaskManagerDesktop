//
//  TransverseDimensionCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 22/06/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTokenField.h"
#import "JSTableCellView.h"
#import "JSTextField.h"

typedef enum _JSTransverseDimensionCellState {
    JSTransverseDimensionCellNormalState         = 1,
    JSTransverseDimensionCellHermiteGaussState   = 0,
    JSTransverseDimensionCellBesselState         = 2
} JSTransverseDimensionCellState;

@interface JSTransverseDimensionCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet JSTextField *domainStartTextField;
@property (strong) IBOutlet JSTextField *domainEndTextField;
@property (strong) IBOutlet NSPopUpButton *typeButton;
@property (strong) IBOutlet JSTextField *latticeTextField;
@property (strong) IBOutlet NSPopUpButton *transformButton;
@property (strong) IBOutlet JSTokenField *aliasesTokenField;
@property (strong) IBOutlet JSTextField *volumePrefactorTextField;
@property (strong) IBOutlet JSTextField *spectralLatticeTextField;
@property (strong) IBOutlet JSTextField *lengthScaleTextField;
@property (strong) IBOutlet JSTextField *orderTextField;

@property (nonatomic, unsafe_unretained) id <JSTableCellViewDelegate> delegate;

- (void)setTransverseDimensionCellState:(JSTransverseDimensionCellState)newState;

@end
