//
//  JSDocument.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 19/02/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSDocument.h"
#import "INAppStoreWindow.h"
#import "JSPathbar.h"
#import "JSXMDS.h"
#import "JSAppDelegate.h"

#define SIDEBAR_COLOR [NSColor colorWithCalibratedRed:0.2f green:0.2f blue:0.23f alpha:1.0f]
#define SIDEBAR_NOISE_ALPHA 0.025f
#define SIDEBAR_SHADOW_BLUR_RADIUS 3.0f
#define SIDEBAR_SHADOW_OPACITY 0.1f
#define SIDEBAR_SHADOW_OFFSET_X -5.0f
#define SIDEBAR_SHADOW_OFFSET_Y 0.0f
#define SIDEBAR_WIDTH 100.0f

// constants for the look of the title bar
#define TITLE_BAR_HEIGHT 50.0f
#define PATHBAR_HEIGHT 30.0f

@interface JSDocument()

// Utility methods to set up the three main views of the app
- (void)setupSideBar;
- (void)setupWindow;
- (void)setupTreeController;

// utility method that push uncommited edit in the textfields to the model during save
- (void)updateModel;

// This is the model behind our app
@property (nonatomic, strong) JSXMDS *xmds;

// breadcrumb view that is part of the titleBar
@property (nonatomic, strong) JSPathbar *pathBar;

// handle the switching of view controllers from the menu items
- (IBAction)sectionMenuItemPressed:(id)sender;
- (IBAction)switchToPreviousSection:(id)sender;
- (IBAction)switchToNextSection:(id)sender;

// Method to validate the next and previous menuItems
- (BOOL)validateMenuItem:(NSMenuItem *)item;

// method to handle the dismissal of alert in response to compile errors
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

// path utility methods
- (NSString *)scriptDir;
- (NSString *)execPath;
- (NSString *)execName;
- (NSString *)filePath;
- (NSString *)filename;
- (NSString *)xsilFilePath;
- (NSString *)xsilFileName;

@end

@implementation JSDocument

# pragma mark - Setters and getters

- (JSXMDS *)xmds
{
    if (!_xmds) {
        _xmds = [[JSXMDS alloc] init];
    }
    return _xmds;
}

# pragma mark - View setup methods

- (void)setupSideBar
{
    // Set the background style of the sections view
    self.sideBar.backgroundColor = SIDEBAR_COLOR;
    self.sideBar.noiseOpacity = SIDEBAR_NOISE_ALPHA;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = NSMakeSize(SIDEBAR_SHADOW_OFFSET_X, SIDEBAR_SHADOW_OFFSET_Y);
    shadow.shadowBlurRadius = SIDEBAR_SHADOW_BLUR_RADIUS;
    shadow.shadowColor = [[NSColor blackColor] colorWithAlphaComponent:SIDEBAR_SHADOW_OPACITY];
    self.sideBar.shadow = shadow;
    
    // we want to be notified of changes in the current selection
    [self.sideBar setDelegate:self];
    
    // let's add a button for every main sections
    NSImage *buttonImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Intro" ofType: @"pdf"]];
    [self.sideBar addButtonWithTitle:@"Intro" image:buttonImage];
    buttonImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Features" ofType:@"pdf"]];
    [self.sideBar addButtonWithTitle:@"Features" image:buttonImage];
    buttonImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Geometry" ofType:@"pdf"]];
    [self.sideBar addButtonWithTitle:@"Geometry" image:buttonImage];
    buttonImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Vectors" ofType:@"pdf"]];
    [self.sideBar addButtonWithTitle:@"Vectors" image:buttonImage];
    buttonImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Sequence" ofType:@"pdf"]];
    [self.sideBar addButtonWithTitle:@"Sequence" image:buttonImage];
    buttonImage = [[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForResource:@"Output" ofType:@"pdf"]];
    [self.sideBar addButtonWithTitle:@"Output" image:buttonImage];
}

- (void)setupWindow
{
    // We use the INAppStoreWindow class to paint a bigger titleBar for the window and add to it our pathBar
    INAppStoreWindow *window = (INAppStoreWindow *)[[self windowControllers][0] window];
    window.titleBarHeight = TITLE_BAR_HEIGHT;
    window.centerTrafficLightButtons = NO;
    window.showsTitle = YES;
    JSPathbar *pathBar = [[JSPathbar alloc] initWithFrame:NSMakeRect(0.0, 0.0, 200.0, 30.0)];
    [pathBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.pathBar = pathBar;
    
    [window.titleBarView addSubview:self.pathBar];
    NSView *titleBarView = window.titleBarView;
    [titleBarView addConstraint:[NSLayoutConstraint constraintWithItem:_pathBar
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:titleBarView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f
                                                              constant:0.0f]];
    [titleBarView addConstraint:[NSLayoutConstraint constraintWithItem:_pathBar
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:titleBarView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0f
                                                              constant:0.0f]];
    [_pathBar addConstraint:[NSLayoutConstraint constraintWithItem:_pathBar
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:PATHBAR_HEIGHT]];
    NSString *documentTitle = [[self.displayName componentsSeparatedByString:@"."] objectAtIndex:0];
    
    // The first element of the pathBar is always the document title so we add it here
    [self.pathBar addItemWithTitle:documentTitle];
}

- (void)setupTreeController
{
    self.treeController.mainSectionNames = [NSArray arrayWithObjects:@"Preamble", @"Features", @"Geometry", @"Vectors", @"Sequence", @"Output", nil];
    self.treeController.xmds = self.xmds;
    self.treeController.delegate = self;
}

# pragma mark - Document initialisation

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"JSDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    self.treeController = [[JSTreeController alloc] init];
    
    // Load the main views and layout them with constraints to the window contentView
    [self.sideBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.sideBar addConstraint:[NSLayoutConstraint constraintWithItem:self.sideBar
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:SIDEBAR_WIDTH]];
    
    NSView *windowView = [[aController window] contentView];
    NSView *bottomBar = self.treeController.bottomBar;
    NSView *contentView = self.treeController.contentView;
    [windowView addSubview:bottomBar];
    [windowView addSubview:contentView];
    NSDictionary *group = NSDictionaryOfVariableBindings(_sideBar, bottomBar, contentView);
    [windowView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sideBar]|" options:0 metrics:nil views:group]];
    [windowView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView][bottomBar]|" options:0 metrics:nil views:group]];
    [windowView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sideBar][contentView]|" options:0 metrics:nil views:group]];
    [windowView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sideBar][bottomBar]|" options:0 metrics:nil views:group]];
    [windowView addConstraint:[NSLayoutConstraint constraintWithItem:windowView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0f
                                                            constant:600.0f]];
    
    // set up the views
    [self setupSideBar];
    [self setupWindow];
    [self setupTreeController];
    
    // we always start from the Preamble section
    [self.treeController switchToMainViewControllerWithTag:0];
    [self.sideBar selectButtonWithIndex:0];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

// saving method
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSXMLDocument *xmdsInXMLFormat = [self.xmds exportAsXMLDocument];
    // the NSXMLNodePrettyPrint option makes the output a bit more human readable
    return [xmdsInXMLFormat XMLDataWithOptions:NSXMLNodePrettyPrint];
}

// loading method
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    BOOL readSuccess = NO;
    NSXMLDocument *xmdsInXMLFormat = nil;
    xmdsInXMLFormat = [[NSXMLDocument alloc] initWithData:data options:NSXMLNodePreserveCDATA error:outError];
    
    if (xmdsInXMLFormat == nil) xmdsInXMLFormat = [[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyXML error:outError];
    if (xmdsInXMLFormat) {
        self.xmds = [[JSXMDS alloc] initFromXMLDocument:xmdsInXMLFormat];
        readSuccess = YES;
    }
    return readSuccess;
}

# pragma mark - Saving methods

// For the saving methods we want to push the state of any editing field editor onto the model before saving so this method gets called before every save
- (void)updateModel
{
    NSWindow *window = [[self windowControllers][0] window];
    id firstResponder = [window firstResponder];
    // We want to commit the changes only if we were editing a textfield
    if ([firstResponder isKindOfClass:[NSTextView class]]) {
        NSTextView *fieldEditor = (NSTextView *)firstResponder;
        id editingField = fieldEditor.delegate;
        
        // by momentarily stealing the first responder from the textfield we ensure that it's going to call the various didEndEditing delegate methods that are going to push any uncommited change to the model
        [window makeFirstResponder:nil];
        [window makeFirstResponder:editingField];
    }
}

- (void)saveDocument:(id)sender
{
    [self updateModel];
    [super saveDocument:sender];
}

- (void)saveDocumentAs:(id)sender
{
    [self updateModel];
    [super saveDocumentAs:sender];
}

- (void)saveDocumentTo:(id)sender
{
    [self updateModel];
    [super saveDocumentTo:sender];
}

# pragma mark - Section handling methods

// Delegate method from the sideBar
- (void)sidebar:(JSSideBar *)sidebar didChangeSelectionTo:(NSDictionary *)newSelection
{
    NSInteger newTag = [newSelection[@"index"] integerValue];
    [self.treeController switchToMainViewControllerWithTag:newTag];
}

# pragma mark - menu actions and method

- (IBAction)sectionMenuItemPressed:(id)sender
{
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    [self.treeController switchToMainViewControllerWithTag:menuItem.tag];
//    [self.sideBar selectButtonWithIndex:self.treeController.currentTag];
}

- (IBAction)switchToPreviousSection:(id)sender
{
    [self.treeController switchToPreviousViewController];
//    [self.sideBar selectButtonWithIndex:self.treeController.currentTag];
}

- (IBAction)switchToNextSection:(id)sender
{
    [self.treeController switchToNextViewController];
//    [self.sideBar selectButtonWithIndex:self.treeController.currentTag];
}

// Method to validate the next and previous menuItems
- (BOOL)validateMenuItem:(NSMenuItem *)item
{
    if ([item action] == @selector(switchToPreviousSection:) && (self.treeController.currentTag == 0)) {
        return NO;
    }
    if ([item action] == @selector(switchToNextSection:) && (self.treeController.currentTag == 5)) {
        return NO;
    }
    if ([item action] == @selector(runScript:) && ![[NSFileManager defaultManager] fileExistsAtPath:[self execPath]]) {
        return NO;
    }
    if ([item action] == @selector(processOutputOfScript:) && ![[NSFileManager defaultManager] fileExistsAtPath:[self xsilFilePath]]) {
        return NO;
    }
    return YES;
}

# pragma mark - compile and run methods

- (IBAction)runScript:(id)sender
{
    NSURL *execURL = [NSURL URLWithString:[self execPath]];
    JSAppDelegate *appDelegate = (JSAppDelegate *)[[NSApplication sharedApplication] delegate];
    [appDelegate runScriptAtURL:execURL error:NULL];
}

- (IBAction)compileScript:(id)sender
{
    [self saveDocument:nil];
    JSAppDelegate *appDelegate = (JSAppDelegate *)[[NSApplication sharedApplication] delegate];
    NSError *error = nil;
    if (![appDelegate compileScriptAtURL:[self fileURL] execURL:[NSURL URLWithString:[self execPath]] error:&error]) {
        NSString *errorElementXPath = [[error userInfo] objectForKey:@"elementXPath"];
        NSError *xPathError = nil;
        NSArray *pathObjects = [self.xmds objectPathForString:errorElementXPath error:&xPathError];
        if (xPathError) {
            NSLog(@"XPath error");
            // throw an exception
        } else {
            [self.treeController showCellForPathObjects:pathObjects];
            NSAlert *errorAlert = [NSAlert alertWithError:error];
            NSWindow *window = [[self windowControllers][0] window];
            [errorAlert beginSheetModalForWindow:window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        }
    } else {
        NSString *path = [[NSBundle mainBundle] pathForImageResource:@"DEGS"];
        NSData *appLogoData = nil;
        if (path) appLogoData = [[NSData alloc] initWithContentsOfFile:path];
        NSString *scriptName = [[[self fileURL] path] lastPathComponent];
        NSString *notificationDescription = [scriptName stringByAppendingString:@" compiled."];
        Class GAB = NSClassFromString(@"GrowlApplicationBridge");
        if([GAB respondsToSelector:@selector(notifyWithTitle:description:notificationName:iconData:priority:isSticky:clickContext:identifier:)])
            [GAB notifyWithTitle:@"Compilation Successful"
                     description:notificationDescription
                notificationName:(NSString *)CompilationSuccessfulNotification
                        iconData:appLogoData
                        priority:0
                        isSticky:NO
                    clickContext:nil
                      identifier:@"DEGS"];
    }
}

- (IBAction)processOutputOfScript:(id)sender
{
    NSURL *xsilURL = [NSURL URLWithString:[self xsilFilePath]];
    JSAppDelegate *appDelegate = (JSAppDelegate *)[[NSApplication sharedApplication] delegate];
    if ([(NSMenuItem *)sender tag]==0) [appDelegate processOutputOfScriptAtURL:xsilURL forFormat:JSXSILOutputForMatlab];
    else [appDelegate processOutputOfScriptAtURL:xsilURL forFormat:JSXSILOutputForMathematica];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    // This method is empty because we don't really need to do anything in response to alerts
}

# pragma mark - sliding view delegate methods

- (void)treeController:(JSTreeController *)treeController didShowViewController:(NSViewController *)viewController
{
    [self.pathBar removeAllItemsFromIndex:1];
    NSArray *newItems = [viewController.title componentsSeparatedByString:@"/"];
    for (NSString *item in newItems) [self.pathBar addItemWithTitle:item];
    
    // update the sideBar selection
    [self.sideBar selectButtonWithIndex:treeController.currentTag];
}

# pragma mark - path utility methods

- (NSString *)scriptDir
{
    return [[[self fileURL] path] stringByDeletingLastPathComponent];
}

- (NSString *)execPath
{
    if (self.xmds.preamble.name) return [[self scriptDir] stringByAppendingPathComponent:self.xmds.preamble.name];
    return nil;
}

- (NSString *)execName
{
    return self.xmds.preamble.name;
}

- (NSString *)filePath
{
    return [[self fileURL] path];
}

- (NSString *)filename
{
    return [[[self fileURL] path] lastPathComponent];
}

- (NSString *)xsilFilePath
{
    if (self.xmds.output.filename) return [[self scriptDir] stringByAppendingPathComponent:self.xmds.output.filename];
    else return [[self execPath] stringByAppendingPathExtension:@"xsil"];
}

- (NSString *)xsilFileName
{
    if (self.xmds.output.filename) return self.xmds.output.filename;
    else return [self.xmds.preamble.name stringByAppendingPathExtension:@"xsil"];
}

@end
