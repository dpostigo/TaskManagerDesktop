//
//  JSCompuedVectorTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 4/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTableCellView.h"
#import "JSColorfulTextField.h"
#import "JSTokenField.h"
#import "JSTextField.h"

@interface JSComputedVectorTableCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet NSPopUpButton *typeButton;
@property (strong) IBOutlet JSTokenField *componentsTokenField;
@property (strong) IBOutlet JSTokenField *dimensionsTokenField;
@property (strong) IBOutlet JSTokenField *dependenciesTokenField;
@property (strong) IBOutlet JSTokenField *dependenciesBasisTokenField;
@property (strong) IBOutlet JSColorfulTextField *evaluationTextField;

@end
