//
//  MPProjectOrderViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/29.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPProjectOrderViewController.h"
#import "MPProjectOrderViewModel.h"

@interface MPProjectOrderViewController ()

@property (nonatomic, strong, readonly) MPProjectOrderViewModel *viewModel;

@end

@implementation MPProjectOrderViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blueColor];
    
    [RACObserve(self.viewModel, projectName) subscribeNext:^(NSString *projectName) {
        NSLog(@"当前的产品名称为：%@",projectName);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
