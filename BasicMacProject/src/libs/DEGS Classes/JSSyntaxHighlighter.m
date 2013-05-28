//
//  JSSyntaxHighlighter.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 5/08/12.
//
//

#import "JSSyntaxHighlighter.h"
#import "NSArray+Color.h"
#import "NSScanner+SkipUpToCharset.h"

// default text color used in the syntax highlighter
#define DEFAULT_HIGHLIGHT_COLOR [NSColor blackColor]

#define TD_SYNTAX_COLORING_MODE_ATTR @"SyntaxColoringMode" // Anything we colorize gets this attribute. The value is an NSString holding the component name.

@interface JSSyntaxHighlighter ()

// dictionary holding the identifier to color
@property (nonatomic, strong) NSDictionary *syntaxDefinition;

@end

@implementation JSSyntaxHighlighter

- (NSDictionary *)syntaxDefinition
{
    if (!_syntaxDefinition) {
        _syntaxDefinition = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cpp" ofType: @"plist"]];
    }
    return _syntaxDefinition;
}

-(NSDictionary *)defaultTextAttributes
{
	return @{NSFontAttributeName: [NSFont systemFontOfSize:13.0f]};
}

- (NSRange)rangeToProcessChange:(NSTextStorage *)textStorage
{
    NSRange range = [textStorage editedRange];
    NSInteger changeInLen = [textStorage changeInLength];
	BOOL textLengthMayHaveChanged = NO;
    
	if ( changeInLen <= 0 )
		textLengthMayHaveChanged = YES;
	
	//	Try to get chars around this to recolor any identifier we're in:
	if ( textLengthMayHaveChanged )
	{
		if( range.location > 0 )
			range.location--;
		if( (range.location + range.length +2) < [textStorage length] )
			range.length += 2;
		else if( (range.location + range.length +1) < [textStorage length] )
			range.length += 1;
	}
    
	NSRange currRange = range;
    
	// Perform the syntax coloring:
	if ( range.length > 0 )
	{
		NSRange	effectiveRange;
		NSString *rangeMode;
		
		rangeMode = [textStorage attribute: TD_SYNTAX_COLORING_MODE_ATTR
                                   atIndex: currRange.location
                            effectiveRange: &effectiveRange];
		
		NSUInteger x = range.location;
		
		/* TODO: If we're in a multi-line comment and we're typing a comment-end
         character, or we're in a string and we're typing a quote character,
         this should include the rest of the text up to the next comment/string
         end character in the recalc. */
		
		// Scan up to prev line break:
		while( x > 0 )
		{
			unichar theCh = [[textStorage string] characterAtIndex: x];
			if( theCh == '\n' || theCh == '\r' )
				break;
			--x;
		}
		
		currRange.location = x;
		
		// Scan up to next line break:
		x = range.location + range.length;
		
		while( x < [textStorage length] )
		{
			unichar theCh = [[textStorage string] characterAtIndex: x];
			if( theCh == '\n' || theCh == '\r' )
				break;
			++x;
		}
		
		currRange.length = x - currRange.location;
		
		// Open identifier, comment etc.? Make sure we include the whole range.
		if( rangeMode != nil )
			currRange = NSUnionRange( currRange, effectiveRange );
		
        return currRange;
	}
    return NSMakeRange(NSNotFound, 0);
}

- (NSAttributedString *)recolorString:(NSString *)string
{
    NSDictionary *defaultStyles = [self defaultTextAttributes];
    NSMutableAttributedString *stringToColor = [[NSMutableAttributedString alloc] initWithString:string attributes:defaultStyles];
    [self recolor:stringToColor];
    return [stringToColor copy];
}

- (NSAttributedString *)recolorString:(NSAttributedString *)string forRange:(NSRange)range
{
    NSInteger diff = [string length] - (range.location + range.length);
    if ( diff < 0 ) range.length += diff; // just making sure that the passed range isn't beyond the string length
    
    NSDictionary *defaultStyles = [self defaultTextAttributes];
    
    // extract the substring we want to recolor from the passed string, apply the defaultStyle to it and then recolor
    NSMutableAttributedString *stringToColor = [[NSMutableAttributedString alloc] initWithString:[[string string] substringWithRange:range] attributes:defaultStyles];
    [self recolor:stringToColor];
    
    // replace the part of the string that was passed in with the string we have just recolored
    NSMutableAttributedString *resultString = [string mutableCopy];
    [resultString replaceCharactersInRange:range withAttributedString:stringToColor];
    return [resultString copy];
}

- (void)recolor:(NSMutableAttributedString *)coloredString
{
    // Load colors and fonts to use from preferences:
    // Load our dictionary which contains info on coloring this language:
    NSEnumerator *componentsEnumerator = [self.syntaxDefinition[@"Components"] objectEnumerator];
    
    if( componentsEnumerator == nil )  return;	// No list of components to colorize?
    
    // Loop over all available components:
    NSDictionary *currentComponent = nil;
    //    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    while( (currentComponent = [componentsEnumerator nextObject]) )
    {
        NSString *componentType = currentComponent[@"Type"];
        NSString *componentName = currentComponent[@"Name"];
        NSColor *color = [currentComponent[@"Color"] colorValue];
        if (!color) color = DEFAULT_HIGHLIGHT_COLOR;
                
        if( [componentType isEqualToString:@"BlockComment"] )
        {
            [self colorCommentsFrom:currentComponent[@"Start"]
                                 to:currentComponent[@"End"]
                           inString:coloredString
                          withColor:color
                            andMode:componentName];
        }
        else if( [componentType isEqualToString:@"OneLineComment"] )
        {
            [self colorOneLineComment:currentComponent[@"Start"]
                             inString:coloredString
                            withColor:color
                              andMode:componentName];
        }
        else if( [componentType isEqualToString:@"String"] )
        {
            [self colorStringsFrom:currentComponent[@"Start"]
                                to:currentComponent[@"End"]
                          inString:coloredString
                         withColor:color
                           andMode:componentName
                     andEscapeChar:currentComponent[@"EscapeChar"]];
        }
        else if( [componentType isEqualToString:@"Tag"] )
        {
            [self colorTagFrom:currentComponent[@"Start"]
                            to:currentComponent[@"End"]
                      inString:coloredString
                     withColor:color
                       andMode:componentName
                  exceptIfMode:currentComponent[@"IgnoredComponent"]];
        }
        else if( [componentType isEqualToString:@"Keywords"] )
        {
            NSArray *identifiers = currentComponent[@"Keywords"];
            if( !identifiers && [_delegate respondsToSelector: @selector(userIdentifiersForKeywordComponentName:)] )
                identifiers = [_delegate userIdentifiersForKeywordComponentName:componentName];
            if( identifiers )
            {
                NSCharacterSet *identifiersCharset = nil;
                NSString *currentIdentifier = nil;
                NSString *charsetString = currentComponent[@"Charset"];
                if( charsetString ) identifiersCharset = [NSCharacterSet characterSetWithCharactersInString:charsetString];
                
                NSEnumerator *iterator = [identifiers objectEnumerator];
                while( currentIdentifier = [iterator nextObject] )
                    [self colorIdentifier:currentIdentifier
                                 inString:coloredString
                                withColor:color
                                  andMode:componentName
                                  charset:identifiersCharset];
            }
        }
    }
}

- (void)colorCommentsFrom:(NSString *)startCh to:(NSString *)endCh inString:(NSMutableAttributedString *)coloredString
                withColor:(NSColor *)col andMode:(NSString *)attr
{
    NSScanner *scanner = [NSScanner scannerWithString:[coloredString string]];
    NSDictionary *styles = [self textAttributesForComponentName:attr color:col];
    
    while( ![scanner isAtEnd] )
    {
        NSUInteger	startOffs, endOffs;
        
        // Look for start of multi-line comment:
        [scanner scanUpToString:startCh intoString:nil];
        startOffs = [scanner scanLocation];
        if( ![scanner scanString:startCh intoString:nil] )
            return;
        
        // Look for associated end-of-comment marker:
        [scanner scanUpToString:endCh intoString:nil];
        [scanner scanString:endCh intoString:nil];
        endOffs = [scanner scanLocation];
        
        // Now mess with the string's styles:
        [coloredString setAttributes:styles range:NSMakeRange( startOffs, endOffs - startOffs )];
    }
}

-(void)	colorOneLineComment:(NSString *)startCh inString:(NSMutableAttributedString *)coloredString
                  withColor:(NSColor *)col andMode:(NSString *)attr
{
    NSScanner *scanner = [NSScanner scannerWithString:[coloredString string]];
    NSDictionary *styles = [self textAttributesForComponentName:attr color:col];
    
    while( ![scanner isAtEnd] )
    {
        NSUInteger	startOffs, endOffs;
        
        // Look for start of one-line comment:
        [scanner scanUpToString:startCh intoString:nil];
        startOffs = [scanner scanLocation];
        if( ![scanner scanString:startCh intoString:nil] )
            return;
        
        // Look for associated line break:
        if( ![scanner skipUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\r"]] )
            return;
        
        endOffs = [scanner scanLocation];
        
        // Now mess with the string's styles:
        [coloredString setAttributes:styles range:NSMakeRange( startOffs, endOffs - startOffs )];
    }
}

-(void)	colorStringsFrom:(NSString *)startCh to:(NSString *)endCh inString:(NSMutableAttributedString *)coloredString
               withColor:(NSColor *)col andMode:(NSString *)attr andEscapeChar:(NSString *)stringEscapeCharacter
{
    NSScanner *scanner = [NSScanner scannerWithString:[coloredString string]];
    NSDictionary *styles = [self textAttributesForComponentName:attr color:col];
    BOOL isEndChar = NO;
    unichar	escChar = '\\';
    
    if ( stringEscapeCharacter )
    {
        if( [stringEscapeCharacter length] != 0 )
            escChar = [stringEscapeCharacter characterAtIndex:0];
    }
    
    while( ![scanner isAtEnd] )
    {
        NSUInteger startOffs, endOffs;
        isEndChar = NO;
        
        // Look for start of string:
        [scanner scanUpToString:startCh intoString:nil];
        startOffs = [scanner scanLocation];
        if( ![scanner scanString:startCh intoString:nil] )
            return;
        
        while( !isEndChar && ![scanner isAtEnd] )	// Loop until we find end-of-string marker or our text to color is finished:
        {
            [scanner scanUpToString:endCh intoString:nil];
            if( ([stringEscapeCharacter length] == 0) || [[coloredString string] characterAtIndex:([scanner scanLocation]-1)] != escChar )	// Backslash before the end marker? That means ignore the end marker.
                isEndChar = YES;	// A real one! Terminate loop.
            if( ![scanner scanString:endCh intoString:nil] )	// But skip this char before that.
                return;
        }
        
        endOffs = [scanner scanLocation];
        
        // Now mess with the string's styles:
        [coloredString setAttributes:styles range:NSMakeRange( startOffs, endOffs - startOffs )];
    }
}

-(void)	colorTagFrom:(NSString *)startCh to:(NSString *)endCh inString:(NSMutableAttributedString *)coloredString
           withColor:(NSColor *)col andMode:(NSString *)attr exceptIfMode:(NSString *)ignoreAttr
{
    NSScanner *scanner = [NSScanner scannerWithString:[coloredString string]];
    NSDictionary *styles = [self textAttributesForComponentName:attr color:col];
    
    while( ![scanner isAtEnd] )
    {
        NSUInteger	startOffs, endOffs;
        
        // Look for start of one-line comment:
        [scanner scanUpToString:startCh intoString:nil];
        startOffs = [scanner scanLocation];
        if( startOffs >= [coloredString length] )
            return;
        NSString *scMode = [coloredString attributesAtIndex:startOffs effectiveRange:nil][TD_SYNTAX_COLORING_MODE_ATTR];
        if( ![scanner scanString:startCh intoString:nil] )
            return;
        
        // If start lies in range of ignored style, don't colorize it:
        if( ignoreAttr != nil && [scMode isEqualToString:ignoreAttr] )
            continue;
        
        // Look for matching end marker:
        while( ![scanner isAtEnd] )
        {
            // Scan up to the next occurence of the terminating sequence:
            [scanner scanUpToString:endCh intoString:nil];
            
            // Now, if the mode of the end marker is not the mode we were told to ignore,
            //  we're finished now and we can exit the inner loop:
            endOffs = [scanner scanLocation];
            if( endOffs < [coloredString length] )
            {
                scMode = [coloredString attributesAtIndex:endOffs effectiveRange:nil][TD_SYNTAX_COLORING_MODE_ATTR];
                [scanner scanString:endCh intoString:nil];   // Also skip the terminating sequence.
                if( ignoreAttr == nil || ![scMode isEqualToString: ignoreAttr] )
                    break;
            }
            
            // Otherwise we keep going, look for the next occurence of endCh and hope it isn't in that style.
        }
        
        endOffs = [scanner scanLocation];
        
        // Now mess with the string's styles:
        [coloredString setAttributes:styles range:NSMakeRange( startOffs, endOffs - startOffs )];
    }
}

-(void)	colorIdentifier:(NSString *)ident inString:(NSMutableAttributedString *)coloredString
              withColor:(NSColor *)col andMode:(NSString *)attr charset:(NSCharacterSet *)cset
{
    NSScanner *scanner = [NSScanner scannerWithString:[coloredString string]];
    NSDictionary *styles = [self textAttributesForComponentName:attr color:col];
    NSUInteger startOffs = 0;
    
    // Skip any leading whitespace chars, somehow NSScanner doesn't do that:
    if( cset )
    {
        while( startOffs < [[coloredString string] length] )
        {
            if( [cset characterIsMember:[[coloredString string] characterAtIndex:startOffs]] )
                break;
            startOffs++;
        }
    }
    
    [scanner setScanLocation:startOffs];
    
    while( ![scanner isAtEnd] )
    {
        // Look for start of identifier:
        [scanner scanUpToString:ident intoString: nil];
        startOffs = [scanner scanLocation];
        if( ![scanner scanString:ident intoString:nil] )
            return;
        
        if( startOffs > 0 )	// Check that we're not in the middle of an identifier:
        {
            // Alphanum character before identifier start?
            if( [cset characterIsMember: [[coloredString string] characterAtIndex:(startOffs -1)]] )  // If charset is NIL, this evaluates to NO.
                continue;
        }
        
        if( (startOffs + [ident length] +1) < [coloredString length] )
        {
            // Alphanum character following our identifier?
            if( [cset characterIsMember:[[coloredString string] characterAtIndex:(startOffs + [ident length])]] )  // If charset is NIL, this evaluates to NO.
                continue;
        }
        
        // Now mess with the string's styles:
        [coloredString setAttributes:styles range:NSMakeRange( startOffs, [ident length] )];
    }
}

- (NSDictionary *)textAttributesForComponentName:(NSString *)attribute color:(NSColor *)color
{
	NSDictionary *localStyles = [_delegate respondsToSelector:@selector(textAttributesForComponentName:color:)] ? [_delegate textAttributesForComponentName:attribute color:color] : nil;
	NSMutableDictionary *styles = [[self defaultTextAttributes] mutableCopy];
	if( localStyles ) [styles addEntriesFromDictionary:localStyles];
	else styles[NSForegroundColorAttributeName] = color;
	
	// Make sure partial recoloring works:
	styles[TD_SYNTAX_COLORING_MODE_ATTR] = attribute;
	
	return styles;
}

@end
