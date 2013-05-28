//
// Created by Daniela Postigo on 5/4/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicFullWindow.h"


@interface AppWindow : BasicFullWindow <NSWindowDelegate>


- (void) openSidebar: (id) sender;
- (IBAction) toggleSidebar: (id) sender;
- (IBAction) toggleBottomView: (id) sender;
- (void) closeBottomView: (id) sender;
- (void) resetBottomView: (id) sender;
- (void) resetMainView: (id) sender;
- (void) resetSidebarView: (id) sender;
@end