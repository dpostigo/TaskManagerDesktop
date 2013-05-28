//
// Created by Daniela Postigo on 5/22/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSButton+DPUtils.h"


@implementation NSButton (DPUtils)


- (void) addTarget: (id) target action: (SEL) selector {
    self.target = target;
    self.action = selector;
}
@end