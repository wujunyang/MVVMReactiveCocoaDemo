//
//  MPRouter.h  用于映射ViewModel 到VC 控制器
//  MobileProject
//
//  Created by wujunyang on 2017/3/28.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPBaseViewController.h"

@interface MPRouter : NSObject

/// Retrieves the shared router instance.
///
/// Returns the shared router instance.
+ (instancetype)sharedInstance;

/// Retrieves the view corresponding to the given view model.
///
/// viewModel - The view model
///
/// Returns the view corresponding to the given view model.
- (MPBaseViewController *)viewControllerForViewModel:(MPBaseViewModel *)viewModel;

@end
