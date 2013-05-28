//
//  JSAboutWindowController.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 27/03/13.
//  Copyright (c) 2013 Jacopo Sabbatini. All rights reserved.
//

#import "JSAboutWindowController.h"

@interface JSAboutWindowController ()

@property (nonatomic, readonly) NSString *applicationNameString;
@property (nonatomic, readonly) NSString *applicationVersionString;
@property (nonatomic, readonly) NSString *applicationBuildNumberString;
@property (nonatomic, readonly) NSString *applicationCopyrightString;

@end

@implementation JSAboutWindowController

- (id)init {
    self = [super initWithWindowNibName:@"JSAboutWindowController"];
    return self;
}

- (void)awakeFromNib {
	NSString *versionFormat = NSLocalizedString(@"Version %@ (%@)", nil);
	NSString *versionString = [NSString stringWithFormat:versionFormat, self.applicationVersionString, self.applicationBuildNumberString];
	self.applicationNameLabel.stringValue = self.applicationNameString;
	[self.applicationVersionLabel.cell setPlaceholderString:versionString];
	[self.applicationCopyrightLabel.cell setPlaceholderString:self.applicationCopyrightString];
}

#pragma mark - Properties

- (NSString *)applicationNameString {
	return [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
}

- (NSString *)applicationVersionString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)applicationBuildNumberString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)applicationCopyrightString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSHumanReadableCopyright"];
}

#pragma mark - User actions

// In the window we have some buttons to acknowledge the authors of the some extra code used thourghout the app.
// When the user clicks on a button we grab the title of the button and open the default web browser at the address relevant for the code
- (IBAction)modulesClick:(id)sender {
    NSURL *url;
    NSString *senderTitle = [(NSButton *)sender title];
    if ([senderTitle isEqualToString:@"INAppStoreWindow"]) url = [NSURL URLWithString:@"http://github.com/indragiek/INAppStoreWindow"];
    else if ([senderTitle isEqualToString:@"XMDS"]) url = [NSURL URLWithString:@"http://www.xmds.org/"];
    else if ([senderTitle isEqualToString:@"Cocoa Categories"]) url = [NSURL URLWithString:@"http://github.com/faceleg/Cocoa-Categories"];
    else if ([senderTitle isEqualToString:@"EDSidebar"]) url = [NSURL URLWithString:@"http://github.com/erndev/EDSidebar"];
    else if ([senderTitle isEqualToString:@"KGNoise"]) url = [NSURL URLWithString:@"http://github.com/kgn/KGNoise"];
    else if ([senderTitle isEqualToString:@"UliKit"]) url = [NSURL URLWithString:@"http://github.com/uliwitness/UKSyntaxColoredTextDocument"];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

@end
