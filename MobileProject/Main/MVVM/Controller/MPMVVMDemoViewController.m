//
//  MPMVVMDemoViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPMVVMDemoViewController.h"
#import "MPNoticeListViewModel.h"

@interface MPMVVMDemoViewController ()

@property(nonatomic,strong)MPNoticeListViewModel *viewModel;

//UI
@property(nonatomic,strong)UIButton *myShowButton;

@end

@implementation MPMVVMDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"MVVM实例";
    
    self.view.backgroundColor=[UIColor redColor];
    
    [self layoutController];
    
    [self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (instancetype)initWithViewModel:(MPNoticeListViewModel *)viewModel
{
    if (self=[super init]) {
        _viewModel=viewModel;
    }
    return self;
}


-(void)layoutController
{
    [self.view addSubview:self.myShowButton];
    [self.myShowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
    }];
}

-(void)bindViewModel
{
    @weakify(self);
    [[[self.viewModel.requestDataCommand.executing skip:1] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self loadDataEnd];
        }
    }];
    
    [RACObserve(self.viewModel, noticeListData) subscribeNext:^(id x) {
        NSLog(@"请求到数据列表了");
    }];
    
    self.myShowButton.rac_command=self.viewModel.requestDataCommand;
    
    // [self.viewModel.requestDataCommand execute:@"1"];
}


-(UIButton *)myShowButton
{
    if(!_myShowButton)
    {
        _myShowButton=[UIButton new];
        [_myShowButton setTitle:@"获取数据" forState:UIControlStateNormal];
    }
    return _myShowButton;
}

-(void)loadDataEnd
{
    NSLog(@"加载数据完成，主线程刷新表格");
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"我是弹出窗" message:[NSString stringWithFormat:@"加载数据完成，主线程刷新表格"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

@end
