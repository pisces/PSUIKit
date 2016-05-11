//
//  PopUpViewManager.h
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSNavigationController.h"

typedef NS_ENUM(int, LeftBarButtonItemType) {
    LeftBarButtonItemTypeNone = 0,
    LeftBarButtonItemTypeHome = 1,
    LeftBarButtonItemTypeClose = 2,
    LeftBarButtonItemTypeCustom = 3
};

@interface PopUpViewManager : NSObject
+ (PopUpViewManager *)sharedInstance;
- (void)navigationPopWithViewController:(UIViewController *)viewController;
- (void)navigationPopWithViewController:(UIViewController *)viewController completion:(void (^)(void))completion;
- (void)navigationPopWithViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)navigationPopWithViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)navigationPopWithViewController:(UIViewController *)viewController customLeftBarButtonItemTitle:(NSString *)title animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)navigationPopWithViewController:(UIViewController *)viewController leftBarButtonItemType:(LeftBarButtonItemType)type animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)navigationPopWithViewController:(UIViewController *)viewController leftBarButtonItemType:(LeftBarButtonItemType)type customLeftBarButtonItemTitle:(NSString *)title animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)popWithViewController:(UIViewController *)viewController;
- (void)popWithViewController:(UIViewController *)viewController completion:(void (^)(void))completion;
- (void)popWithViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popWithViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
@end