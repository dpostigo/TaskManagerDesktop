#import <Cocoa/Cocoa.h>
#import "SidebarOutlineView.h"
#import "INAppStoreWindow.h"


@class BasicView;


@interface OldAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate, NSSplitViewDelegate> {

    IBOutlet BasicView *backgroundView;
    IBOutlet BasicView *sidebarBackground;
    IBOutlet SidebarOutlineView *sidebarOutlineView;

    IBOutlet NSSplitView *splitView;
}


@property(assign) IBOutlet INAppStoreWindow *window;

@property(assign) IBOutlet NSPanel *sheet;
@property(assign) IBOutlet NSButton *centerFullScreen;
@property(assign) IBOutlet NSButton *centerTrafficLight;
@property(assign) IBOutlet NSButton *verticalTrafficLight;
@property(assign) IBOutlet NSSlider *fullScreenRightMarginSlider;
@property(assign) IBOutlet NSSlider *trafficLightLeftMargin;
@property(assign) IBOutlet NSSlider *trafficLightSeparation;
@property(assign) IBOutlet NSButton *showsBaselineSeparator;
@property(nonatomic, retain) NSMutableArray *windowControllers;

- (IBAction) createWindowController: (id) sender;
- (IBAction) sidebarMenuDidChange: (id) sender;

@end
