//
//  MPBaseViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/28.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBaseViewController.h"

@interface MPBaseViewController()
@property (nonatomic, strong, readwrite) MPBaseViewModel *viewModel;
@end


@implementation MPBaseViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    MPBaseViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    
    return viewController;
}

- (MPBaseViewController *)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)bindViewModel {
    // System title view
    RAC(self, title) = RACObserve(self.viewModel, title);
    
    @weakify(self)

    
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        @strongify(self)
        //处理错误
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel.willDisappearSignal sendNext:nil];
}

@end
