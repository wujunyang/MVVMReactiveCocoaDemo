//
//  MPNoticeListViewModel.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPNoticeProtocol.h"

@class MPNoticeItemViewModel;

@interface MPNoticeListViewModel : NSObject

/**
 *  数据请求
 */
@property (strong, nonatomic,readonly) RACCommand *requestDataCommand;
/**
 *  错误信号
 */
@property (strong, nonatomic,readonly) RACSignal *noticeConnectionErrors;
/**
 *  通知详情
 */
@property (strong, nonatomic,readonly) RACCommand *noticeDetailCommand;
/**
 *  通知数据
 */
@property (strong, nonatomic) NSArray *noticeListData;


- (instancetype)initWithServices:(id<MPNoticeProtocol>)services;


- (MPNoticeItemViewModel *)itemViewModelForIndex:(NSInteger)index;

@end
