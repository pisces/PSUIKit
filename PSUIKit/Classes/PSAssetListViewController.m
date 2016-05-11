//
//  PSAssetListViewController.m
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

#import "PSAssetListViewController.h"
#import "PSUIKit.h"

@interface PSAssetListViewController ()
@property (nonatomic, readonly) UICollectionView *collectionView;
@end

@implementation PSAssetListViewController
{
@private
    BOOL allowsMultipleSelectionChanged;
    BOOL groupChanged;
    NSMutableArray *assets;
    NSMutableArray *indexPathsForSelectedItems;
    PSAssetsGroupViewController *assetsGroupViewController;
}

// ================================================================================================
//  Overridden: PSViewController
// ================================================================================================

#pragma mark - Overridden: PSView

- (void)commitProperties {
    if (allowsMultipleSelectionChanged) {
        allowsMultipleSelectionChanged = NO;
        
        self.collectionView.allowsMultipleSelection = self.allowsMultipleSelection;
    }
    
    if (groupChanged) {
        groupChanged = NO;
        
        [self groupChanged];
    }
}

- (void)initProperties {
    [super initProperties];
    
    _numOfColumns = 3;
    _minSpacing = 1.0;
    assets = [NSMutableArray array];
    indexPathsForSelectedItems = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView = (UICollectionView *) self.view;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.collectionView.contentInset = UIEdgeInsetsZero;
    }
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.showsVerticalScrollIndicator = YES;
    
    self.navigationController.allowsGestureTransitions = NO;
    self.navigationController.theme = [UIThemeDefaultStyle sharedTheme];
    
    [self.navigationItem addRightBarButtonItem:[self.navigationController.theme rightBarButtonItemWithTitle:[PSUIKit localizedStringWithKey:@"Cancel"] target:self action:@selector(close)]];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = CGRectMake(0, -self.statusBarFrame.size.height, self.navigationController.navigationBar.width, self.statusBarFrame.size.height + self.navigationController.navigationBar.height);
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    visualEffectView.userInteractionEnabled = NO;
    
    [self.navigationController.navigationBar addSubview:visualEffectView];
    [self.navigationController.navigationBar sendSubviewToBack:visualEffectView];
    [self.collectionView addGestureRecognizer:longPressGestureRecognizer];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PSAssetListViewCell" bundle:[PSUIKit bundle]] forCellWithReuseIdentifier:[PSAssetListViewCell reuseIdentifier]];
    [self setLeftBarButtonItem];
    [self setRightBarButtonItem];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    if (allowsMultipleSelection == _allowsMultipleSelection)
        return;
    
    _allowsMultipleSelection = allowsMultipleSelection;
    allowsMultipleSelectionChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - Public getter/setter

- (void)setGroup:(ALAssetsGroup *)group {
    if ([group isEqual:_group])
        return;
    
    _group = group;
    groupChanged = YES;
    
    [self invalidateProperties];
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - UICollectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return assets.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat columnWidth = (self.view.superview.width/self.numOfColumns) - self.minSpacing;
    return CGSizeMake(columnWidth, columnWidth);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSAssetListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PSAssetListViewCell reuseIdentifier] forIndexPath:indexPath];
    
    @try {
        cell.allowsOverlayImageShow = self.allowsMultipleSelection;
        cell.asset = assets[indexPath.row];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [indexPathsForSelectedItems removeObject:indexPath];
    [self setRightBarButtonItem];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [indexPathsForSelectedItems addObject:indexPath];
    [self setRightBarButtonItem];
}

#pragma mark - PSAssetsGroupViewController delegate

- (void)didBeginTransition {
    PSAssetListViewCell *cell = (PSAssetListViewCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:assetsGroupViewController.selectedIndex inSection:0]];
    cell.imageView.hidden = YES;
}

- (void)didEndTransition {
    PSAssetListViewCell *cell = (PSAssetListViewCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:assetsGroupViewController.selectedIndex inSection:0]];
    cell.imageView.hidden = NO;
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)groupChanged {
    self.title = [self.group valueForProperty:[PSUIKit localizedStringWithKey:ALAssetsGroupPropertyName]];
    
    [assets removeAllObjects];
    [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result){
            [assets insertObject:result atIndex:0];
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    }];
}

- (void)reloadData {
    if (self.isViewAppeared)
        [self.collectionView reloadData];
}

- (void)openAssetsGroupViewWithIndexPath:(NSIndexPath *)indexPath {
    PSAssetListViewCell *cell = (PSAssetListViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    
    __block PSAssetListViewCell *endCell = nil;
    
    DragDropModalTransitionSource *presentingSource = [[DragDropModalTransitionSource new] from:^CGRect{
        CGPoint offset = [self.collectionView convertPoint:cell.origin toView:self.view.window];
        return CGRectMake(offset.x, offset.y, cell.imageView.width, cell.imageView.height);
    } to:^CGRect{
        cell.imageView.hidden = YES;
        return [PSAssetsGroupViewController frameWithImageRef:cell.asset.defaultRepresentation.fullScreenImage];
    } completion:^{
        cell.imageView.hidden = NO;
    }];
    
    DragDropModalTransitionSource *dismissionSource = [[DragDropModalTransitionSource new] from:^CGRect{
        return assetsGroupViewController.selectedView.imageView.frame;
    } to:^CGRect{
        endCell = (PSAssetListViewCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:assetsGroupViewController.selectedIndex inSection:0]];
        endCell.hidden = YES;
        CGPoint offset = [self.collectionView convertPoint:endCell.origin toView:self.view.window];
        return CGRectMake(offset.x, offset.y, endCell.imageView.width, endCell.imageView.height);
    } completion:^{
        endCell.hidden = NO;
        assetsGroupViewController = nil;
    }];
    
    assetsGroupViewController = [PSAssetsGroupViewController newWithViewController:self sourceImage:cell.imageView.image presentingSource:presentingSource dismissionSource:dismissionSource completion:^{
        assetsGroupViewController.assets = assets;
        assetsGroupViewController.selectedIndex = indexPath.row;
    }];
}

- (void)setRightBarButtonItem {
    [self.navigationItem removeRightBarButtonItem];
    
    if (self.allowsMultipleSelection) {
        NSInteger count = self.collectionView.indexPathsForSelectedItems.count;
        NSString *title = [NSString stringWithFormat:@"%@%@", [PSUIKit localizedStringWithKey:@"Select"], (count > 0 ? [NSString stringWithFormat:@" %zd", count] : @"")];
        
        [self.navigationItem addRightBarButtonItem:[self.navigationController.theme leftBarButtonItemWithTitle:title target:self action:@selector(done)]];
        [self.navigationItem getRightBarButtonItem].enabled = self.collectionView.indexPathsForSelectedItems.count > 0;
    }
}

#pragma mark - UIGestureRecognizer selector

- (void)longPressed:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [indexPathsForSelectedItems removeObject:indexPath];
        [self setRightBarButtonItem];
        [self openAssetsGroupViewWithIndexPath:indexPath];
    }
}

#pragma mark - UINavigationItem selector

- (void)done {
    if (![self.delegate respondsToSelector:@selector(controller:didFinishPickingImages:)])
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:indexPathsForSelectedItems.count];
        
        for (NSIndexPath *indexPath in indexPathsForSelectedItems)
            [array addObject:assets[indexPath.row]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate controller:self didFinishPickingImages:array];
        });
    });
}

@end
