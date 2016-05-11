//
//  DemoViewController.m
//  PSUIKit
//
//  Created by Steve Kim on 05/11/2016.
//  Copyright (c) 2016 Steve Kim. All rights reserved.
//

#import <PSUIKit/PSUIKit.h>
#import "DemoViewController.h"
#import "DemoExampleViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

// ================================================================================================
//  Overridden: UITableViewController
// ================================================================================================

#pragma mark - Overridden: UITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PSUIKit Examples";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.theme = [[UIThemeDefaultStyle alloc] init];
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return exampleTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.textLabel.text = exampleTitles[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoExampleViewController *controller = [[DemoExampleViewController alloc] initWithType:indexPath.row + 1];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
