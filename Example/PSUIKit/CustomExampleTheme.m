//
//  CustomExampleTheme.m
//  PSUIKit
//
//  Created by Steve Kim on 5/11/16.
//  Copyright © 2016 Steve Kim. All rights reserved.
//

#import "CustomExampleTheme.h"

@implementation CustomExampleTheme

- (UIColor *)navigationBarBarTintColor {
    return [UIColor brownColor];
}

- (UIColor *)navigationBarTintColor {
    return [UIColor yellowColor];
}

- (NSDictionary *)navigationBarTitleTextAttributes {
    return @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName: [UIColor whiteColor]};
}

@end
