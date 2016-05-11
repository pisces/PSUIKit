//
//  PSActionSheet.h
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSActionSheet : UIActionSheet
- (void)showInView:(UIView *)view completion:(void(^)(NSInteger buttonIndex, BOOL cancel))completion;
@end