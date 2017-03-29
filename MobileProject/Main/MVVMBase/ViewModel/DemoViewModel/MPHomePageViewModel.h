//
//  MPHomePageViewModel.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/29.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPTabBarViewModel.h"

#import "MPProjectViewModel.h"
#import "MPSystemViewModel.h"
#import "MPTTheoryViewModel.h"

@interface MPHomePageViewModel : MPTabBarViewModel

@property (nonatomic, strong, readonly) MPProjectViewModel *projectViewModel;

@property (nonatomic, strong, readonly) MPSystemViewModel *systemViewModel;

@property (nonatomic, strong, readonly) MPTTheoryViewModel *theoryViewModel;

@end
