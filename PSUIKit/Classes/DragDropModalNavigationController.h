//
//  DragDropModalNavigationController.h
//  orcller
//
//  Created by pisces on 2015. 9. 22..
//  Copyright (c) 2015년 orcllercorp. All rights reserved.
//

#import "AbstractModalNavigationController.h"
#import "DragDropModalTransitionAnimator.h"

@protocol DragDrapModalNavigationControllerDelegate;

@interface DragDropModalNavigationController : AbstractModalNavigationController
{
@protected
    CGPoint originDismissionImageViewPoint;
    UIMaskedImageView *dismissionImageView;
}

@property (nonatomic, strong) DragDropModalTransitionSource *dismissionSource;
@property (nonatomic, strong) DragDropModalTransitionSource *presentingSource;
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, weak) id<DragDrapModalNavigationControllerDelegate, ModalNavigationControllerDelegate> sourceDelegate;
@end

@protocol DragDrapModalNavigationControllerDelegate <ModalNavigationControllerDelegate>
@optional
- (UIImage *)sourceImageForDismission;
- (CGRect)sourceImageRectForDismission;
@end