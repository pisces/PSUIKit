//
//  DemoExampleViewController.m
//  PSUIKit
//
//  Created by Steve Kim on 5/11/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

#import "DemoExampleViewController.h"
#import "CustomExampleTheme.h"

@interface DemoExampleViewController () <PSTabbarControllerDataSource, PSTabbarControllerDelegate>
@property (nonatomic, weak) IBOutlet UIButton *retryButton;
@end

@implementation DemoExampleViewController
{
    BOOL typeChanged;
}

#pragma mark - Overridden: PSViewController

- (void)commitProperties {
    if (typeChanged) {
        typeChanged = NO;
        self.title = exampleTitles[_type - 1];
        
        [self runExample];
    }
}

#pragma mark - Public getter/setter

- (void)setType:(ExampleType)type {
    if (type == _type)
        return;
    
    _type = type;
    typeChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - Public methods

- (id)initWithType:(ExampleType)type {
    self = [super initWithNibName:@"DemoExampleView" bundle:[NSBundle mainBundle]];
    
    if (self) {
        self.type = type;
    }
    
    return self;
}

#pragma mark - Private methods

- (void)runExample {
    switch (_type) {
        case ExampleTypeApplyDefaultTheme:
            [self runDefaultTheme];
            break;
            
        case ExampleTypeApplyCustomTheme:
            [self runCustomTheme];
            break;
            
        case ExampleTypePSImagePickerViewController:
            [self runPSImagePickerViewController];
            break;
            
        case ExampleTypePSAlertView:
            [self runPSAlertView];
            break;
            
        case ExampleTypePSAlertViewWithCustomContentView:
            [self runPSAlertViewWithCustomContentView];
            break;
            
        case ExampleTypePSBadge:
            [self runPSBadge];
            break;
            
        case ExampleTypePSButtonBar:
            [self runPSButtonBar];
            break;
            
        case ExampleTypePSToastView:
            [self runPSToastView];
            break;
            
        case ExampleTypePSPreloader:
            [self runPSPreloader];
            break;
            
        case ExampleTypePSAttributedDivisionLabel:
            [self runPSAttributedDivisionLabel];
            break;
            
        case ExampleTypePSTabbarController:
            [self runPSTabbarController];
            break;
            
        default:
            break;
    }
}

- (void)runDefaultTheme {
    self.navigationController.theme = [[UIThemeDefaultStyle alloc] init];
    self.navigationItem.rightBarButtonItems = @[[self.navigationController.theme rightBarButtonItemWithTitle:@"r2" target:self action:nil], [self.navigationController.theme rightBarButtonItemWithTitle:@"r1" target:self action:nil]];
}

- (void)runCustomTheme {
    self.navigationController.theme = [[CustomExampleTheme alloc] init];
    self.navigationItem.rightBarButtonItems = @[[self.navigationController.theme rightBarButtonItemWithTitle:@"r2" target:self action:nil], [self.navigationController.theme rightBarButtonItemWithTitle:@"r1" target:self action:nil]];
}

- (void)runPSAlertView {
    _retryButton.hidden = NO;
    
    [PSAlertView alertViewWithTitle:@"Title Sample" message:@"Message Sample!!" cancelButtonTitle:@"Ok" dismission:nil otherButtonTitles:nil];
}

- (void)runPSAlertViewWithCustomContentView {
    _retryButton.hidden = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    tableView.dataSource = self;
    
    [PSAlertView alertViewWithContentView:tableView cancelButtonTitle:@"Ok" dismission:nil otherButtonTitles:nil];
}

- (void)runPSBadge {
    UIView *sourceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    sourceView.layer.cornerRadius = sourceView.width/2;
    sourceView.backgroundColor = [UIColor redColor];
    
    PSBadge *badge = [[PSBadge alloc] initWithBackgroundImage:sourceView.image maxSize:CGSizeMake(100, sourceView.height) minSize:sourceView.size padding:CGPaddingMake(3, 3, 3, 3)];
    badge.text = @"N";
    badge.textLabel.textColor = [UIColor whiteColor];
    badge.origin = CGPointMake(20, 100);
    
    [self.view addSubview:badge];
}

- (void)runPSButtonBar {
    const CGFloat yOffset = MAX(((UIView *) self.view.subviews.lastObject).bottom, 44) + 20;
    PSButtonBar *buttonBar = [[PSButtonBar alloc] initWithFrame:CGRectMake(0, yOffset, self.view.width, 60)];
    buttonBar.numOfButtons = 3;
    buttonBar.seperatorColor = [UIColor whiteColor];
    
    buttonBar.delegateObject = [[PSButtonBarDelegateObject alloc] initWithRender:^(UIButton *button, NSUInteger buttonIndex) {
        [button setBackgroundImage:[[UIView alloc] initWithColor:[UIColor lightGrayColor] withFrame:button.bounds].image forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"Button%tu", (buttonIndex+1)] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } clicked:^(UIButton *button, NSUInteger buttonIndex) {
        NSLog(@"buttonBar clicked: buttonIndex -> %tu", buttonIndex);
    } resized:^(UIButton *button, NSUInteger buttonIndex) {
        NSLog(@"buttonBar resized: buttonIndex -> %tu", buttonIndex);
    } selected:^(UIButton *button, NSUInteger buttonIndex) {
        NSLog(@"buttonBar selected: buttonIndex -> %tu", buttonIndex);
    }];
    
    [self.view addSubview:buttonBar];
}

- (void)runPSAttributedDivisionLabel {
    const CGFloat yOffset = MAX(((UIView *) self.view.subviews.lastObject).bottom, 44) + 20;
    PSAttributedDivisionLabel *label = [[PSAttributedDivisionLabel alloc] initWithFrame:CGRectMake(20, yOffset, self.view.width, 60)];
    label.divider = @"\n";
    label.colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
    label.fonts = @[[UIFont systemFontOfSize:12], [UIFont systemFontOfSize:14], [UIFont systemFontOfSize:16]];
    label.text = @"redColor\nblueColor\ngreenColor";
    
    [self.view addSubview:label];
    [label sizeToFit];
}

- (void)runPSImagePickerViewController {
    _retryButton.hidden = NO;
    
    PSImagePickerController *controller = [[PSImagePickerController alloc] init];
    controller.allowsMultipleSelection = YES;
    
    [controller setCompletion:^(NSArray *results){
        NSLog(@"%@", results);
    }];
    
    [[PopUpViewManager sharedInstance] navigationPopWithViewController:controller];
}

- (void)runPSPreloader {
    _retryButton.hidden = YES;
    
    [[PSPreloader sharedInstance] show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PSPreloader sharedInstance] hideWithStatus:PSPreloaderStatusCompletion completion:^{
            _retryButton.hidden = NO;
        }];
    });
}

- (void)runPSTabbarController {
    PSTabbarController *controller = [[PSTabbarController alloc] init];
    controller.dataSource = self;
    controller.delegate = self;
    controller.pagingEnabled = YES;
    controller.tabbarPosition = PSTabbarPositionBottom;
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
}

- (void)runPSToastView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.x = 110;
    button.y = 200;
    button.width = 150;
    button.height = 40;
    
    [button setTitle:@"Show" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showToastInView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)showToastInView:(UIView *)view {
    [[PSToastView sharedToastView] showWithView:view message:@"Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!Toast Sample Message!!" position:PSToastViewPostionTop];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = (UITableViewCell* ) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"row %zd", indexPath.row+1];
    
    return cell;
}


#pragma mark - UIButton selector

- (IBAction)buttonClicked:(id)sender {
    [self runExample];
}

#pragma mark - PSTabViewController data source

- (NSArray<UIViewController *> * _Nonnull)childViewControllersWithController:(PSTabbarController * _Nonnull)controller {
    UIViewController *firstController = [[UIViewController alloc] init];
    firstController.title = @"First";
    firstController.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *secondController = [[UIViewController alloc] init];
    secondController.title = @"Second";
    secondController.view.backgroundColor = [UIColor greenColor];
    
    return @[firstController, secondController];
}

- (void)controller:(PSTabbarController * _Nonnull)controller renderWithTab:(UIButton * _Nonnull)tab tabIndex:(NSInteger)tabIndex {
    
}

#pragma mark - PSTabViewController delegate

- (void)didChangeTabIndex:(NSInteger)tabIndex {
    
}

@end