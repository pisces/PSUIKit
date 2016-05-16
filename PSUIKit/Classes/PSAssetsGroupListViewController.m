//
//  PSAssetsGroupListViewController.m
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSAssetsGroupListViewController.h"
#import "PSUIKit.h"

@interface PSAssetsGroupListViewController ()
@end

@implementation PSAssetsGroupListViewController
{
@private
    NSMutableArray *groups;
}

// ================================================================================================
//  Overridden: PSTableViewController
// ================================================================================================

#pragma mark - Overridden: PSTableViewController

- (void)initProperties {
    [super initProperties];
    
    self.title = [PSUIKit localizedStringWithKey:@"Album"];
    self.clearsSelectionOnViewWillAppear = YES;
    groups = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.allowsGestureTransitions = NO;
    self.navigationController.theme = [UIThemeDefaultStyle sharedTheme];
    
    [self.navigationItem addRightBarButtonItem:[self.navigationController.theme rightBarButtonItemWithTitle:[PSUIKit localizedStringWithKey:@"Cancel"] target:self action:@selector(close)]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self enumerateGroups];
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellIdentifier = [PSAssetsGroupListViewCell reuseIdentifier];
    PSAssetsGroupListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [PSAssetsGroupListViewCell nibBasedInstanceWithBundle:[PSUIKit bundle]];
    }
    
    cell.group = groups[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PSTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LineDrawPosition lineDrawPosition = LineDrawPositionBottom | LineDrawPositionTop;
    if (indexPath.row >= groups.count - 1)
        lineDrawPosition = LineDrawPositionNone;
    else if (indexPath.row == 0)
        lineDrawPosition = LineDrawPositionBottom;
        
    cell.linedBackgroundView.lineDrawPosition = cell.selectedLinedBackgroundView.lineDrawPosition = lineDrawPosition;
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PSAssetListViewController *controller = [PSAssetListViewController controllerWithBundle:[PSUIKit bundle]];
    controller.allowsMultipleSelection = self.allowsMultipleSelection;
    controller.delegate = self.assetListViewDelegate;
    controller.group = groups[indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)enumerateGroups {
    if (!self.isFirstViewAppearence)
        return;
    
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    } failureBlock:^(NSError *error) {
#pragma mark - TODO: error process
    }];
}

- (void)reloadData {
    [self.tableView reloadData];
}

@end
