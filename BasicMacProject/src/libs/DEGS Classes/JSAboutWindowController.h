//
//  JSAboutWindowController.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 27/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JSAboutWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *applicationNameLabel;
@property (weak) IBOutlet NSTextField *applicationVersionLabel;
@property (weak) IBOutlet NSTextField *applicationCopyrightLabel;

@end
