//
//  BasicCell.h
//  TaskManager
//
//  Created by Daniela Postigo on 5/27/13.
//  Copyright 2013 Dani Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BasicImageCell : NSImageCell {

    CGFloat cornerRadius;
    NSShadow *shadow;

    NSColor *borderColor;
    CGFloat borderWidth;

}

@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic, strong) NSShadow *shadow;
@property(nonatomic, strong) NSColor *borderColor;
@property(nonatomic) CGFloat borderWidth;
@end