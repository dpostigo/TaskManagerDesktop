//
//  JSArgumentTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 14/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSTableCellView.h"
#import "JSTextField.h"

@interface JSArgumentTableCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;
@property (strong) IBOutlet JSTextField *defaultValueTextField;
@property (strong) IBOutlet NSPopUpButton *typeButton;

@end
