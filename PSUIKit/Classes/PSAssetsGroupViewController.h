//
//  PSAssetsGroupViewController.h
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "PSViewController.h"
#import "PSImageAssetScrollView.h"
#import "PSRecycledScrollView.h"
#import "DragDropModalNavigationController.h"

@interface NSDate (org_apache_PSUIKit_PSAssetsGroupViewController_NSDate)
- (NSString *)relativeTimeSpanString;
@end

@protocol PSAssetsGroupViewControllerDelegate;

@interface PSAssetsGroupViewController : PSViewController <DragDrapModalNavigationControllerDelegate, PSImageAssetScrollViewGestureDelegate, PSRecycledScrollViewDataSource>
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic) BOOL allowsShowPageNumber;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) PSImageAssetScrollView *selectedView;
@property (nonatomic, weak) id<PSAssetsGroupViewControllerDelegate> delegate;
+ (CGRect)frameWithImageRef:(CGImageRef)imageRef;
+ (PSAssetsGroupViewController *)newWithViewController:(UIViewController *)viewController sourceImage:(UIImage *)sourceImage presentingSource:(DragDropModalTransitionSource *)presentingSource dismissionSource:(DragDropModalTransitionSource *)dismissionSource completion:(void(^)(void))completion;
@end

@protocol PSAssetsGroupViewControllerDelegate <DragDrapModalNavigationControllerDelegate>
@optional
- (void)controller:(PSAssetsGroupViewController *)controller didChangeSelectedIndex:(NSInteger)selectedIndex;
@end