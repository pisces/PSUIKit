//
//  ImagePopViewManager.h
//  PSUIKit
//
//  Created by Steve Kim on 2015. 6. 23..
//  Copyright (c) 2013 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePopViewManager : NSObject
@property (nonatomic, readonly) BOOL showing;
+ (ImagePopViewManager *)sharedManager;
- (void)hide;
- (void)hideWithTarget:(UIImageView *)target from:(CGRect)from to:(CGRect)to;
- (void)hideWithTarget:(UIImageView *)target from:(CGRect)from to:(CGRect)to completion:(void(^)(void))completion;
- (void)hideWithTarget:(UIImageView *)target from:(CGRect)from to:(CGRect)to animated:(BOOL)animated;
- (void)hideWithTarget:(UIImageView *)target from:(CGRect)from to:(CGRect)to animated:(BOOL)animated completion:(void(^)(void))completion;
- (void)showInView:(UIView *)view source:(CGImageRef)source from:(CGRect)from to:(CGRect)to animations:(void(^)(UIImageView *imageView))animations completion:(void(^)(UIImageView *imageView))completion;
@end
