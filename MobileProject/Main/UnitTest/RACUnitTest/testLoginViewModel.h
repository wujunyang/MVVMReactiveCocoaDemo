//
//  testLoginViewModel.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//


@interface testLoginViewModel : NSObject

// 账号
@property (nonatomic, copy) NSString *username;

// 密码
@property (nonatomic, copy) NSString *password;

//登录事件响应
@property (nonatomic, strong, readonly) RACCommand *loginCommand;


//登录验证
#pragma mark - Methods
- (RACSignal *)isValidUsernameAndPasswordSignal;

//网络请求异步调用
-(RACSignal *)netWorkRacSignal;

@end
