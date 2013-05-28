//
//  JSSequence.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 8/11/12.
//
//

#import "JSNode.h"

@interface JSSequence : JSNode

@property NSUInteger cycles;

@property (readonly) NSArray *operations;
@property (readonly) NSUInteger numberOfElements;

- (void)addElement:(JSNode *)element;
- (void)addElement:(JSNode *)element atIndex:(NSUInteger)index;
- (void)deleteElementAtIndex:(NSUInteger)index;
- (void)deleteElementsAtIndexes:(NSIndexSet *)indexes;

- (id)initFromXML:(NSXMLElement *)anElement;
- (NSXMLElement *)exportAsXML;

@end
