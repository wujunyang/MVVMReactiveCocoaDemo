//
//  LoginViewModel.h
//  MobileProject
//
//  Created by wujunyang on 16/1/11.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACAFNetworking.h"
#import "LogInApi.h"
#import "LoginModel.h"

@interface LoginViewModel : NSObject

// 账号
@property (nonatomic, copy) NSString *username;

// 密码
@property (nonatomic, copy) NSString *password;

//返回token
@property(nonatomic,copy)NSString *access_token;

//是否加载完成
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

//登录验证
@property (nonatomic, strong, readonly) RACSignal *validLoginSignal;

//处理错误
@property(nonatomic,strong)RACSubject *errorSubject;

//登录事件响应
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end
