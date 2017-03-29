//
//  MPSystemViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/29.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPSystemViewController.h"

@interface MPSystemViewController ()

@end

@implementation MPSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel {
    [super bindViewModel];
    
    [RACObserve(((AppDelegate*)AppDelegateInstance) , NetWorkStatus) subscribeNext:^(NSNumber *networkStatus) {
        
        if (networkStatus.integerValue == RealStatusNotReachable || networkStatus.integerValue == RealStatusUnknown) {
            NSLog(@"无网络");
        }else{
            NSLog(@"有网络");
        }
        
    }];
    

//    列表请求：
//
//    @weakify(self);
//    // 下拉刷新
//    self.findTableView.mj_header = [HTRefreshGifHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        [self.viewModel.requestDataCommand execute:@1];
//    }];
//    [[self.viewModel.requestDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
//        @strongify(self);
//        if (!executing.boolValue) {
//            [self.findTableView.mj_header endRefreshing];
//        }
//    }];
//    
//    // 加载更多
//    self.findTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
//        @strongify(self);
//        [self.viewModel.feedMoreDataCommand execute:@1];
//    }];
//    [[self.viewModel.feedMoreDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
//        @strongify(self);
//        if (!executing.boolValue) {
//            [self.findTableView.mj_footer endRefreshing];
//        }
//    }];
//    
//    [self.viewModel.requestDataCommand execute:@1];
}

@end
