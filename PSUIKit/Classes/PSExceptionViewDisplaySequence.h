//
//  PSExceptionViewDisplaySequence.m
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2015년 hh963103@gmail.com. All rights reserved.
//

#import "PSExceptionViewController.h"

@interface PSExceptionViewDisplaySequence : NSObject
@property (nonatomic, weak) id<PSExceptionViewControllerDelegate> delegate;
- (void)addControllers:(NSArray *)controllers;
- (void)addController:(PSExceptionViewController *)controller;
- (BOOL)checkVisibility;
- (void)clear;
- (id)initWithDelegate:(id<PSExceptionViewControllerDelegate>)delegate;
- (NSInteger)indexOfController:(PSExceptionViewController *)controller;
- (void)removeController:(PSExceptionViewController *)controller;
- (void)removeAllController;
@end
