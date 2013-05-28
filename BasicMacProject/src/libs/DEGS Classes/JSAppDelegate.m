//
//  JSAppDelegate.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 27/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSAppDelegate.h"
#import "JSAboutWindowController.h"
#import "JSShortcutsWindowController.h"

static NSString * const XMDSHasLaunchedBeforeKey = @"DEGSHasLaunched";

@interface JSAppDelegate ()

// window controllers for the auxilliary windows
@property (nonatomic, strong) JSAboutWindowController *aboutWindowController;
@property (nonatomic, strong) JSShortcutsWindowController *shortcutsWindowController;

// parsing of the xmds error output
- (NSError *)parseErrorOutput:(NSString *)errorOutput output:(NSString *)output;

// useful paths
@property (readonly) NSString *usrPath;
@property (readonly) NSString *xmdsLibraryPath;
@property (readonly) NSString *xmdsExecPath;
@property (readonly) NSString *xsil2graphics2ExecPath;

// utility method to edit the bash_profile and terminal files before running the terminal
- (TerminalApplication *)openXMDSTerminalForInstall:(BOOL)xmdsInstall shell:(BOOL)shell atPath:(NSString *)path;
- (NSString *)interpolateTerminalTemplateWithParameters:(NSDictionary *)parameters withSuffix:(NSString *)suffix;

// setup the environment dictionary for running xmds as a task
@property (nonatomic, strong, readonly) NSMutableDictionary *environmentForXMDS;

@end

@implementation JSAppDelegate

@synthesize environmentForXMDS = _environmentForXMDS;

# pragma mark - setters and getters

// credits window controller
- (JSAboutWindowController *)aboutWindowController
{
	if (!_aboutWindowController) {
        _aboutWindowController = [[JSAboutWindowController alloc] init];
    }
	return _aboutWindowController;
}

// shortcuts window controller
- (JSShortcutsWindowController *)shortcutsWindowController
{
    if (!_shortcutsWindowController) {
        _shortcutsWindowController = [[JSShortcutsWindowController alloc] init];
    }
    return _shortcutsWindowController;
}

- (NSString *)helpPageRootAddress
{
    return @"http://www.xmds.org/reference_elements.html";
}

- (NSString *)xmdsExecPath
{
    return [self.xmdsLibraryPath stringByAppendingString:@"/bin/xmds2"];
}

- (NSString *)xsil2graphics2ExecPath
{
    return [self.xmdsLibraryPath stringByAppendingString:@"/bin/xsil2graphics2"];
}

- (NSString *)usrPath
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/usr"];
}

- (NSString *)xmdsLibraryPath
{
    NSArray *searchURLs = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
    
    if (![searchURLs count]) {
        NSLog(@"Empty search paths when looking for the user library directory");
        return nil;
    }
    
    if ([searchURLs count] > 1)
        NSLog(@"Warning: More than one user library path found: %@", searchURLs);
    
    NSString *libraryPath = [(NSURL *)[searchURLs lastObject] path];
    
    NSString *xmdsLibraryPath = [libraryPath stringByAppendingPathComponent:@"DEGS"];
    
    NSError *error = nil;
    
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:xmdsLibraryPath
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error];
    
    if (!result || error) {
        NSLog(@"Unable to create path %@. Error: %@", xmdsLibraryPath, error);
        
        return nil;
    }
    
    return xmdsLibraryPath;
}

- (NSMutableDictionary *)environmentForXMDS
{
    if (!_environmentForXMDS) {
        _environmentForXMDS = [[[NSProcessInfo processInfo] environment] mutableCopy];
        
        //    DYLD_LIBRARY_PATH=${XMDS_USR}/lib:${DYLD_LIBRARY_PATH}
        NSString *DYDL_LIBRARY_PATH = [_environmentForXMDS objectForKey:@"DYLD_LIBRARY_PATH"];
        DYDL_LIBRARY_PATH = [NSString stringWithFormat:@"%@:%@", [self.usrPath stringByAppendingPathComponent:@"lib"], DYDL_LIBRARY_PATH];
        [_environmentForXMDS setObject:DYDL_LIBRARY_PATH forKey:@"DYDL_LIBRARY_PATH"];
        
        //    PATH=${XMDS_SUPPORT}/bin:${XMDS_USR}/bin:${PATH}
        NSString *PATH = [_environmentForXMDS objectForKey:@"PATH"];
        PATH = [NSString stringWithFormat:@"%@:%@:%@", [self.usrPath stringByAppendingPathComponent:@"bin"], [self.xmdsLibraryPath stringByAppendingPathComponent:@"bin"], PATH];
        [_environmentForXMDS setObject:PATH forKey:@"PATH"];
        
        //    XMDS_USR=${XMDS_USR}
        [_environmentForXMDS setObject:self.usrPath forKey:@"XMDS_USR"];
        
        //    HDF5_DIR=${XMDS_USR}
        [_environmentForXMDS setObject:self.usrPath forKey:@"HDF5_DIR"];
        
        //    OPAL_PREFIX=${XMDS_USR}
        [_environmentForXMDS setObject:self.usrPath forKey:@"OPAL_PREFIX"];
        
        //    XMDS_SUPPORT="${HOME}/Library/XMDS"
        [_environmentForXMDS setObject:self.xmdsLibraryPath forKey:@"XMDS_SUPPORT"];
        
        //    XMDS_USER_DATA="${HOME}/Library/XMDS/etc/xmds2"
        [_environmentForXMDS setObject:[self.xmdsLibraryPath stringByAppendingString:@"/etc/xmds2"] forKey:@"XMDS_USER_DATA"];
    }
    return _environmentForXMDS;
}

# pragma mark - Auxilliary windows
// put the auxilliary windows on screen

- (IBAction)showAboutWindow:(id)sender {
	[self.aboutWindowController showWindow:self];
}

- (IBAction)showShortcutsWindow:(id)sender {
	[self.shortcutsWindowController showWindow:self];
}

# pragma mark - delegate methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self loadGrowl];
    
    // if this is the first time the user launches the app we show him/her the shortcut window
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:XMDSHasLaunchedBeforeKey]) {
        [defaults setBool:YES forKey:XMDSHasLaunchedBeforeKey];
        
        // show the shortcuts
        [self.shortcutsWindowController showWindow:self];
        
        // install xmds
        [self openXMDSTerminalForInstall];
    }
}

# pragma mark - help methods

// we append the name of the element/section we want to show to the root address and pass it to the sharedWorkspace that will help the defult browser at that address
- (void)showHelpPageForElementWithName:(NSString *)elementName
{
    NSString *address = [self.helpPageRootAddress stringByAppendingFormat:@"#%@", elementName];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:address]];
}

//- (NSURL *)URLOfDefaultBrowser
//{
//    return [[NSWorkspace sharedWorkspace] URLForApplicationToOpenURL:[NSURL URLWithString:@"http://www.apple.com"]];
//}

# pragma mark - xmds compile methods

- (BOOL)processOutputOfScriptAtURL:(NSURL *)scriptURL forFormat:(JSXSILOutputFormat)format;
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:self.xsil2graphics2ExecPath];
    
    NSString *scriptDir = [[scriptURL path] stringByDeletingLastPathComponent];
    NSMutableDictionary *environment = self.environmentForXMDS;
    [environment setObject:scriptDir forKey:@"PWD"];
    [task setEnvironment:environment];
    
    [task setCurrentDirectoryPath:scriptDir];
    
    NSString *formatArgument;
    switch (format)
    {
        case JSXSILOutputForMathematica:
            formatArgument = @"-e";
            break;
        default:
            formatArgument = @"-m";
            break;
    }
    
    // We want to run xmds2 in debug mode to extract an XPath like string in order to lcate eventual errors in the JSXMDS tree
    NSArray *arguments = [NSArray arrayWithObjects:formatArgument, [scriptURL path], nil];
    [task setArguments:arguments];
    
    NSPipe *errorPipe = [NSPipe pipe];
    [task setStandardOutput:[NSPipe pipe]];
    [task setStandardError:errorPipe];
    [task setStandardInput:[NSPipe pipe]];
    
    NSFileHandle *errorFile = [errorPipe fileHandleForReading];
    
    [task launch];
    
    NSData *errorData = [errorFile readDataToEndOfFile];
    NSString *errorOutput = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    
    if (errorOutput.length) return NO;
    return YES;
}

- (BOOL)compileScriptAtURL:(NSURL *)scriptURL execURL:(NSURL *)execURL error:(NSError **)error
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:self.xmdsExecPath];
    
    NSString *scriptDir = [[scriptURL path] stringByDeletingLastPathComponent];
    NSMutableDictionary *environment = self.environmentForXMDS;
    [environment setObject:scriptDir forKey:@"PWD"];
    [task setEnvironment:environment];
    
    [task setCurrentDirectoryPath:scriptDir];
    
    // We want to run xmds2 in debug mode to extract an XPath like string in order to lcate eventual errors in the JSXMDS tree
    NSArray *arguments = [NSArray arrayWithObjects:@"--degs", [scriptURL path], nil];
    [task setArguments:arguments];
    
    NSPipe *outputPipe = [NSPipe pipe];
    NSPipe *errorPipe = [NSPipe pipe];
    [task setStandardOutput:outputPipe];
    [task setStandardError:errorPipe];
    [task setStandardInput:[NSPipe pipe]];
    
    NSFileHandle *outputFile = [outputPipe fileHandleForReading];
    NSFileHandle *errorFile = [errorPipe fileHandleForReading];
    
    [task launch];
    
    NSData *outputData = [outputFile readDataToEndOfFile];
    NSData *errorData = [errorFile readDataToEndOfFile];
    
    NSString *output = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    NSString *errorOutput = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    
    *error = [self parseErrorOutput:errorOutput output:output];
    if (*error) return NO;
    
    // compiling returned no error but we want to check also that the executable was created before returning yes
    if (![[NSFileManager defaultManager] fileExistsAtPath:[execURL path]]) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"Executable was not created."};
        *error = [NSError errorWithDomain:@"com.DEGS.compile" code:100 userInfo:userInfo];
        return NO;
    }
    
    return YES;
}

// here we break down the error output of the compilation and extract the relevant parts
- (NSError *)parseErrorOutput:(NSString *)errorOutput output:(NSString *)output
{
    // we firstly deal with compilation error
    // at the moment dealing with compilation error is very crude as we just pass the whole error output string back
    if ([output rangeOfString:@"Failed to compile"].location != NSNotFound) {
        
        // we first remove all the lines starting with the string @"waf" as they are python output we are not interested in
        NSArray *errorLines = [errorOutput componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSMutableArray *newErrorLines = [NSMutableArray array];
        for (NSString *line in errorLines) {
            if ([line rangeOfString:@"Waf"].location == NSNotFound) [newErrorLines addObject:line];
        }
        
        // we then add a description of the error
        [newErrorLines insertObject:@"Failed to compile" atIndex:0];
        
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : [newErrorLines componentsJoinedByString:@"\n"] };
        NSError *error = [NSError errorWithDomain:@"com.DEGS.compile" code:100 userInfo:userInfo];
        return  error;
    }
    
    // Anatomy of xmds2 error output
    // On top of the output are the warnings marked by the keyword "WARNING:"
    // Then comes the error marked by the keyword "ERROR:"
    // Then comes the line in the script generating the error, keyword "Error caused"
    // Then we have the XPath like string for the location of the error in the tree, keyword "In element:"
    // Finally comes a bunch of python details
    
    //    NSLog(@"%@",errorOutput);
    
    NSArray *pieces = [errorOutput componentsSeparatedByString:@"\n\n"];
    NSString *humanReadableErrorMessage = nil;
    NSString *errorKeyword = @"ERROR: ";
    NSString *pathString = nil;
    NSString *xpathKeyword = @"In element: ";
    for (NSString *piece in pieces) {
        if ([piece rangeOfString:errorKeyword options:NSLiteralSearch].location != NSNotFound) {
            humanReadableErrorMessage = [piece substringFromIndex:errorKeyword.length];
            // the error message output of xmds is padded with white spaces of the same length of the errorKeyword
            NSArray *errorLines = [humanReadableErrorMessage componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSMutableArray *newErrorLines = [NSMutableArray array];
            for (NSString *errorLine in errorLines) [newErrorLines addObject:[errorLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            if (newErrorLines.count) humanReadableErrorMessage = [newErrorLines componentsJoinedByString:@" "];
        }
        if ([piece rangeOfString:xpathKeyword options:NSLiteralSearch].location != NSNotFound) {
            pathString = [piece substringFromIndex:xpathKeyword.length];
            pathString = [pathString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSArray *pathComponents = [[pathString componentsSeparatedByString:@"-->"] mutableCopy];
            pathString = @"";
            
            // the first two elements in the xpath returned by xmds2 are "#document" and "simulation" which are not useful in our JSXMDS tree representation
            for (int i = 2; i < pathComponents.count; i++) pathString = [pathString stringByAppendingPathComponent:[pathComponents[i] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" '"]]];
        }
    }
    
    if (humanReadableErrorMessage) {
        NSMutableDictionary *userInfo = [@{ NSLocalizedDescriptionKey : humanReadableErrorMessage} mutableCopy];
        if (pathString) [userInfo setObject:pathString forKey:@"elementXPath"];
        NSError *error = [NSError errorWithDomain:@"com.DEGS.compile" code:100 userInfo:userInfo];
        return  error;
    }
    
    return nil;
}

# pragma mark - xmds run methods

- (BOOL)runScriptAtURL:(NSURL *)execURL error:(NSError **)error
{
    TerminalApplication *terminal = [self openXMDSTerminalForInstall:NO shell:YES atPath:[[execURL path] stringByDeletingLastPathComponent]];
    // opening the terminal app creates a new window that is prepended to the windows array and we want to run our script on that window
    [terminal doScript:[execURL path] in:terminal.windows[0]];
    return YES;
}

#pragma mark Terminal file writing

// this will install xmds in the user library path
- (void)openXMDSTerminalForInstall
{
    [self openXMDSTerminalForInstall:YES shell:NO atPath:nil];
}

- (TerminalApplication *)openXMDSTerminalForShell
{
    return [self openXMDSTerminalForInstall:NO shell:YES atPath:nil];
}

- (TerminalApplication *)openXMDSTerminalForInstallAndShell
{
    return [self openXMDSTerminalForInstall:YES shell:YES atPath:nil];
}

- (TerminalApplication *)openXMDSTerminalForShellAtPath:(NSString *)path
{
    return [self openXMDSTerminalForInstall:NO shell:YES atPath:path];
}

- (TerminalApplication *)openXMDSTerminalForInstallAndShellAtPath:(NSString *)path
{
    return [self openXMDSTerminalForInstall:YES shell:YES atPath:path];
}

- (TerminalApplication *)openXMDSTerminalForInstall:(BOOL)xmdsInstall shell:(BOOL)shell atPath:(NSString *)path
{
    if (!xmdsInstall && !shell) {
        NSLog(@"Error: trying to launch the terminal without install or shell switchs");
        return nil;
    }
    
    NSString *installSwitch = @"YES";
    if (!xmdsInstall) installSwitch = @"";
    NSString *shellSwitch = @"YES";
    if (!shell) shellSwitch = @"";
    
    NSMutableDictionary *parameters = [@{ @"${XMDS_INSTALL}" : installSwitch, @"${XMDS_SHELL}" : shellSwitch} mutableCopy];
    if (path) [parameters setObject:path forKey:@"${SCRIPT_PATH}"];
    
    NSString *terminalFilePath = [self interpolateTerminalTemplateWithParameters:[parameters copy]
                                                                      withSuffix:nil];
    
    TerminalApplication *terminal = [SBApplication applicationWithBundleIdentifier:@"com.apple.Terminal"];
    [terminal open:[NSArray arrayWithObject:[NSURL URLWithString:terminalFilePath]]];
    
    if (shell) return terminal;
    // if we run the terminal only in install mode, it closes after the installation is finished hence we don't need to return anything
    return nil;
}

- (NSString *)interpolateTerminalTemplateWithParameters:(NSDictionary *)parameters withSuffix:(NSString *)suffix
{
    if (!suffix)
        suffix = @"";
    
    NSString *terminalTemplatePath = [[NSBundle mainBundle] pathForResource:@"XMDS"
                                                                     ofType:@"terminal"];
    
    if (!terminalTemplatePath) {
        NSLog(@"Couldn't find XMDS.terminal");
        return FALSE;
    }
    
    NSString *bashProfilePath = [[NSBundle mainBundle] pathForResource:@"bash_profile" ofType:nil];
    
    if (!bashProfilePath) {
        NSLog(@"Couldn't find bash_profile");
        return FALSE;
    }
    
    NSError *error = nil;
    
    NSString *terminalContents = [NSString stringWithContentsOfFile:terminalTemplatePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];
    
    if (error) {
        NSLog(@"Couldn't read XMDS.terminal content. Error: %@", error);
        return FALSE;
    }
    
    NSString *bashProfileContents = [NSString stringWithContentsOfFile:bashProfilePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Couldn't read bash_profile content. Error: %@", error);
        return FALSE;
    }
    
    NSString *terminalFilename = [NSString stringWithFormat:@"XMDS%@.terminal", suffix];
    NSString *bashProfileFilename = [NSString stringWithFormat:@"bash_profile%@", suffix];
    
    NSString *terminalDestinationPath = [self.xmdsLibraryPath stringByAppendingPathComponent:terminalFilename];
    NSString *bashProfileDestinationPath = [self.xmdsLibraryPath stringByAppendingPathComponent:bashProfileFilename];
    
    // For the moment we assume we can use the developer tools from the root directory hence @"${DEVELOPER_DIR}" is substituted by an empty string
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          self.usrPath, @"${XMDS_USR}",
                                          @"", @"${DEVELOPER_DIR}",
                                          bashProfileDestinationPath, @"${RC_FILE}",
                                          @"XMDS", @"${NAME}",
                                          @"", @"${ADDITIONAL_COMMANDS}",
                                          nil];
    
    [allParameters addEntriesFromDictionary:parameters];
    
    for (NSString *key in allParameters) {
        terminalContents = [terminalContents stringByReplacingOccurrencesOfString:key
                                                                       withString:[allParameters objectForKey:key]];
        bashProfileContents = [bashProfileContents stringByReplacingOccurrencesOfString:key
                                                                             withString:[allParameters objectForKey:key]];
    }
    
    BOOL result = [bashProfileContents writeToFile:bashProfileDestinationPath
                                        atomically:YES
                                          encoding:NSUTF8StringEncoding
                                             error:&error];
    
    if (!result || error) {
        NSLog(@"Unable to write rc file to path: %@. Error: %@", bashProfileDestinationPath, error);
        return FALSE;
    }
    
    result = [terminalContents writeToFile:terminalDestinationPath
                                atomically:YES
                                  encoding:NSUTF8StringEncoding
                                     error:&error];
    
    if (!result || error) {
        NSLog(@"Unable to write terminal file to path: %@. Error: %@", terminalDestinationPath, error);
        return FALSE;
    }
    
    return terminalDestinationPath;
}

# pragma mark - Growl methods

- (void)loadGrowl
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [[mainBundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl"];
//    if(NSAppKitVersionNumber >= 1038)
//        path = [path stringByAppendingPathComponent:@"1.3"];
//    else
//        path = [path stringByAppendingPathComponent:@"1.2.3"];
    
    path = [path stringByAppendingPathComponent:@"Growl.framework"];
    NSBundle *growlFramework = [NSBundle bundleWithPath:path];
    if ([growlFramework load])
    {
        Class GAB = NSClassFromString(@"GrowlApplicationBridge");
		if([GAB respondsToSelector:@selector(setGrowlDelegate:)])
			[GAB performSelector:@selector(setGrowlDelegate:) withObject:self];
    } else {
        NSLog(@"ERROR: Growl failed to load");
    }
}

- (NSDictionary *)registrationDictionaryForGrowl
{
	NSDictionary *notificationsWithDescriptions = [NSDictionary dictionaryWithObjectsAndKeys:
												   NotifierCompilationSuccessfulHumanReadableDescription, CompilationSuccessfulNotification,
												   nil];
	
	NSArray *allNotifications = [notificationsWithDescriptions allKeys];
	
	//Don't turn the sync notiifications on by default; they're noisy and not all that interesting.
	NSMutableArray *defaultNotifications = [allNotifications mutableCopy];
	[defaultNotifications removeObject:NotifierSyncStartedNotification];
	[defaultNotifications removeObject:NotifierSyncFinishedNotification];
	
	NSDictionary *regDict = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"DEGS", GROWL_APP_NAME,
							 allNotifications, GROWL_NOTIFICATIONS_ALL,
							 defaultNotifications,	GROWL_NOTIFICATIONS_DEFAULT,
							 notificationsWithDescriptions,	GROWL_NOTIFICATIONS_HUMAN_READABLE_NAMES,
							 nil];
    
	return regDict;
}

@end
