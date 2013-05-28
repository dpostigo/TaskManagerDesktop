//
//  JSPropagationDimensionTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 5/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSTableCellView.h"
#import "JSTextField.h"

@interface JSPropagationDimensionTableCellView : JSTableCellView

@property (strong) IBOutlet JSTextField *nameTextField;

@end
