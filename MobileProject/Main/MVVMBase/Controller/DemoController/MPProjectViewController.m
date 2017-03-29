//
//  MPProjectViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/28.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPProjectViewController.h"
#import "MPProjectViewModel.h"

@interface MPProjectViewController ()

@property (nonatomic, strong, readonly) MPProjectViewModel *viewModel;

@property(nonatomic,strong)UIButton *myButton;

@property(nonatomic,strong)UIButton *myOrderButton;

@end


@implementation MPProjectViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blueColor];
    
    [self.view addSubview:self.myButton];
    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.left.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.myOrderButton];
    [self.myOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.left.mas_equalTo(20);
    }];
    
    self.myButton.rac_command=self.viewModel.goToProjectDetailCommand;
    self.myOrderButton.rac_command=self.viewModel.goToProjectOrderCommand;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton *)myButton
{
    if (!_myButton) {
        _myButton=[[UIButton alloc]init];
        _myButton.backgroundColor=[UIColor blackColor];
        [_myButton setTitle:@"跳转" forState:UIControlStateNormal];
    }
    return _myButton;
}

-(UIButton *)myOrderButton
{
    if (!_myOrderButton) {
        _myOrderButton=[[UIButton alloc]init];
        _myOrderButton.backgroundColor=[UIColor blackColor];
        [_myOrderButton setTitle:@"带参数跳转" forState:UIControlStateNormal];
    }
    return _myOrderButton;
}

@end
