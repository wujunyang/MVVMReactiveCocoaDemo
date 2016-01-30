//
//  HomeViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)HomeViewModel *myHomeViewModel;
@property(nonatomic,strong)UITableView *myTableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"首页";
    self.view.backgroundColor=[UIColor redColor];

    [self initViewModel];
    [self bindViewModel];
    
    if (!_myTableView) {
        _myTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator=NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        [_myTableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HomeTableViewCell class])];
        _myTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadData)];
        _myTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
        
        [_myTableView.mj_header beginRefreshing];
        [self.view addSubview:_myTableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化
- (void)initViewModel {
    
    if (!self.myHomeViewModel) {
        self.myHomeViewModel=[[HomeViewModel alloc]init];
    }
    
    @weakify(self)
    [self.myHomeViewModel.fetchProductCommand.executing subscribeNext:^(NSNumber *executing) {
        DDLogError(@"command executing:%@", executing);
        if (!executing.boolValue) {
            @strongify(self)
            [self.myTableView.mj_header endRefreshing];
        }
    }];
    
    [self.myHomeViewModel.fetchMoreProductCommand.executing subscribeNext:^(NSNumber *executing) {
        if (!executing.boolValue) {
            @strongify(self);
            [self.myTableView.mj_footer endRefreshing];
        }
    }];
    
    [self.myHomeViewModel.errors subscribeNext:^(NSError *error) {
        DDLogError(@"something error:%@", error);
        //TODO: 这里可以选择一种合适的方式将错误信息展示出来
    }];
    
}

//绑定
- (void)bindViewModel {
    @weakify(self);
    [RACObserve(self.myHomeViewModel, items) subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView reloadData];
    }];
    
    //没有更多数据时，隐藏table的footer
    RAC(self.myTableView.mj_footer, hidden) = [self.myHomeViewModel.hasMoreData not];
}

//加载数据
-(void)LoadData
{
    [self.myHomeViewModel.fetchProductCommand execute:nil];
}

//加载更多
-(void)LoadMoreData
{
    [self.myHomeViewModel.fetchMoreProductCommand execute:nil];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myHomeViewModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeTableViewCell class]) forIndexPath:indexPath];
    cell.viewModel=[self.myHomeViewModel itemViewModelForIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
