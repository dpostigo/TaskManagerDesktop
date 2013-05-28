//
//  JSSyntaxHighlighter.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 5/08/12.
//
//

#import <Foundation/Foundation.h>

@class JSSyntaxHighlighter;

@protocol JSSyntaxHighlighterDelegate <NSObject>

@optional

// Won't get called if you override syntaxDefinitionDictionaryForTextViewController:.
-(NSString *)syntaxDefinitionFilenameForTextViewController:(JSSyntaxHighlighter *)sender;

-(NSDictionary *)syntaxDefinitionDictionaryForTextViewController:(JSSyntaxHighlighter *)sender;

// If you can parse your code & provide a list of identifiers the user uses, you can provide this method to tell the editor about them.
-(NSArray *)userIdentifiersForKeywordComponentName:(NSString *)inModeName;

// If you don't just want a color, provide an NSAttributedString attributes dictionary here.
-(NSDictionary *)textAttributesForComponentName:(NSString *)inModeName
                                          color:(NSColor *)inColor;

@end

@interface JSSyntaxHighlighter : NSObject

@property (nonatomic, unsafe_unretained) id <JSSyntaxHighlighterDelegate> delegate;

// we use a textStorage to extract the modified range in a fieldEditor and compute a range we need to recolor (usually the line)
- (NSRange)rangeToProcessChange:(NSTextStorage *)textStorage;

// recolor a whole string
- (NSAttributedString *)recolorString:(NSString *)string;

// partly recolor a string
- (NSAttributedString *)recolorString:(NSAttributedString *)string forRange:(NSRange)range;

@end
