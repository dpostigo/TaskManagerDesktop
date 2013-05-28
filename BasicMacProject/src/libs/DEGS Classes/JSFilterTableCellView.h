//
//  JSFilterTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 10/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTableCellView.h"
#import "JSTokenField.h"
#import "JSColorfulTextField.h"
#import "JSTextField.h"

@interface JSFilterTableCellView : JSTableCellView
    
@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet JSTokenField *dependenciesTokenField;
@property (strong) IBOutlet JSTokenField *dependenciesBasisTokenField;
@property (strong) IBOutlet JSColorfulTextField *definitionTextField;

@end
