//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicTableCellView.h"


@implementation BasicTableCellView {
}




#pragma mark UITableView


#pragma mark IBActions


#pragma mark Callbacks




@synthesize textLabel;
@synthesize detailTextLabel;
@synthesize button;
@synthesize captionLabel;
@synthesize backgroundView;

@synthesize secondButton;

@synthesize accessoryButton;

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        self.backgroundView = [[BasicBackgroundView alloc] initWithFrame: self.bounds];
        backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview: backgroundView];
        [self addSubview: textLabel];
        [self addSubview: detailTextLabel];
        [self addSubview: button];
        [self addSubview: captionLabel];
    }

    return self;
}


//- (NSTextField *) textLabel {
//    return (textLabel == nil ? self.textField : textLabel);
//}
//
//- (NSTextField *) textField {
//    return super.textField == nil ? textLabel : super.textField;
//}

//
//- (void) setBackgroundView: (BasicBackgroundView *) backgroundView1 {
//    if (backgroundView != nil) [backgroundView removeFromSuperview];
//
//    backgroundView = backgroundView1;
//
//    //    [self addSubview: backgroundView];
//    //    for (NSView *subview in array) {
//    //        [self addSubview: subview];
//    //    }
//}

@end