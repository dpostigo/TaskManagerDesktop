//
//  JSPathbar.m
//  JSPathbar

#import "JSPathbar.h"
#import "JSPathbarCell.h"

@implementation JSPathbar

+ (Class)cellClass
{
    return [JSPathbarCell class];
}

- (void)awakeFromNib
{
    [self setPathStyle:NSPathStyleNavigationBar];
    [self setFocusRingType:NSFocusRingTypeNone];
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setPathStyle:NSPathStyleNavigationBar];
        [self setFocusRingType:NSFocusRingTypeNone];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setPathStyle:NSPathStyleNavigationBar];
        [self setFocusRingType:NSFocusRingTypeNone];
    }
    return self;
}

- (NSMutableArray *)mutablePathComponentCells
{
    return [self.pathComponentCells mutableCopy];
}

- (void)addItemWithTitle:(NSString *)title
{
    [self insertItemWithTitle:title atIndex:self.pathComponentCells.count];
}

- (void)insertItemWithTitle:(NSString *)title atIndex:(NSUInteger)index
{
    NSMutableArray *cells = [self mutablePathComponentCells];
    JSPathbarComponentCell *cell = [[JSPathbarComponentCell alloc] initTextCell:title];
    [cell setBackgroundStyle:NSBackgroundStyleDark];
    [cells insertObject:cell atIndex:index];
    
    self.pathComponentCells = cells;
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    NSMutableArray *cells = [self mutablePathComponentCells];
    if (index < cells.count) [cells removeObjectAtIndex:index];
    
    self.pathComponentCells = cells;
}

- (void)removeLastItem
{
    [self removeItemAtIndex:(self.pathComponentCells.count - 1)];
}

- (void)removeAllItems
{
    self.pathComponentCells = [NSArray array];
}

- (void)removeAllItemsFromIndex:(NSUInteger)index
{
    NSMutableArray *cells = [self mutablePathComponentCells];
    for (unsigned long i = cells.count-1; i >= index; i--) [cells removeObjectAtIndex:i];
    self.pathComponentCells = cells;
}

@end
