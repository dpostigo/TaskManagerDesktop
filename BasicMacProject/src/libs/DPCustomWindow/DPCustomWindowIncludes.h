//
// Created by Daniela Postigo on 5/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@protocol DPCustomWindowIncludes <NSObject>


#if __has_feature(objc_arc)
#define INAppStoreWindowCopy nonatomic, strong
#define INAppStoreWindowRetain nonatomic, strong
#else
#define INAppStoreWindowCopy nonatomic, copy
#define INAppStoreWindowRetain nonatomic, retain
#endif



#define IN_RUNNING_LION (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_6)
#define IN_COMPILING_LION __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070

@end