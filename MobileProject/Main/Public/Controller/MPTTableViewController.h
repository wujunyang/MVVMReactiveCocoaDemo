//
//  MPTTableViewController.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/1.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLTabBarController.h"
#import "MPTBaseNavigationViewController.h"

#import "MPTTheoryViewController.h"
#import "HomeViewController.h"
#import "MPMVVMDemoViewController.h"
#import "MPProjectViewController.h"
#import "MPSystemViewController.h"

#import "MPBaseViewModel.h"
#import "MPHomePageViewModel.h"

@interface MPTTableViewController : CYLTabBarController<UITabBarControllerDelegate>

- (instancetype)initWithViewModel:(MPHomePageViewModel *)viewModel;

@end
