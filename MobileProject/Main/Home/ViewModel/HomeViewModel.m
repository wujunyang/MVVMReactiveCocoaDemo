//
//  HomeViewModel.m
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "HomeViewModel.h"

@interface HomeViewModel()
@property (nonatomic, strong) pageModel *page;
@end

static const NSInteger pageSize=10;

@implementation HomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        [self initCommand];
        
        [self initSubscribe];
    }
    return self;
}

-(void)initCommand
{
    _fetchProductCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [[self netWorkRacSignal:@(0) pageSize:@(pageSize)
                 ]
                takeUntil:self.cancelCommand.executionSignals];
    }];
    
    _fetchMoreProductCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[self netWorkRacSignal:@(self.page.page_index+1) pageSize:@(pageSize)] takeUntil:self.cancelCommand.executionSignals];
    }];
    
    _hasMoreData = [RACObserve(self, page) map:^id(pageModel *p) {
        if (p!= nil && p.page_index < p.total_count/pageSize) {
            return @YES;
        }
        return @NO;
    }];
}

-(void)initSubscribe
{
    @weakify(self);
    [[_fetchProductCommand.executionSignals switchToLatest] subscribeNext:^(id response) {
        @strongify(self);
        DDLogError(@"%@",response);
        HomeModel *homeModel=[[HomeModel alloc]initWithDictionary:response error:nil];
        self.items=homeModel.order_list;
//        if (!response.success) {
//            [self.errors sendNext:response.error];
//        }
//        else {
//            self.items = [ProductListModel objectArrayWithKeyValuesArray:response.data];
//            self.page = response.page;
//        }
    }];
    
    [[_fetchMoreProductCommand.executionSignals switchToLatest] subscribeNext:^(id response) {
        @strongify(self);
//        if (!response.success) {
//            [self.errors sendNext:response.error];
//        }
//        else {
//            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.items];
//            [arr addObjectsFromArray:[ProductListModel objectArrayWithKeyValuesArray:response.data]];
//            self.items = arr;
//            self.page = response.page;
//        }
    }];
    
    [[RACSignal merge:@[_fetchProductCommand.errors, self.fetchMoreProductCommand.errors]] subscribe:self.errors];
}

-(RACSignal *)netWorkRacSignal:(NSNumber *)page_index pageSize:(NSNumber *)page_size
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:[NSURL URLWithString:@"http://private-b9bce-zxdesignerapp.apiary-mock.com/"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    return [[[manager rac_GET:[NSString stringWithFormat:@"designer/miss/order?pageIndex=%ld&pageSize=%ld",[page_index integerValue],[page_size integerValue]] parameters:nil]
             catch:^RACSignal *(NSError *error) {
                 //对Error进行处理
                 DDLogError(@"error:%@", error);
                 //TODO: 这里可以根据error.code来判断下属于哪种网络异常，分别给出不同的错误提示
                 return [RACSignal error:[NSError errorWithDomain:@"ERROR" code:error.code userInfo:@{@"Success":@NO, @"Message":@"Bad Network!"}]];
             }]
            reduceEach:^id(id responseObject, NSURLResponse *response){
                DDLogError(@"url:%@,resp:%@",response.URL.absoluteString,responseObject);
                
                return responseObject;
            }];
}

//返回子级对象的ViewModel
- (HomeCellViewModel *)itemViewModelForIndex:(NSInteger)index
{
    return [[HomeCellViewModel alloc]initWithModel:[_items objectAtIndex:index]];
}
@end
