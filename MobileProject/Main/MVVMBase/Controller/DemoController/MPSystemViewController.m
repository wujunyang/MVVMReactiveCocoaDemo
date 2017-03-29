//
//  MPSystemViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/29.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPSystemViewController.h"
#import "MPSystemViewModel.h"

@interface MPSystemViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong, readonly) MPSystemViewModel *viewModel;

@property(nonatomic,strong)UITableView *myTableView;

@end

@implementation MPSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_myTableView) {
        _myTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator=NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
        [_myTableView.mj_header beginRefreshing];
        [self.view addSubview:_myTableView];
    }
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text=@"设置";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.viewModel.didSelectCommand execute:indexPath];
}

@end
