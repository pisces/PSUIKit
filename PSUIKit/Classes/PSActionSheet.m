//
//  PSActionSheet.m
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import "PSActionSheet.h"

@interface UIActionSheetDelegate : NSObject <UIActionSheetDelegate>
@property (copy) void(^completionBlock)(NSInteger buttonIndex, BOOL cancel);
@end

@interface PSActionSheet ()
@property (nonatomic, strong) UIActionSheetDelegate *delegateObject;
@end

@implementation UIActionSheetDelegate

- (void)actionSheet:(PSActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.completionBlock)
        self.completionBlock(buttonIndex, actionSheet.cancelButtonIndex == buttonIndex);
    
    self.completionBlock = nil;
    actionSheet.delegateObject = nil;
    actionSheet.delegate = nil;
}

- (void)actionSheetCancel:(PSActionSheet *)actionSheet {
    if (self.completionBlock)
        self.completionBlock(actionSheet.cancelButtonIndex, YES);
    
    self.completionBlock = nil;
    actionSheet.delegateObject = nil;
    actionSheet.delegate = nil;
}

@end

@implementation PSActionSheet

- (void)dealloc {
    
}

- (void)showInView:(UIView *)view completion:(void(^)(NSInteger buttonIndex, BOOL cancel))completion {
    UIActionSheetDelegate *object = [[UIActionSheetDelegate alloc] init];
    object.completionBlock = completion;
    
    self.delegateObject = object;
    self.delegate = object;
    
    if ([view isKindOfClass:[UITabBar class]])
        [self showFromTabBar:(UITabBar *) view];
    else
        [self showInView:view];
}

@end