//
//  LoginViewModel.h
//  MobileProject
//
//  Created by wujunyang on 16/1/11.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "RACAFNetworking.h"
#import "LogInApi.h"
#import "LoginModel.h"

@interface LoginViewModel : BaseViewModel

// 账号
@property (nonatomic, copy) NSString *username;

// 密码
@property (nonatomic, copy) NSString *password;

//返回token
@property(nonatomic,copy,readonly)NSString *access_token;

//登录验证
@property (nonatomic, strong) RACSignal *validLoginSignal;

//处理错误
@property(nonatomic,strong)RACSubject *errorSubject;

//登录事件响应
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end
