//
//  JSOperatorsCell.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 12/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSColorfulTextField.h"
#import "JSTableCellView.h"
#import "JSTokenField.h"
#import "JSTextField.h"

@interface JSOperatorsCell : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet JSTokenField *dimensionsTokenField;
@property (strong) IBOutlet NSButton *operatorButton;
@property (strong) IBOutlet JSTokenField *integrationVectorTokenField;
@property (strong) IBOutlet JSTokenField *dependenciesTokenField;
@property (strong) IBOutlet JSColorfulTextField *equationTextField;

@end
