//
//  NSString+JSAddictions.h

#import <Foundation/Foundation.h>

@interface NSString (JSAdditions)

- (NSSize) sizeWithWidth:(float)width andFont:(NSFont *)font;

// working with indexed strings of the form "elementName[index]"

// extract the index and indirectly return the bare elementName
// if only the index is needed pass NULL as newString
- (NSUInteger)indexInString:(NSString **)newString;

// return the bare elementName
- (NSString *)stringByTrimmingIndex;

// recombine a string and an index
- (NSString *)stringByAppendingIndex:(NSUInteger)index;

@end
