//
//  PSTableViewController.m
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import "PSTableViewController.h"

@interface PSTableViewController ()
@end

@implementation PSTableViewController
- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.view isKindOfClass:[UITableView class]])
    {
        _tableView = (UITableView *) self.view;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.clearsSelectionOnViewWillAppear)
    {
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows)
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self endDataLoading];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
