//
// Created by Daniela Postigo on 5/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RowObject.h"


@interface TableRowObject : RowObject {
    NSString *textLabel;
    NSString *detailTextLabel;
    NSImage *image;
    NSImage *selectedImage;
}


@property(nonatomic, retain) NSString *textLabel;
@property(nonatomic, retain) NSString *detailTextLabel;
@property(nonatomic, strong) NSImage *image;
@property(nonatomic, strong) NSImage *selectedImage;
- (id) initWithTextLabel: (NSString *) aTextLabel;
- (id) initWithTextLabel: (NSString *) aTextLabel detailTextLabel: (NSString *) aDetailTextLabel cellIdentifier: (NSString *) aCellIdentifier;
- (id) initWithTextLabel: (NSString *) aTextLabel detailTextLabel: (NSString *) aDetailTextLabel image: (NSImage *) anImage;
- (id) initWithTextLabel: (NSString *) aTextLabel detailTextLabel: (NSString *) aDetailTextLabel cellIdentifier: (NSString *) aCellIdentifier image: (NSImage *) anImage;
- (id) initWithTextLabel: (NSString *) aTextLabel cellIdentifier: (NSString *) aCellIdentifier;
- (id) initWithTextLabel: (NSString *) aTextLabel cellIdentifier: (NSString *) aCellIdentifier content: (id) aContent;
- (id) initWithTextLabel: (NSString *) aTextLabel cellIdentifier: (NSString *) aCellIdentifier content: (id) aContent image: (NSImage *) anImage;
- (id) initWithTextLabel: (NSString *) aTextLabel detailTextLabel: (NSString *) aDetailTextLabel cellIdentifier: (NSString *) aCellIdentifier content: (id) aContent image: (NSImage *) anImage;
- (id) initWithTextLabel: (NSString *) aTextLabel content: (id) aContent;
- (id) initWithTextLabel: (NSString *) aTextLabel image: (NSImage *) anImage;
- (id) initWithTextLabel: (NSString *) aTextLabel image: (NSImage *) anImage cellIdentifier: (NSString *) aCellIdentifier;
- (id) initWithTextLabel: (NSString *) aTextLabel image: (NSImage *) anImage selectedImage: (NSImage *) aSelectedImage;
- (id) initWithTextLabel: (NSString *) aTextLabel image: (NSImage *) anImage content: (id) aContent;
- (id) initWithTextLabel: (NSString *) aTextLabel detailTextLabel: (NSString *) aDetailTextLabel;

- (id) initWithContent: (id) aContent cellIdentifier: (NSString *) aCellIdentifier;
@end