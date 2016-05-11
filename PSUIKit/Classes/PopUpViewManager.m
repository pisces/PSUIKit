//
//  PopUpViewManager.m
//  PSUIKit
//
//  Created by Steve Kim on 2013. 12. 31..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import "PopUpViewManager.h"
#import "PSUIKit.h"

@implementation PopUpViewManager

// ================================================================================================
//  Class Variables
// ================================================================================================

static PopUpViewManager *uniqueInstance;

// ================================================================================================
//  Class Methods
// ================================================================================================

+ (PopUpViewManager *)sharedInstance {
    @synchronized (self) {
        if (!uniqueInstance)
            uniqueInstance = [[PopUpViewManager alloc] init];
    }
    return uniqueInstance;
}

// ================================================================================================
//  Public
// ================================================================================================

- (void)popWithViewController:(UIViewController *)viewController
{
    [self popWithViewController:viewController completion:nil];
}

- (void)popWithViewController:(UIViewController *)viewController completion:(void (^)(void))completion
{
    [self popWithViewController:viewController animated:YES completion:completion];
}

- (void)popWithViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self popWithViewController:viewController animated:animated completion:nil];
}

- (void)popWithViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self presentModalViewController:viewController parent:viewController.topMostController animated:animated completion:completion];
}

- (void)navigationPopWithViewController:(UIViewController *)viewController
{
    [self navigationPopWithViewController:viewController completion:nil];
}

- (void)navigationPopWithViewController:(UIViewController *)viewController completion:(void (^)(void))completion
{
    [self navigationPopWithViewController:viewController leftBarButtonItemType:LeftBarButtonItemTypeNone animated:YES completion:completion];
}

- (void)navigationPopWithViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self navigationPopWithViewController:viewController animated:animated completion:nil];
}

- (void)navigationPopWithViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self navigationPopWithViewController:viewController leftBarButtonItemType:LeftBarButtonItemTypeNone animated:animated completion:completion];
}

- (void)navigationPopWithViewController:(UIViewController *)viewController customLeftBarButtonItemTitle:(NSString *)title animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self navigationPopWithViewController:viewController leftBarButtonItemType:LeftBarButtonItemTypeCustom customLeftBarButtonItemTitle:title animated:animated completion:completion];
}

- (void)navigationPopWithViewController:(UIViewController *)viewController leftBarButtonItemType:(LeftBarButtonItemType)type animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self navigationPopWithViewController:viewController leftBarButtonItemType:type customLeftBarButtonItemTitle:[PSUIKit localizedStringWithKey:@"Done"] animated:animated completion:completion];
}

- (void)navigationPopWithViewController:(UIViewController *)viewController leftBarButtonItemType:(LeftBarButtonItemType)type customLeftBarButtonItemTitle:(NSString *)title animated:(BOOL)animated completion:(void (^)(void))completion
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [self presentModalViewController:viewController parent:viewController.topMostController animated:animated completion:completion];
        return;
    }
    
    Class class = viewController.modalTransitionStyle == UIModalTransitionStyleCoverVertical ? [MoveModalNavigationController class] : [PSNavigationController class];
    UINavigationController *navigationController = [[class alloc] initWithRootViewController:viewController];
    UIBarButtonItem *leftBarButtonItem = nil;
    
    if (type == LeftBarButtonItemTypeHome)
        leftBarButtonItem = [[UIApplication sharedApplication].theme homeBarButtonItemWithTarget:viewController action:@selector(close)];
    else if (type == LeftBarButtonItemTypeClose)
        leftBarButtonItem = [[UIApplication sharedApplication].theme closeBarButtonItemWithTarget:viewController action:@selector(close)];
    else if (type == LeftBarButtonItemTypeCustom)
        leftBarButtonItem = [[UIApplication sharedApplication].theme leftBarButtonItemWithTitle:title target:viewController action:@selector(close)];
    
    [viewController.navigationItem addLeftBarButtonItem:leftBarButtonItem];
    [self presentModalViewController:navigationController parent:viewController.topMostController animated:animated completion:completion];
}

- (void)presentModalViewController:(UIViewController *)controller parent:(UIViewController *)parentController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if ([UIApplication sharedApplication].isIgnoringInteractionEvents)
        [parentController performSelector:@selector(presentModalViewController:animated:) withObject:controller afterDelay:1];
    else
        [parentController presentViewController:controller animated:animated completion:completion];
}

@end