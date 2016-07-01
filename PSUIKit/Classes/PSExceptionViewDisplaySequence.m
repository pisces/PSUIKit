//
//  PSExceptionViewDisplaySequence.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2015년 hh963103@gmail.com. All rights reserved.
//

#import "PSExceptionViewDisplaySequence.h"

@implementation PSExceptionViewDisplaySequence
{
@private
    BOOL delegateChanged;
    NSMutableArray *queue;
}

// ================================================================================================
//  Overridden: NSObject
// ================================================================================================

#pragma mark - Overridden: NSObject

- (void)dealloc {
    queue = nil;
}

- (id)init {
    self = [super init];
    
    if (self)
        queue = [NSMutableArray array];
    
    return self;
}

- (id)initWithDelegate:(id<PSExceptionViewControllerDelegate>)delegate {
    self = [super init];
    
    if (self) {
        queue = [NSMutableArray array];
        self.delegate = delegate;
    }
    
    return self;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setDelegate:(id<PSExceptionViewControllerDelegate>)delegate {
    if ([delegate isEqual:_delegate])
        return;
    
    _delegate = delegate;
    delegateChanged = YES;
    
    [self delegateChanged];
}

#pragma mark - Public methods

- (void)addController:(PSExceptionViewController *)controller {
    if (controller) {
        controller.delegate = self.delegate;
        
        [queue addObject:controller];
    }
}

- (void)addControllers:(NSArray<PSExceptionViewController *> *)controllers {
    for (id object in controllers) {
        if ([object isKindOfClass:[PSExceptionViewController class]])
            [self addController:object];
    }
}

- (void)insertController:(PSExceptionViewController *)controller atIndex:(NSInteger)index {
    if (controller) {
        controller.delegate = self.delegate;
        
        [queue insertObject:controller atIndex:index];
    }
}

- (void)clear {
    for (PSExceptionViewController *controller in queue) {
        [controller.view removeFromSuperview];
    }
    
    _showing = NO;
}

- (BOOL)checkVisibility {
    [self clear];
    
    for (PSExceptionViewController *controller in queue) {
        if ([controller checkVisibility]) {
            _showing = YES;
            return _showing;
        }
    }
    
    return _showing;
}

- (NSInteger)indexOfController:(PSExceptionViewController *)controller {
    return [queue indexOfObject:controller];
}

- (void)removeController:(PSExceptionViewController *)controller {
    [controller.view removeFromSuperview];
    [queue removeObject:controller];
}

- (void)removeAllController {
    for (PSExceptionViewController *controller in queue) {
        [controller.view removeFromSuperview];
    }
    
    [queue removeAllObjects];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)delegateChanged {
    if (!delegateChanged)
        return;
    
    delegateChanged = NO;
    
    for (PSExceptionViewController *controller in queue) {
        controller.delegate = self.delegate;
    }
}

@end
