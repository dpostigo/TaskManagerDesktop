//
//  JSDriver.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 31/07/12.
//
//

#import "JSDriver.h"
#import "JSXMDS.h"

@implementation JSDriver

# pragma mark - Setters and getters

// since the first of the type options is "none" a new driver element is initialised in the trivial and harmless none state
-(NSArray *)typeOptions
{
    return @[@"none", @"distributed-mpi", @"multi-path", @"mpi-multi-path"];
}

- (void)setType:(NSUInteger)type
{
    if (type <= ([self.typeOptions count]-1)) {
        _type = type;
    }
}

# pragma mark - Initialiser and exporter

- (NSXMLElement *)exportAsXML
{
    // we only export the driver element if it's non trivial
    if ([(self.typeOptions)[self.type] isEqualToString:@"none"]) return nil;
    
    NSXMLElement *driverNode = [NSXMLElement elementWithName:@"driver"];

    NSString *driverType = (self.typeOptions)[self.type];
    [driverNode addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:driverType]];
    
    if (((self.type == 2) || (self.type == 3)) && (_paths)) [driverNode addAttribute:[NSXMLNode attributeWithName:@"paths" stringValue:self.paths]];
    return driverNode;
}

- (id)initFromXML:(NSXMLElement *)anElement
{
    if ( self = [super init] ) {
        if ([anElement attributeForName:@"name"]) {
            NSString *driverName = [[anElement attributeForName:@"name"] stringValue];
            self.type = [self.typeOptions indexOfObject:driverName];
        }
        
        if ([anElement attributeForName:@"paths"]) self.paths = [[anElement attributeForName:@"paths"] stringValue];
    }
    return self;
}

# pragma mark - Utility method

- (NSString *)description
{
    NSString *title = @"Driver";
    if (![self.parent isKindOfClass:[JSXMDS class]]) title = [NSString stringWithFormat:@"%@/%@", [self.parent description], title];
    return title;
}


@end
