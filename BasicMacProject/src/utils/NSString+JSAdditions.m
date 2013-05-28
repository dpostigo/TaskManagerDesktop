//
//  NSString+JSAdditions.m

#import "NSString+JSAdditions.h"

@implementation NSString (JSAdditions)

- (NSSize) sizeWithWidth:(float)width andFont:(NSFont *)font {
    
    NSSize size = NSMakeSize(width, FLT_MAX);
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:self];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:size];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:font
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    
    [layoutManager glyphRangeForTextContainer:textContainer];
    
    size.height = [layoutManager usedRectForTextContainer:textContainer].size.height;
    
    return size;
}

- (NSUInteger)indexInString:(NSString **)newString
{
    NSRange indexRange = [self rangeOfString:@"["];
    NSUInteger index = NSNotFound;
    *newString = self;
    if (indexRange.location != NSNotFound) {
        index = [[[self substringFromIndex:indexRange.location] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]] integerValue];
        *newString = [self substringToIndex:indexRange.location];
    }
    return index;
}

- (NSString *)stringByTrimmingIndex
{
    NSRange indexRange = [self rangeOfString:@"["];
    if (indexRange.location != NSNotFound)
        return [self substringToIndex:indexRange.location];
    else
        return self;
}

- (NSString *)stringByAppendingIndex:(NSUInteger)index
{
    if (index != NSNotFound) return [self stringByAppendingFormat:@"[%ld]",(unsigned long)index];
    return self;
}

@end
