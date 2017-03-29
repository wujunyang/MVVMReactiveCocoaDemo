//
//  MPSettingViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/29.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPSettingViewController.h"
#import "MPSettingViewModel.h"

@interface MPSettingViewController ()

@property (nonatomic, strong, readonly) MPSettingViewModel *viewModel;

@end

@implementation MPSettingViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
