//
//  JSAppDelegate.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 27/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

// The app delegate is responsible for putting the credits and shortcut windows on screen
// It also responds to calls for the help page

#import <Foundation/Foundation.h>
#import "Terminal.h"
#import <Growl/Growl.h>
//
#define CompilationSuccessfulNotification                       @"Compilation Successful"
#define NotifierSyncStartedNotification                         @"Sync started"
#define NotifierSyncFinishedNotification                        @"Sync finished"
#define NotifierCompilationSuccessfulHumanReadableDescription	NSLocalizedString(@"Compilation Successful", "")

typedef enum _JSXSILOutputFormat {
    JSXSILOutputForMatlab         = 0,
    JSXSILOutputForMathematica    = 1
} JSXSILOutputFormat;

@interface JSAppDelegate : NSObject <NSApplicationDelegate, GrowlApplicationBridgeDelegate>

// to show the help we open the default browser at the address of the guide
// the helpPageRootAddress property hold the root address of the help. At the moment this property returns the web address but if we want to hold the help pages locally we could change this to the local file path of the help page
@property (readonly) NSString *helpPageRootAddress;

// The app delegate opens the default browser at a specified section or element, indicated by the elementName argument, of the help page 
- (void)showHelpPageForElementWithName:(NSString *)elementName;

// compile a script
- (BOOL)compileScriptAtURL:(NSURL *)scriptURL execURL:(NSURL *)execURL error:(NSError **)error;

// run script
- (BOOL)runScriptAtURL:(NSURL *)execURL error:(NSError **)error;

// run xsil2graphics2 on the script result
- (BOOL)processOutputOfScriptAtURL:(NSURL *)scriptURL forFormat:(JSXSILOutputFormat)format;

// open a specialised terminal windows for xmds
- (void)openXMDSTerminalForInstall;
- (TerminalApplication *)openXMDSTerminalForShell;
- (TerminalApplication *)openXMDSTerminalForInstallAndShell;
- (TerminalApplication *)openXMDSTerminalForShellAtPath:(NSString *)path;
- (TerminalApplication *)openXMDSTerminalForInstallAndShellAtPath:(NSString *)path;

@end
