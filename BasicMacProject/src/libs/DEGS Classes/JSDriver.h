//
//  JSDriver.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 31/07/12.
//
//

#import <Foundation/Foundation.h>
#import "JSNode.h"

@interface JSDriver : JSNode

@property (nonatomic) NSUInteger type;
@property (readonly, nonatomic, strong) NSArray *typeOptions;
@property (nonatomic, strong) NSString *paths;

- (NSXMLElement *)exportAsXML;
- (id)initFromXML:(NSXMLElement *)anElement;

@end
