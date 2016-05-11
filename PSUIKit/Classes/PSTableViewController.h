//
//  PSTableViewController.h
//  PSUIKit
//
//  Created by Steve Kim on 2014. 8. 24..
//  Copyright (c) 2014년 Steve Kim. All rights reserved.
//

#import "PSViewController.h"

@interface PSTableViewController : PSViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;
@property (nonatomic, readonly) UITableView *tableView;
@end