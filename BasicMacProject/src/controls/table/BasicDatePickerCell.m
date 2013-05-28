//
// Created by Daniela Postigo on 5/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicDatePickerCell.h"


@implementation BasicDatePickerCell {
}


- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
    }

    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];

    NSLog(@"button = %@", button);
}

- (IBAction) handleDateButton: (id) sender {

    NSDatePicker *datePicker = [[NSDatePicker alloc] init];
    [self addSubview: datePicker];
}

@end