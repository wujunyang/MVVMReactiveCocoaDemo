//
//  MPProjectDetailViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/28.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPProjectDetailViewController.h"
#import "MPProjectDetailViewModel.h"

@interface MPProjectDetailViewController ()

@property(nonatomic,strong)UIButton *myButton;

@property(nonatomic,strong,readwrite)MPProjectDetailViewModel *viewModel;

@end

@implementation MPProjectDetailViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor redColor];
    
    self.title=@"我是标题";
    
    [self.view addSubview:self.myButton];
    
    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.left.mas_equalTo(30);
    }];
    
    @weakify(self);
    [[self.myButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        if (self.viewModel.callback) {
            self.viewModel.callback(@"我传参了，并返回");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton *)myButton
{
    if (!_myButton) {
        _myButton=[[UIButton alloc]init];
        _myButton.backgroundColor=[UIColor yellowColor];
        [_myButton setTitle:@"返回" forState:UIControlStateNormal];
    }
    return _myButton;
}

@end
