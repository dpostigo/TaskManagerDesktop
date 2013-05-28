//
// Created by Daniela Postigo on 5/7/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicArrayViewController.h"


@interface BasicCollectionViewController : BasicArrayViewController {
    IBOutlet NSCollectionView *collection;
}


@property(nonatomic, strong) NSCollectionView *collection;
@end