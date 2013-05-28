//
//  JSPreambleTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 23/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSExpandingTextField.h"
#import "JSTableCellView.h"

@interface JSPreambleTableCellView : JSTableCellView

@property (nonatomic, strong) IBOutlet JSTextField *nameTextField;
@property (nonatomic, strong) IBOutlet JSExpandingTextField *authorTextField;
@property (nonatomic, strong) IBOutlet JSExpandingTextField *descriptionTextField;

@end
