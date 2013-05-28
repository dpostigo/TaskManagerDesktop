//
//  JSGroupTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 16/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTableCellView.h"
#import "JSColorfulTextField.h"
#import "JSTokenField.h"
#import "JSTextField.h"

@interface JSGroupTableCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet JSTokenField *basisTokenField;
@property (strong) IBOutlet NSButton *initialSampleCheckBox;
@property (strong) IBOutlet JSTokenField *momentsTokenField;
@property (strong) IBOutlet JSTokenField *dependenciesTokenField;
@property (strong) IBOutlet JSColorfulTextField *definitionTextField;
@property (strong) IBOutlet NSButton *computedVectorsButton;
@property (strong) IBOutlet NSButton *operatorButton;

@end
