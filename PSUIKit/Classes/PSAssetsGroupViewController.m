//
//  PSAssetsGroupViewController.m
//  PSUIKit
//
//  Created by pisces on 2015. 7. 3..
//  Copyright (c) 2015년 Steve Kim. All rights reserved.
//

#import "PSAssetsGroupViewController.h"
#import "PSUIKit.h"

const CGFloat contentScrollViewPadding = 15;

@interface PSAssetsGroupViewController ()
@property (nonatomic, weak) IBOutlet PSRecycledScrollView *contentScrollView;
@property (nonatomic) BOOL footerViewHidden;
@end

@implementation PSAssetsGroupViewController
{
    __weak IBOutlet UIView *footerView;
    __weak IBOutlet UILabel *countLabel;
    __weak IBOutlet PSAttributedDivisionLabel *titleView;
    
    BOOL assetsChanged;
    BOOL footerViewHiddenChanged;
    BOOL selectedIndexChanged;
    NSInteger requestIndex;
}

// ================================================================================================
//  Overridden: PSViewController
// ================================================================================================

#pragma mark - Overridden: PSViewController

- (BOOL)closeAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if ([self.transition isKindOfClass:[UIViewControllerDragDropTransition class]]) {
        ((UIViewControllerDragDropTransition *) self.transition).sourceImage = self.selectedView.imageView.image;
    }
    
    return [super closeAnimated:animated completion:completion];
}

- (void)commitProperties {
    [super commitProperties];
    
    if (assetsChanged) {
        assetsChanged = NO;
        
        [self reloadData];
        [self updateDisplayList];
    }
    
    if (selectedIndexChanged) {
        selectedIndexChanged = NO;
        
        [self.contentScrollView moveToIndex:self.selectedIndex withAnimation:NO];
        [self updateDisplayList];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    return [PSAssetsGroupViewController controllerWithBundle:[PSUIKit bundle]];
}

- (void)initProperties {
    [super initProperties];
    
    requestIndex = NSNotFound;
    _allowsShowPageNumber = YES;
    _selectedIndex = -1;
    
    if (![[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications])
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.theme = [UIThemeWhiteTranslucent sharedTheme];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.contentScrollView.type = PSRecycledScrollViewTypeHorizontal;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.width = self.view.width + contentScrollViewPadding;
    self.contentScrollView.padding = contentScrollViewPadding;
    self.contentScrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    titleView.colors = @[[UIColor blackColor]];
    titleView.fonts = @[[UIFont systemFontOfSize:14], [UIFont systemFontOfSize:11]];
    titleView.paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
    titleView.paragraphStyle.lineSpacing = 5;
    
    UIVisualEffectView *navigationBackgroundView = [self createVisualEffectViewWithFrame:CGRectMake(0, -self.statusBarFrame.size.height, self.navigationController.navigationBar.width, self.statusBarFrame.size.height + self.navigationController.navigationBar.height)];
    UIVisualEffectView *footerBackgroundView = [self createVisualEffectViewWithFrame:footerView.bounds];
    
    [footerView insertSubview:footerBackgroundView atIndex:0];
    [self.navigationController.navigationBar insertSubview:navigationBackgroundView atIndex:0];
    [self.navigationItem addLeftBarButtonItem:[[UIThemeDefaultStyle sharedTheme] backCollectionBarButtonItemWithTarget:self action:@selector(close)]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (self.isFirstViewAppearence) {
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
        titleView.size = self.navigationController.navigationBar.size;
        [self.navigationController.navigationBar addSubview:titleView];
    }
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - DragDropModalNavigationController delegate

- (void)didBeginTransition {
    self.selectedView.imageView.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(didBeginTransition)])
        [self.delegate didBeginTransition];
}

- (void)didEndTransition {
    self.selectedView.imageView.hidden = NO;
    
    if ([self.delegate respondsToSelector:@selector(didEndTransition)])
        [self.delegate didEndTransition];
}

- (UIImage *)sourceImageForDismission {
    return self.selectedView.imageView.image;
}

- (CGRect)sourceImageRectForDismission {
    return [PSAssetsGroupViewController frameWithImageRef:self.selectedView.asset.defaultRepresentation.fullScreenImage];
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public class methods

+ (CGRect)frameWithImageRef:(CGImageRef)imageRef {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = window.rootViewController.view;
    const CGFloat viewWidth = view.width;
    const CGFloat viewHeight = view.height;
    CGSize viewSize = CGSizeMake(viewWidth, viewHeight);
    CGSize size = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGFloat scale = viewSize.width/size.width;
    CGFloat w = size.width * scale;
    CGFloat h = size.height * scale;
    CGFloat x = (viewSize.width - w)/2;
    CGFloat y = (viewSize.height - h)/2 + (window.height - view.height);
    return CGRectMake(x, y, w, h);
}

+ (PSAssetsGroupViewController *)newWithViewController:(UIViewController *)viewController
                                           sourceImage:(UIImage *)sourceImage
                                      presentingSource:(AnimatedDragDropTransitionSource *)presentingSource
                                      dismissionSource:(AnimatedDragDropTransitionSource *)dismissionSource
                                            completion:(void(^)(void))completion {
    PSAssetsGroupViewController *controller = [[PSAssetsGroupViewController alloc] init];
    
    if ([viewController conformsToProtocol:@protocol(PSAssetsGroupViewControllerDelegate)])
        controller.delegate = (id<PSAssetsGroupViewControllerDelegate>) viewController;
    
    UIViewControllerDragDropTransition *transition = [[UIViewControllerDragDropTransition alloc] init];
    transition.sourceImage = sourceImage;
    transition.dismissionDelegate = controller;
    transition.dismissionDataSource = controller;
    transition.presentingSource = presentingSource;
    transition.dismissionSource = dismissionSource;
    
    PSNavigationController *navigationController = [[PSNavigationController alloc] initWithRootViewController:controller];
    navigationController.transition = transition;
    
    [viewController presentViewController:navigationController animated:YES completion:completion];
    
    return controller;
}

#pragma mark - Public getter/setter

- (UIScrollView *)scrollView {
    return self.contentScrollView;
}

- (PSImageAssetScrollView *)selectedView {
    return (PSImageAssetScrollView *) self.contentScrollView.visibleView;
}

- (void)setAssets:(NSArray *)assets {
    if ([assets isEqual:_assets])
        return;
    
    _assets = assets;
    assetsChanged = YES;
    
    [self invalidateProperties];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex)
        return;
    
    _selectedIndex = selectedIndex;
    selectedIndexChanged = YES;
    
    [self invalidateProperties];
}

#pragma mark - Public methods

- (void)reloadData {
    [self.contentScrollView reloadData];
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger originIndex = self.selectedIndex;
    self.selectedIndex = (scrollView.contentOffset.x + 1) / scrollView.width;
    
    if (originIndex != self.selectedIndex &&
        [self.delegate respondsToSelector:@selector(controller:didChangeSelectedIndex:)])
        [self.delegate controller:self didChangeSelectedIndex:self.selectedIndex];
}

#pragma mark - PSRecycledScrollView data source

- (NSInteger)numberOfViewInScrollView:(PSRecycledScrollView *)scrollView {
    return self.assets.count;
}

- (UIView *)viewForRecycledInScrollView:(PSRecycledScrollView *)scrollView atIndex:(NSInteger)index {
    PSImageAssetScrollView *view = (PSImageAssetScrollView *) [scrollView dequeueRecycledView];
    
    if (!view) {
        view = [[PSImageAssetScrollView alloc] initWithFrame:scrollView.frame];
        view.autoresizesSubviews = YES;
        view.autoresizingMask = UIViewAutoresizingFlexibleAll;
        view.backgroundColor = [UIColor clearColor];
        view.gestureDelegate = self;
    }
    
    view.asset = self.assets[index];
    
    return view;
}

- (CGFloat)scrollView:(PSScrollView *)scrollView sizeAtIndex:(NSInteger)index {
    return scrollView.width;
}

#pragma mark - PSImageAssetScrollViewGesture delegate

- (void)didTapWithImageAssetScrollView:(PSImageAssetScrollView *)view {
    self.footerViewHidden = !self.footerViewHidden;
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private getter/setter

- (void)selectedTitleWithCompletion:(void (^)(NSString *))completion {
    ALAsset *asset = self.assets[self.selectedIndex];
    NSDate *date = [asset valueForProperty:ALAssetPropertyDate];
    CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
    
    if (location) {
        [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                
            } else {
                CLPlacemark *placemark = placemarks.firstObject;
                NSString *city = (NSString *) placemark.addressDictionary[(NSString *) kABPersonAddressCityKey];
                NSString *state = (NSString *) placemark.addressDictionary[(NSString *) kABPersonAddressStateKey];
                NSString *country = (NSString *) placemark.country;
                NSString *location = [NSString stringWithFormat:@"%@%@%@",
                                      country ? country : @"",
                                      state ? [@" " stringByAppendingString:state] : @"",
                                      city ? [@" " stringByAppendingString:city] : @""];
                
                if ([location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
                    completion([NSString stringWithFormat:@"%@\n%@", location, date.relativeTimeSpanString]);
                else
                    completion(date.relativeTimeSpanString);
            }
        }];
    } else {
        completion(date.relativeTimeSpanString);
    }
}

- (void)setFooterViewHidden:(BOOL)footerViewHidden {
    if (footerViewHidden == _footerViewHidden)
        return;
    
    _footerViewHidden = footerViewHidden;
    
    [UIView animateWithDuration:0.5 delay:0 options:animationOptions animations:^{
        self.navigationController.navigationBar.y = self.footerViewHidden ? -self.navigationController.navigationBar.height : self.statusBarFrame.size.height;
        footerView.y = self.footerViewHidden ? self.view.height : self.view.height - footerView.height;
    } completion:nil];
}

#pragma mark - Private methods

- (UIVisualEffectView *)createVisualEffectViewWithFrame:(CGRect)frame {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = frame;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    visualEffectView.userInteractionEnabled = NO;
    return visualEffectView;
}

- (void)updateDisplayList {
    if (self.selectedIndex < 0)
        return;
    
    [self selectedTitleWithCompletion:^(NSString *title) {
        titleView.text = title;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.centerVertically = YES;
    }];
    
    countLabel.text = self.allowsShowPageNumber ? [NSString stringWithFormat:@"%tu of %tu", self.selectedIndex + 1, self.assets.count] : nil;
}

@end

@implementation NSDate (org_apache_PSUIKit_PSAssetsGroupViewController_NSDate)

- (NSString *)relativeTimeSpanString
{
    NSCalendarUnit flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *currCalendar = [NSCalendar currentCalendar];
    NSDate *nowDate = [NSDate date];
    NSDateComponents *this = [currCalendar components:flags fromDate:self];
    NSDateComponents *now = [currCalendar components:flags fromDate:nowDate];
    NSDateComponents *compare = [currCalendar components:flags fromDate:self toDate:nowDate options:0];
    NSString *monthKey = [NSString stringWithFormat:@"%zdmonth", this.month];
    
    if (this.year == now.year) {
        if (compare.month > 0)
            return [NSString stringWithFormat:@"%@ %zd%@", [PSUIKit localizedStringWithKey:monthKey], this.day, [PSUIKit localizedStringWithKey:@"days"]];
        
        if (compare.day > 0) {
            NSUInteger day = ABS(compare.day);
            if (day == 1)
                return [PSUIKit localizedStringWithKey:@"yesterday"];
            if (day == 2)
                return [PSUIKit localizedStringWithKey:@"before_yesterday"];
            if (day <= 10)
                return [NSString stringWithFormat:@"%tu %@", day, [PSUIKit localizedStringWithKey:@"days_ago"]];
        }
        
        if (compare.hour > 0)
            return [NSString stringWithFormat:@"%tu %@", ABS(compare.hour), [PSUIKit localizedStringWithKey:@"hours_ago"]];
        
        if (compare.minute > 0)
            return [NSString stringWithFormat:@"%tu %@", ABS(compare.minute), [PSUIKit localizedStringWithKey:@"minutes_ago"]];
        
        NSUInteger second = ABS(compare.second);
        return (second <= 10) ? [PSUIKit localizedStringWithKey:@"just_now"] : [NSString stringWithFormat:@"%tu %@", second, [PSUIKit localizedStringWithKey:@"seconds_ago"]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"ko" options:0 error:NULL];
    NSArray *matches = [expression matchesInString:formatter.locale.localeIdentifier options:0 range:NSMakeRange(0, formatter.locale.localeIdentifier.length)];
    
    if (matches.count > 0)
        return [NSString stringWithFormat:@"%zd%@ %@ %zd%@", this.year, [PSUIKit localizedStringWithKey:@"years"], [PSUIKit localizedStringWithKey:monthKey], this.day, [PSUIKit localizedStringWithKey:@"days"]];
    
    return [NSString stringWithFormat:@"%@ %zd%@, %zd", [PSUIKit localizedStringWithKey:monthKey], this.day, [PSUIKit localizedStringWithKey:@"days"], this.year];
}

@end