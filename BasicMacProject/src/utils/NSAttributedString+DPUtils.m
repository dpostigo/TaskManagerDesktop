//
//  NSAttributedString+DPUtils.m
//  TaskManager
//
//  Created by Daniela Postigo on 6/6/13.
//  Copyright 2013 Dani Postigo. All rights reserved.
//

#import "NSAttributedString+DPUtils.h"


@implementation NSAttributedString (DPUtils)


+ (NSAttributedString *) attributedString: (NSString *) string textColor: (NSColor *) textColor {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject: textColor forKey: NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString: string attributes: attributes];
}
@end