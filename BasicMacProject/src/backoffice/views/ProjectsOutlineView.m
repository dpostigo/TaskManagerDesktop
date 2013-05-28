//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ProjectsOutlineView.h"
#import "SidebarTableCellView.h"
#import "Project.h"
#import "Model.h"


#define FIRST_SECTION @"Recent"
#define NO_ITEMS_KEY @"No current projects."


@implementation ProjectsOutlineView {
}


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {

        self.delegate = self;
        self.dataSource = self;

        topLevelItems = [NSArray arrayWithObjects: FIRST_SECTION, nil];

        childrenDictionary = [NSMutableDictionary new];
        [childrenDictionary setObject: [NSArray arrayWithObjects: NO_ITEMS_KEY, nil] forKey: FIRST_SECTION];

        [self sizeLastColumnToFit];
        [self reloadData];

        self.floatsGroupRows = NO;

        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration: 0];
        [self expandItem: nil expandChildren: YES];
        [NSAnimationContext endGrouping];
    }

    return self;
}






#pragma mark Model notifications


- (void) didSelectAddNewProject {
}

#pragma mark NSOutlineViewDelegate

- (void) outlineViewSelectionDidChange: (NSNotification *) notification {
    if ([self selectedRow] != -1) {
        NSString *item = [self itemAtRow: [self selectedRow]];

        if ([self parentForItem: item] != nil) {
            // Only change things for non-root items (root items can be selected, but are ignored)
        }
    }
}


- (id) outlineView: (NSOutlineView *) outlineView child: (NSInteger) index ofItem: (id) item {
    return [[self childrenForItem: item] objectAtIndex: index];
}


- (BOOL) outlineView: (NSOutlineView *) outlineView isItemExpandable: (id) item {
    if ([outlineView parentForItem: item] == nil) {
        return YES;
    } else {
        return NO;
    }
}


- (NSInteger) outlineView: (NSOutlineView *) outlineView numberOfChildrenOfItem: (id) item {
    return [[self childrenForItem: item] count];
}


- (BOOL) outlineView: (NSOutlineView *) outlineView isGroupItem: (id) item {
    return [topLevelItems containsObject: item];
}


- (BOOL) outlineView: (NSOutlineView *) outlineView shouldShowOutlineCellForItem: (id) item {
    // As an example, hide the "outline disclosure button" for FAVORITES. This hides the "Show/Hide" button and disables the tracking area for that row.
    if ([item isEqualToString: @"Favorites"]) {
        return NO;
    } else {
        return YES;
    }
}


- (NSView *) outlineView: (NSOutlineView *) outlineView viewForTableColumn: (NSTableColumn *) tableColumn item: (id) item {


    // For the groups, we just return a regular text view.
    if ([topLevelItems containsObject: item]) {
        NSTextField *result = [outlineView makeViewWithIdentifier: @"HeaderTextField" owner: self];
        // Uppercase the string value, but don't set anything else. NSOutlineView automatically applies attributes as necessary
        NSString *value = [item uppercaseString];
        [result setStringValue: value];
        return result;
    } else {
        // The cell is setup in IB. The textField and imageView outlets are properly setup.
        // Special attributes are automatically applied by NSTableView/NSOutlineView for the source list
        SidebarTableCellView *result = [outlineView makeViewWithIdentifier: @"MainCell" owner: self];
        result.textField.stringValue = item;




        // Setup the icon based on our section
        id parent = [outlineView parentForItem: item];
        NSInteger parentIndex = [topLevelItems indexOfObject: parent];
        NSInteger iconOffset = parentIndex % 4;

        result.imageView.image = [NSImage imageNamed: NSImageNameQuickLookTemplate];
        [result.button setHidden: NO];


        NSArray *array = [childrenDictionary objectForKey: parent];
        NSInteger index = [array indexOfObject: item];


        //
        result.button.tag = index;
        result.button.target = self;
        result.button.action = @selector(handleRemoveProject:);
        [result.button setImage: [NSImage imageNamed: NSImageNameRemoveTemplate]];
        // Make it appear as a button
        [[result.button cell] setHighlightsBy: NSPushInCellMask | NSChangeBackgroundCellMask];

        return result;
    }
}


- (void) handleRemoveProject: (id) sender {

    NSInteger tag = [sender tag];
    NSLog(@"tag = %li", tag);

    [[Model sharedModel] notifyDelegates: @selector(shouldRemoveProjectWithIndex:) object: [NSNumber numberWithInteger: tag]];
}

@end