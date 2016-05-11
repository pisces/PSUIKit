//
//  PSPreloader.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSPreloader.h"
#import "base.h"

@interface PSPreloader ()
@property (nonatomic, readonly) NSArray *animationImages;
@end

@implementation PSPreloader
{
@private
    UIView *modalView;
}

// ================================================================================================
//  Overridden: PSView
// ================================================================================================

#pragma mark - Overridden: PSView

- (void)dealloc
{
    [modalView removeFromSuperview];
    [_imageView removeFromSuperview];
    
    modalView = nil;
    _completedImage = nil;
    _failedImage = nil;
    _imageView = nil;
}

- (void)initProperties
{
    [super initProperties];
    
    modalView = [[UIView alloc] init];
    modalView.backgroundColor = [UIColor blackColor];
    modalView.alpha = 0.3;
    
    _completedImage = [UIImage imageNamed:@"PSUIKit.bundle/loading_00025.png"];
    _failedImage = [UIImage imageNamed:@"PSUIKit.bundle/loading_error.png"];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.animationImages = self.animationImages;
    _imageView.animationDuration = 0.4f;
    _imageView.frame = CGRectMake(0, 0, 60, 60);
    
    [self addSubview:_imageView];
}

// ================================================================================================
//  Class
// ================================================================================================

#pragma mark - Class
+ (instancetype)sharedInstance
{
    static PSPreloader *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[PSPreloader alloc] init];
    });
    return instance;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (void)hide:(void (^)(void))completion
{
    [self hideWithStatus:PSPreloaderStatusCompletion completion:completion];
}

- (void)hideWithStatus:(PSPreloaderStatus)status animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (!self.showing)
        return;
    
    if (status != PSPreloaderStatusLoading)
    {
        [self.imageView stopAnimating];
        
        self.imageView.image = status == PSPreloaderStatusCompletion ? self.completedImage : self.failedImage;
    }
    
    void (^completionState)(void) = ^(void)
    {
        _showing = NO;
        
        [self.imageView stopAnimating];
        [modalView removeFromSuperview];
        [self removeFromSuperview];
        
        if (completion)
            completion();
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.1 delay:0.4 options:0 animations:^{
            self.transform = CGAffineTransformMakeScale(0.2, 0.2);
        } completion:^(BOOL finished) {
            completionState();
        }];
    }
    else
    {
        completionState();
    }
}

- (void)hideWithStatus:(PSPreloaderStatus)status completion:(void (^)(void))completion
{
    [self hideWithStatus:status animated:YES completion:completion];
}

- (void)show
{
    if (self.showing)
        return;
    
    _showing = YES;
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake((self.window.width - self.imageView.width) / 2.0f, (self.window.height - self.imageView.height) / 2.0f, self.imageView.width, self.imageView.height);
    
    if (self.allowsShowModalView) {
        modalView.frame = self.window.bounds;
        [self.window addSubview:modalView];
    }
    
    [self.window addSubview:self];
    
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [self.imageView startAnimating];
    
    [UIView animateWithDuration:0.3 delay:0 options:animationOptions animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:NULL];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private getter/setter

- (NSArray *)animationImages
{
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSInteger i=0; i<25; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"PSUIKit.bundle/loading_000%02zd.png", i]]];
    }
    
    return images;
}

- (UIWindow *)window
{
    return [UIApplication sharedApplication].windows.lastObject;
}

@end
