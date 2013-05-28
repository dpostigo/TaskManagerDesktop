//
// Created by Daniela Postigo on 5/16/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicTextFieldCellView.h"


@implementation BasicTextFieldCellView {
}


- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
    }

    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
    [self.textField setEditable: YES];
}

- (BOOL) control: (NSControl *) control textShouldBeginEditing: (NSText *) fieldEditor {
    return YES;
}

@end