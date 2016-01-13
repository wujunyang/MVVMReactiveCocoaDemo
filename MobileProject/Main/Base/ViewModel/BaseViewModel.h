//
//  BaseViewModel.h
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseViewModel : NSObject

//错误集合
@property (nonatomic) RACSubject *errors;

//是否加载完成
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

//取消请求Command
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;

@end
