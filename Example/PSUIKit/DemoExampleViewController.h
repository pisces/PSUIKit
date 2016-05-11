//
//  DemoExampleViewController.h
//  PSUIKit
//
//  Created by Steve Kim on 5/11/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

#import <PSUIKit/PSUIKit.h>

#define exampleTitles @[@"Apply Default Navigation Theme", @"Apply Custom Navigation Theme", @"PSImagePickerViewController", @"PSAlertView", @"PSAlertView with CustomContentView", @"PSButtonBar", @"PSToastView", @"PSPreloader", @"PSAttributedDivisionLabel"]

typedef NS_ENUM(NSInteger, ExampleType) {
    ExampleTypeApplyDefaultTheme = 1,
    ExampleTypeApplyCustomTheme,
    ExampleTypePSImagePickerViewController,
    ExampleTypePSAlertView,
    ExampleTypePSAlertViewWithCustomContentView,
    ExampleTypePSButtonBar,
    ExampleTypePSToastView,
    ExampleTypePSPreloader,
    ExampleTypePSAttributedDivisionLabel
};

@interface DemoExampleViewController : PSViewController <UITableViewDataSource>
@property (nonatomic) ExampleType type;
- (id)initWithType:(ExampleType)type;
@end