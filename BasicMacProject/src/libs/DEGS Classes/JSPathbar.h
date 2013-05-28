//
//  JSPathbar.h
//  JSPathbar

#import <Cocoa/Cocoa.h>

@protocol JSPathbarDelegate <NSPathControlDelegate>

@end

@interface JSPathbar : NSPathControl

- (void)insertItemWithTitle:(NSString *)title atIndex:(NSUInteger)index;
- (void)addItemWithTitle:(NSString *)title;
- (void)removeItemAtIndex:(NSUInteger)index;
- (void)removeLastItem;
- (void)removeAllItems;
- (void)removeAllItemsFromIndex:(NSUInteger)index;

@end
