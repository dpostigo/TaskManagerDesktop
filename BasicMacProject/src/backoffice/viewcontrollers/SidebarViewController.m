//
// Created by Daniela Postigo on 5/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SidebarViewController.h"
#import "SaveDataOperation.h"
#import "GetTasksOperation.h"
#import "GetContactsProcess.h"
#import "NSTextField+Utils.h"
#import "BasicWhiteView.h"
#import "NSColor+Utils.h"
#import "NSImage+Utils.h"
#import "GetServiceItemsOperation.h"


@implementation SidebarViewController {
    NSMutableDictionary *labelsDictionary;
    NSArray *jobModeLabels;
}


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
    }

    return self;
}

- (void) loadView {
    [super loadView];

    self.allowsSelection = YES;
    outline.enclosingScrollView.width += 10;

    jobModeLabels = [NSArray arrayWithObjects: @"Potential", @"Quote", @"Active", nil];
    [self expand];


    [_queue addOperation: [[GetTasksOperation alloc] init]];
    [_queue addOperation: [[GetContactsProcess alloc] init]];
}

//- (void) viewDidAppear: (BOOL) animated {
//    [super viewDidAppear: animated];
//
//    [self selectCurrentTaskMode];
//    [_queue addOperation: [[GetTasksOperation alloc] init]];
//    [_queue addOperation: [[GetContactsProcess alloc] init]];
//}




#pragma mark BasicOutlineViewController

- (void) prepareDataSource {
    [super prepareDataSource];

    [self.dataSource removeAllObjects];
    OutlineSection *tableSection = [[OutlineSection alloc] initWithTitle: @"Focus"];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Due" image: [NSImage imageNamed: @"due-icon"] selectedImage: [NSImage newImageFromResource: @"due-icon-selected.png"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Today" image: [NSImage imageNamed: @"today-icon"] selectedImage: [NSImage newImageFromResource: @"today-icon-selected.png"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"Observing" image: [NSImage imageNamed: @"observing-icon"] selectedImage: [NSImage newImageFromResource: @"observing-icon-selected.png"]]];
    [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: @"My Tasks" image: [NSImage imageNamed: @"mytasks-icon"] selectedImage: [NSImage newImageFromResource: @"mytasks-icon-selected.png"]]];
    [self.dataSource addObject: tableSection];

    if ([_model.tasks count] > 0) {
        tableSection = [[OutlineSection alloc] initWithTitle: @"Potential"];
        NSArray *potentialJobs = _model.potentialJobs;
        for (Job *job in potentialJobs) [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: job.title image: [NSImage imageNamed: @"job-icon.png"] content: job]];
        [self.dataSource addObject: tableSection];

        tableSection = [[OutlineSection alloc] initWithTitle: @"Quote"];
        NSArray *quoteJobs = _model.quoteJobs;
        for (Job *job in quoteJobs) [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: job.title image: [NSImage imageNamed: @"job-icon.png"] content: job]];
        [self.dataSource addObject: tableSection];

        tableSection = [[OutlineSection alloc] initWithTitle: @"Active"];
        NSArray *activeJobs = _model.activeJobs;
        for (Job *job in activeJobs) [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: job.title image: [NSImage imageNamed: @"job-icon.png"] content: job]];
        [self.dataSource addObject: tableSection];

        tableSection = [[OutlineSection alloc] initWithTitle: @"Artists"];
        NSArray *artists = _model.artists;
        for (User *artist in artists) [tableSection.rows addObject: [[TableRowObject alloc] initWithTextLabel: artist.title image: [NSImage imageNamed: @"assignee-icon.png"] content: artist]];
        [self.dataSource addObject: tableSection];
    }
}

- (CGFloat) heightForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection {
    return 22;
}

- (BasicTableCellView *) headerCellForOutlineSection: (OutlineSection *) outlineSection {

    BasicTableCellView *headerCell = [outline makeViewWithIdentifier: @"HeaderCell" owner: self];
    headerCell.textLabel.stringValue = [outlineSection.title uppercaseString];
    //    headerCell.textLabel.shadowColor = [NSColor colorWithWhite: 0.0 alpha: 0.5];
    //    headerCell.textLabel.shadowOffset = CGSizeMake(0, 2);
    //    headerCell.backgroundView = [[BasicWhiteView alloc] init];

    //    headerCell.backgroundView.backgroundColor = [outlineSection.title isEqualToString: @"Focus"] ? [NSColor blackColor] : [NSColor clearColor];
    return headerCell;
    return [super headerCellForOutlineSection: outlineSection];
}

- (void) configureCell: (BasicTableCellView *) tableCell forRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection {
    [super configureCell: tableCell forRowObject: rowObject outlineSection: outlineSection];

    BasicTableCellView *cell = (BasicTableCellView *) tableCell;
    cell.imageView.image = rowObject.image;
    //    cell.backgroundView.backgroundColor = [outlineSection.title isEqualToString: @"Focus"] ? [NSColor blackColor]: [NSColor clearColor];

    //        cell.imageView.highlightedImage = rowObject.selectedImage;


    cell.textLabel.stringValue = rowObject.textLabel;
    cell.textLabel.shadowColor = [NSColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(0, 1);
    //    cell.textLabel.highlightedTextColor = [UIColor blackColor];

    //        cell.selectedBackgroundView = [[BasicWhiteView alloc] init];
    //        cell.selectedBackgroundView.backgroundColor = [NSColor colorWithWhite: 0.85 alpha: 1.0];

    //    ((BOSidebarLabel *) cell.textLabel).highlightedShadowColor = [NSColor whiteColor];
    //    [cell rasterize];

    if (![outlineSection.title isEqualToString: @"Focus"]) {
        //            cell.imageView.highlightedImage = [UIImage newImageFromResource: @"job-icon-selected.png"];
    }
}

- (void) cellSelectedForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection {
    [super cellSelectedForRowObject: rowObject outlineSection: outlineSection];

    if ([outlineSection.title isEqualToString: @"Focus"]) {
        NSString *taskListMode = rowObject.textLabel;
        [_model notifyDelegates: @selector(taskListModeDidChange:) object: taskListMode];
    } else if ([outlineSection.title isEqualToString: TASKLISTMODE_ARTISTS]) {
        User *artist = rowObject.content;
        _model.currentArtist = artist;
        [_model notifyDelegates: @selector(taskListModeDidChange:) object: TASKLISTMODE_ARTISTS];
    } else {
        NSLog(@"Selected job.");
        Job *job = rowObject.content;
        _model.currentJob = job;
        [_model notifyDelegates: @selector(taskListModeDidChange:) object: TASKLISTMODE_JOBS];
    }
}


//- (void) didSelectRowObject: (TableRowObject *) rowObject inSection: (TableSection *) tableSection {
//
//    if ([tableSection.title isEqualToString: @"Focus"]) {
//        NSString *taskListMode = rowObject.textLabel;
//        [_model notifyDelegates: @selector(taskListModeDidChange:) object: taskListMode];
//    } else if ([tableSection.title isEqualToString: TASKLISTMODE_ARTISTS]) {
//        User *artist = rowObject.content;
//        _model.currentArtist = artist;
//        [_model notifyDelegates: @selector(taskListModeDidChange:) object: TASKLISTMODE_ARTISTS];
//    } else {
//        NSLog(@"Selected job.");
//        Job *job = rowObject.content;
//        _model.currentJob = job;
//        [_model notifyDelegates: @selector(taskListModeDidChange:) object: TASKLISTMODE_JOBS];
//    }
//}



#pragma mark IBActions

- (IBAction) handleSettingsButton: (id) sender {
}


#pragma mark Callbacks


- (void) loginSucceeded: (NSDictionary *) dictionary {
    [_queue addOperation: [[SaveDataOperation alloc] init]];
    [_queue addOperation: [[GetTasksOperation alloc] init]];
    [_queue addOperation: [[GetContactsProcess alloc] init]];
}

- (void) getTasksSucceeded {
    [self prepareDataSource];
    [outline reloadData];
    [outline expandItem: nil expandChildren: YES];
    [_queue addOperation: [[SaveDataOperation alloc] init]];
    [self selectCurrentTaskMode];
}

- (void) selectCurrentTaskMode {
   // NSLog(@"_model.currentTaskMode = %@", _model.currentTaskMode);

    NSUInteger rowIndex = 3;
    TableSection *tableSection = [dataSource objectAtIndex: 0];
    for (TableRowObject *rowObject in tableSection.rows) {
        if ([rowObject.textLabel isEqualToString: _model.currentTaskMode]) {
            rowIndex = [tableSection.rows indexOfObject: rowObject];
        }
    }

    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: rowIndex inSection: 0];
    //    [table selectRowAtIndexPath: indexPath animated: NO scrollPosition: UITableViewScrollPositionNone];
}

@end