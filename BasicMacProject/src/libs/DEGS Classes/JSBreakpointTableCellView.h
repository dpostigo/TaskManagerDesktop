//
//  JSBreakpointTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 10/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTableCellView.h"
#import "JSTokenField.h"
#import "JSTextField.h"

@interface JSBreakpointTableCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet JSTextField *filenameTextField;
@property (strong) IBOutlet NSPopUpButton *formatButton;
@property (strong) IBOutlet JSTokenField *dependenciesTokenField;
@property (strong) IBOutlet JSTokenField *dependenciesBasisTokenField;

@end
