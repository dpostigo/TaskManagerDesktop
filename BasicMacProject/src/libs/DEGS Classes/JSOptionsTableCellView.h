//
//  JSOptionsTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 23/07/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "JSColorfulTextField.h"
#import "JSTextField.h"
#import "JSTableCellView.h"

@interface JSOptionsTableCellView : JSTableCellView

@property (strong) IBOutlet NSButton *haltNonFiniteButton;
@property (strong) IBOutlet NSButton *errorCheckButton;
@property (strong) IBOutlet NSButton *diagnosticsButton;
@property (strong) IBOutlet NSButton *bingButton;
@property (strong) IBOutlet NSButton *benchmarkButton;
@property (strong) IBOutlet NSButton *openMPButton;
@property (strong) IBOutlet NSButton *autoVectoriseButton;
@property (strong) IBOutlet NSPopUpButton *fftwPopUpButton;
@property (strong) IBOutlet NSPopUpButton *validationPopUpButton;
@property (strong) IBOutlet NSPopUpButton *precisionPopUpButton;
@property (strong) IBOutlet JSColorfulTextField *globalsTextField;
@property (strong) IBOutlet JSColorfulTextField *argumentsCDATATextField;
@property (strong) IBOutlet JSTextField *chunkedOutputTextField;
@property (strong) IBOutlet JSTextField *fftwThreadsTextField;

@end
