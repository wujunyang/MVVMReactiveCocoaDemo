//
//  MPNoticeListViewModel.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPNoticeListViewModel.h"
#import "MPNoticeItemViewModel.h"
#import "MPNoticeListModel.h"

@interface MPNoticeListViewModel()

@property (strong , nonatomic) id<MPNoticeProtocol> services;

@end


@implementation MPNoticeListViewModel

- (instancetype)initWithServices:(id<MPNoticeProtocol>)services
{
    if (self = [super init]) {
        
        _services = services;
        
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _noticeListData=[NSArray new];
    
    _requestDataCommand=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[_services requestNoticeDataSignal] doNext:^(MPNoticeListModel *result) {
            self.noticeListData=[NSArray arrayWithArray:result.list];
        }];
    }];
    
    _noticeDetailCommand=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    _noticeConnectionErrors=_requestDataCommand.errors;
}

@end
