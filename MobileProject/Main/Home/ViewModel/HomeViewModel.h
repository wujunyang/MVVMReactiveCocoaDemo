//
//  HomeViewModel.h
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACAFNetworking.h"
#import "BaseViewModel.h"
#import "HomeCellViewModel.h"
#import "pageModel.h"
#import "HomeModel.h"

@interface HomeViewModel : BaseViewModel

/**
 *  数据
 */
@property (nonatomic, strong) NSArray *items; //这里不能用NSMutableArray，因为NSMutableArray不支持KVO，不能被RACObserve
/**
 *  是否有更多数据
 */
@property (nonatomic, strong) RACSignal *hasMoreData;

/**
 *  获取数据Command
 */
@property (nonatomic, strong, readonly) RACCommand *fetchProductCommand;

/**
 *  获取更多数据
 */
@property (nonatomic, strong, readonly) RACCommand *fetchMoreProductCommand;


//返回子级对象的ViewModel
- (HomeCellViewModel *)itemViewModelForIndex:(NSInteger)index;

@end
