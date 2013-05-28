//
// Created by Daniela Postigo on 5/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "VeryBasicViewController.h"
#import "BasicListViewController.h"
#import "TableRowObject.h"
#import "OutlineSection.h"
#import "BasicTableRowView.h"
#import "BasicTableCellView.h"


@interface BasicOutlineViewController : BasicListViewController <NSOutlineViewDelegate, NSOutlineViewDataSource> {

    IBOutlet NSOutlineView *outline;
    BOOL allowsSelection;
}


@property(nonatomic, strong) NSOutlineView *outline;
@property(nonatomic) BOOL allowsSelection;
- (void) expand;
- (BasicTableRowView *) rowViewForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection;
- (BasicTableRowView *) rowViewForOutlineSection: (OutlineSection *) outlineSection;
- (CGFloat) heightForHeaderSection: (OutlineSection *) outlineSection;
- (CGFloat) heightForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection;
- (BasicTableCellView *) headerCellForOutlineSection: (OutlineSection *) outlineSection;
- (BasicTableCellView *) cellForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection;
- (void) configureCell: (BasicTableCellView *) tableCell forRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) outlineSection;
- (void) cellSelectedForRowObject: (TableRowObject *) rowObject outlineSection: (OutlineSection *) tableSection;
@end