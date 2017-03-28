//
//  MPBaseViewModelServicesImpl.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/28.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBaseViewModelServicesImpl.h"

@implementation MPBaseViewModelServicesImpl

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)pushViewModel:(MPBaseViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(MPBaseViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)resetRootViewModel:(MPBaseViewModel *)viewModel {}

@end
