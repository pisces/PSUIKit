//
//  PSPreloader.h
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "GraphicsLayout.h"
#import "PSView.h"

enum {
    PSPreloaderStatusCompletion,
    PSPreloaderStatusLoading,
    PSPreloaderStatusFail
};
typedef Byte PSPreloaderStatus;

@interface PSPreloader : PSView
@property (nonatomic) BOOL allowsShowModalView;
@property (nonatomic, readonly) BOOL showing;
@property (nonatomic, strong) UIImage *completedImage;
@property (nonatomic, strong) UIImage *failedImage;
@property (nonatomic, readonly) UIImageView *imageView;

+ (instancetype)sharedInstance;
- (void)hide:(void (^)(void))completion;
- (void)hideWithStatus:(PSPreloaderStatus)status animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)hideWithStatus:(PSPreloaderStatus)status completion:(void (^)(void))completion;
- (void)show;
@end
