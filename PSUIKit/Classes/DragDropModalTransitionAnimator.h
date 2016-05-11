//
//  ScaleModalTransitionAnimator.h
//  orcller
//
//  Created by pisces on 2015. 9. 22..
//  Copyright (c) 2015년 orcllercorp. All rights reserved.
//

#import "AbstractModalTransitionAnimator.h"
#import "UIMaskedImageView.h"

typedef CGRect (^DragDropModalTransitionSourceBlock)(void);
typedef void (^DragDropModalTransitionCompletionBlock)(void);

@interface DragDropModalTransitionSource: NSObject;
@property (nonatomic, copy) DragDropModalTransitionSourceBlock from;
@property (nonatomic, copy) DragDropModalTransitionSourceBlock to;
@property (nonatomic, copy) DragDropModalTransitionCompletionBlock completion;
- (void)clear;
- (DragDropModalTransitionSource *)from:(DragDropModalTransitionSourceBlock)from to:(DragDropModalTransitionSourceBlock)to completion:(DragDropModalTransitionCompletionBlock)completion;
@end

@protocol DragDropModalTransitionAnimatorProtected <NSObject>
- (void)clear;
- (UIMaskedImageView *)createImageView;
@end

@interface DragDropModalTransitionAnimator : AbstractModalTransitionAnimator <DragDropModalTransitionAnimatorProtected>
@property (nonatomic, strong) DragDropModalTransitionSource *transitionSource;
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, strong) UIImageView *dismissiontImageView;
@end
